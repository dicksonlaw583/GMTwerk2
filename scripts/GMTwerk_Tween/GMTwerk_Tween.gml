///@class BaseTweenActor(subject, target, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@desc Basis for a tweening actor
function BaseTweenActor(subject, target) : GMTwerkActor() constructor {
	///@func onAct(timePassed)
	///@self BaseTweenActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(timePassed) {
		if (subject.exists()) {
			subject.set(tweenPerform(timePassed));
			if (tweenIsDone()) {
				done();
			}
		} else {
			state = GMTWERK_STATE.LOST;
			onLost();
		}
	};
	
	///@func done()
	///@self BaseTweenActor
	///@desc Mark as done
	static done = function() {
		if (state >= GMTWERK_STATE.PAUSED) {
			subject.set(target);
			state = GMTWERK_STATE.DONE;
			onDone();
		}
	};
	
	///@func stop()
	///@self BaseTweenActor
	///@desc Stop immediately
	static stop = function() {
		if (state >= GMTWERK_STATE.PAUSED) {
			if (snapOnStop) subject.set(target);
			state = GMTWERK_STATE.STOPPED;
			onStop();
		}
	};
	
	// Constructor
	self.subject = subject;
	source = self.subject.get();
	self.target = target;
	snapOnStop = true;
}

///@class TweenActor(subject, target, time, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} time The time to take
///@param {array,undefined} [opts] Additional options
///@desc Actor for normally tweening a value to a target
function TweenActor(subject, target, time, opts=undefined) : BaseTweenActor(subject, target) constructor {
	///@func tweenPerform(timePassed)
	///@self TweenActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this tweening actor
	static tweenPerform = function(timePassed) {
		elapsedTime += timePassed;
		if (elapsedTime > time) {
			elapsedTime = time;
		}
		if (is_undefined(blend)) {
			return script_execute(type, source, target, elapsedTime/time);
		}
		return script_execute(blend, source, target, script_execute(type, 0, 1, elapsedTime/time));
	};
	
	///@func tweenIsDone()
	///@self TweenActor
	///@return {bool}
	///@desc Return whether this tweening actor is done
	static tweenIsDone = function() {
		return elapsedTime >= time;
	};
	
	// Constructor
	self.time = time;
	type = te_swing;
	blend = undefined;
	if (!is_undefined(opts)) includeOpts(opts);
	self.time = convertTime(self.time);
	elapsedTime = 0;
}

