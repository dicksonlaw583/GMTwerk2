///@func BaseTweenActor(subject, target, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@desc Basis for a tweening actor
function BaseTweenActor(_subject, _target) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_time) {
		if (subject.exists()) {
			subject.set(tweenPerform(_time));
			if (tweenIsDone()) {
				done();
			}
		} else {
			state = GMTWERK_STATE.LOST;
			onLost();
		}
	};
	
	///@func done()
	///@desc Mark as done
	static done = function() {
		if (state >= GMTWERK_STATE.PAUSED) {
			subject.set(target);
			state = GMTWERK_STATE.DONE;
			onDone();
		}
	};
	
	///@func stop()
	///@desc Stop immediately
	static stop = function() {
		if (state >= GMTWERK_STATE.PAUSED) {
			if (snapOnStop) subject.set(target);
			state = GMTWERK_STATE.STOPPED;
			onStop();
		}
	};
	
	// Constructor
	subject = _subject;
	source = subject.get();
	target = _target;
	snapOnStop = true;
}

///@func TweenActor(subject, target, time, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {real|int64} time The time to take
///@param {array} <opts> Additional options
///@desc Actor for normally tweening a value to a target
function TweenActor(_subject, _target, _time) : BaseTweenActor(_subject, _target) constructor {
	///@func tweenPerform(time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this tweening actor
	static tweenPerform = function(_timePassed) {
		elapsedTime += _timePassed;
		if (elapsedTime > time) {
			elapsedTime = time;
		}
		if (is_undefined(blend)) {
			return script_execute(type, source, target, elapsedTime/time);
		}
		return script_execute(blend, source, target, script_execute(type, 0, 1, elapsedTime/time));
	};
	
	///@func tweenIsDone()
	///@desc Return whether this tweening actor is done
	static tweenIsDone = function() {
		return elapsedTime >= time;
	};
	
	// Constructor
	time = _time;
	type = te_swing;
	blend = undefined;
	if (argument_count > 3) includeOpts(argument[3]);
	time = convertTime(time);
	elapsedTime = 0;
}

///@func Tween(subject, target, time, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {real|int64} time The time to take
///@param {array} <opts> Additional options
///@desc Enqueue and return a new normal tweening actor
function Tween(_subject, _target, _time) {
	var actor = new TweenActor(_subject, _target, _time, (argument_count > 3) ? argument[3] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

///@func ZenosTweenActor(subject, target, fraction, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {real} fraction The fraction of the difference to cover per step
///@param {array} <opts> Additional options
///@desc Actor for fractionally tweening a value to a target
function ZenosTweenActor(_subject, _target, _fraction) : BaseTweenActor(_subject, _target) constructor {
	///@func tweenPerform(time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this tweening actor
	static tweenPerform = function(_timePassed) {
		if (deltaTime) {
			var fractionPower = 1-power(1-fraction, _timePassed/game_get_speed(gamespeed_microseconds));
			latestValue = is_undefined(blend) ? lerp(subject.get(), target, fractionPower) : script_execute(blend, subject.get(), target, fractionPower);
		} else if (_timePassed == 1) {
			latestValue = is_undefined(blend) ? lerp(subject.get(), target, fraction) : script_execute(blend, subject.get(), target, fraction);
		} else {
			var fractionPower = 1-power(1-fraction, _timePassed)
			latestValue = is_undefined(blend) ? lerp(subject.get(), target, fractionPower) : script_execute(blend, subject.get(), target, fractionPower);
		}
		return latestValue;
	};
	
	///@func tweenIsDone()
	///@desc Return whether this tweening actor is done
	static tweenIsDone = function() {
		return (is_undefined(blend) ? abs(latestValue-target) : script_execute(blend, latestValue, target, undefined)) < tolerance;
	};
	
	// Constructor
	fraction = _fraction;
	tolerance = 1;
	blend = undefined;
	if (argument_count > 3) includeOpts(argument[3]);
	latestValue = subject.get();
}

///@func ZenosTween(subject, target, fraction, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {real} fraction The fraction of the difference to cover per step
///@param {array} <opts> Additional options
///@desc Enqueue and return an actor for fractionally tweening a value to a target
function ZenosTween(_subject, _target, _fraction) {
	var actor = new ZenosTweenActor(_subject, _target, _fraction, (argument_count > 3) ? argument[3] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

///@func StepTweenActor(subject, target, step, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {real|int} step The fixed step size per frame
///@param {array} <opts> Additional options
///@desc Actor for tweening a value to a target in fixed increments
function StepTweenActor(_subject, _target, _step) : BaseTweenActor(_subject, _target) constructor {
	///@func tweenPerform(time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this tweening actor
	static tweenPerform = function(_timePassed) {
		var subjectGet = subject.get();
		var remainingDistance = is_undefined(blend) ? abs(target-subjectGet) : script_execute(blend, subjectGet, target, undefined);
		var stepMultiple = min(deltaTime ? (_timePassed/game_get_speed(gamespeed_microseconds)) : _timePassed, remainingDistance/step);
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
	///@desc Return whether this tweening actor is done
	static tweenIsDone = function() {
		return (is_undefined(blend) ? abs(latestValue-target) : script_execute(blend, latestValue, target, undefined)) < step;
	};
	
	// Constructor
	step = _step;
	blend = undefined;
	integerOnly = false;
	if (argument_count > 3) includeOpts(argument[3]);
	latestValue = subject.get();
}

///@func StepTween(subject, target, step, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {real|int} step The fixed step size per act
///@param {array} <opts> Additional options
///@desc Enqueue and return an actor for tweening a value to a target in fixed increments
function StepTween(_subject, _target, _step) {
	var actor = new StepTweenActor(_subject, _target, _step, (argument_count > 3) ? argument[3] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

///@func ChannelTweenActor(subject, target, time, channel, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {real|int64} time The time to take
///@param {channel|array|animcurve} channel The animation curve channel to use for tweening values
///@param {array} <opts> Additional options
///@desc Actor for tweening a value to a target using the given animation curve channel
function ChannelTweenActor(_subject, _target, _time, _channel) : BaseTweenActor(_subject, _target) constructor {
	///@func tweenPerform(time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this tweening actor
	static tweenPerform = function(_timePassed) {
		elapsedTime += _timePassed;
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
	///@desc Return whether this tweening actor is done
	static tweenIsDone = function() {
		return elapsedTime >= time;
	};
	
	// Constructor
	time = _time;
	channel = is_struct(_channel) ? _channel : (is_array(_channel) ? animcurve_get_channel(_channel[0], _channel[1]) : animcurve_get_channel(_channel, 0));
	y0 = 0;
	y1 = 1;
	blend = undefined;
	if (argument_count > 4) includeOpts(argument[4]);
	time = convertTime(time);
	elapsedTime = 0;
}

///@func ChannelTween(subject, target, time, channel, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {real|int64} time The time to take
///@param {channel|array|animcurve} channel The animation curve channel to use for tweening values
///@param {array} <opts> Additional options
///@desc Enqueue and return a new curve channel tweening actor
function ChannelTween(_subject, _target, _time, _channel) {
	var actor = new ChannelTweenActor(_subject, _target, _time, _channel, (argument_count > 4) ? argument[4] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