///@func Tween(subject, target, time, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} time The time to take
///@param {array,undefined} [opts] Additional options
///@desc Enqueue and return a new normal tweening actor
function Tween(subject, target, time, opts=undefined) {
	var actor = new TweenActor(subject, target, time, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

///@class ZenosTweenActor(subject, target, fraction, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {real} fraction The fraction of the difference to cover per step
///@param {array,undefined} [opts] Additional options
///@desc Actor for fractionally tweening a value to a target
function ZenosTweenActor(subject, target, fraction, opts=undefined) : BaseTweenActor(subject, target) constructor {
	///@func tweenPerform(timePassed)
	///@self ZenosTweenActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this tweening actor
	static tweenPerform = function(timePassed) {
		if (deltaTime) {
			var fractionPower = 1-power(1-fraction, timePassed/game_get_speed(gamespeed_microseconds));
			latestValue = is_undefined(blend) ? lerp(subject.get(), target, fractionPower) : script_execute(blend, subject.get(), target, fractionPower);
		} else if (timePassed == 1) {
			latestValue = is_undefined(blend) ? lerp(subject.get(), target, fraction) : script_execute(blend, subject.get(), target, fraction);
		} else {
			var fractionPower = 1-power(1-fraction, timePassed)
			latestValue = is_undefined(blend) ? lerp(subject.get(), target, fractionPower) : script_execute(blend, subject.get(), target, fractionPower);
		}
		return latestValue;
	};
	
	///@func tweenIsDone()
	///@self ZenosTweenActor
	///@return {Bool}
	///@desc Return whether this tweening actor is done
	static tweenIsDone = function() {
		return (is_undefined(blend) ? abs(latestValue-target) : script_execute(blend, latestValue, target, undefined)) < tolerance;
	};
	
	// Constructor
	self.fraction = fraction;
	tolerance = 1;
	blend = undefined;
	if (!is_undefined(opts)) includeOpts(opts);
	latestValue = self.subject.get();
}

///@func ZenosTween(subject, target, fraction, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {real} fraction The fraction of the difference to cover per step
///@param {array,undefined} [opts] Additional options
///@return {Struct.ZenosTweenActor}
///@desc Enqueue and return an actor for fractionally tweening a value to a target
function ZenosTween(subject, target, fraction, opts=undefined) {
	var actor = new ZenosTweenActor(subject, target, fraction, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

///@class StepTweenActor(subject, target, step, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} step The fixed step size per frame
///@param {array,undefined} [opts] Additional options
///@desc Actor for tweening a value to a target in fixed increments
function StepTweenActor(subject, target, step, opts=undefined) : BaseTweenActor(subject, target) constructor {
	///@func tweenPerform(timePassed)
	///@self StepTweenActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this tweening actor
	static tweenPerform = function(timePassed) {
		var subjectGet = subject.get();
		var remainingDistance = is_undefined(blend) ? abs(target-subjectGet) : script_execute(blend, subjectGet, target, undefined);
		var stepMultiple = min(deltaTime ? (timePassed/game_get_speed(gamespeed_microseconds)) : timePassed, remainingDistance/step);
		if (is_undefined(blend)) {
			latestValue = subjectGet+step*stepMultiple*sign(target-subjectGet);
		} else {
			latestValue = script_execute(blend, subjectGet, target, step*stepMultiple/remainingDistance);
		}
		if (integerOnly && frac(latestValue) != 0) {
			latestValue = floor(latestValue);
		}
		return latestValue;
	};
	
	///@func tweenIsDone()
	///@self StepTweenActor
	///@return {bool}
	///@desc Return whether this tweening actor is done
	static tweenIsDone = function() {
		return (is_undefined(blend) ? abs(latestValue-target) : script_execute(blend, latestValue, target, undefined)) < step;
	};
	
	// Constructor
	self.step = step;
	blend = undefined;
	integerOnly = false;
	if (!is_undefined(opts)) includeOpts(opts);
	latestValue = self.subject.get();
}

///@func StepTween(subject, target, step, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} step The fixed step size per act
///@param {array,undefined} [opts] Additional options
///@return {Struct.StepTweenActor}
///@desc Enqueue and return an actor for tweening a value to a target in fixed increments
function StepTween(subject, target, step, opts=undefined) {
	var actor = new StepTweenActor(subject, target, step, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

///@class ChannelTweenActor(subject, target, time, channel, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} time The time to take
///@param {Struct.AnimCurveChannel,Array,Asset.GMAnimCurve} channel The animation curve channel to use for tweening values
///@param {array,undefined} [opts] Additional options
///@desc Actor for tweening a value to a target using the given animation curve channel
function ChannelTweenActor(subject, target, time, channel, opts=undefined) : BaseTweenActor(subject, target) constructor {
	///@func tweenPerform(timePassed)
	///@self ChannelTweenActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this tweening actor
	static tweenPerform = function(timePassed) {
		elapsedTime += timePassed;
		if (elapsedTime > time) {
			elapsedTime = time;
		}
		var channelY = (animcurve_channel_evaluate(channel, elapsedTime/time)-y0)/(y1-y0);
		if (is_undefined(blend)) {
			return lerp(source, target, channelY);
		}
		return script_execute(blend, source, target, channelY);
	};
	
	///@func tweenIsDone()
	///@self ChannelTweenActor
	///@return {bool}
	///@desc Return whether this tweening actor is done
	static tweenIsDone = function() {
		return elapsedTime >= time;
	};
	
	// Constructor
	self.time = time;
	self.channel = is_struct(channel) ? channel : (is_array(channel) ? animcurve_get_channel(channel[0], channel[1]) : animcurve_get_channel(channel, 0));
	y0 = 0;
	y1 = 1;
	blend = undefined;
	if (!is_undefined(opts)) includeOpts(opts);
	self.time = convertTime(self.time);
	elapsedTime = 0;
}

///@func ChannelTween(subject, target, time, channel, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} time The time to take
///@param {Struct.AnimCurveChannel,Array,Asset.GMAnimCurve} channel The animation curve channel to use for tweening values
///@param {array,undefined} [opts] Additional options
///@return {Struct.ChannelTweenActor}
///@desc Enqueue and return a new curve channel tweening actor
function ChannelTween(subject, target, time, channel, opts=undefined) {
	var actor = new ChannelTweenActor(subject, target, time, channel, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

