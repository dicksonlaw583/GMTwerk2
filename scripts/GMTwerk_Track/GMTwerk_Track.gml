///@class BaseTrackActor(subject, target)
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Struct.GMTwerkSelector} target The target selector
///@desc Basis for a synchronizing a selector with another
function BaseTrackActor(subject, target) : GMTwerkActor() constructor {
	///@func onAct(timePassed)
	///@self BaseTrackActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(timePassed) {
		if (subject.exists() && target.exists()) {
			// If not already tweening
			if (!moving) {
				fromValue = subject.get();
				toValue = target.get();
				if (fromValue != toValue) {
					moving = true;
					onNudge();
				}
			}
			// If already tweening or starting (yin-yang if block intentional, want same-step trigger)
			if (moving) {
				if (continuous) {
					fromValue = subject.get();
					toValue = target.get();
				}
				subject.set(trackPerform(timePassed));
				if (trackReached()) {
					moving = false;
					subject.set(toValue);
					onReach();
				}
			}
		} else {
			moving = false;
			state = GMTWERK_STATE.LOST;
			onLost();
		}
	};
	
	///@func done()
	///@self BaseTrackActor
	///@desc Mark as done and snap
	static done = function() {
		if (state >= GMTWERK_STATE.PAUSED) {
			subject.set(target.get());
			moving = false;
			state = GMTWERK_STATE.DONE;
			onDone();
		}
	};
	
	///@func stop()
	///@self BaseTrackActor
	///@desc Stop immediately
	static stop = function() {
		if (state >= GMTWERK_STATE.PAUSED) {
			if (snapOnStop) subject.set(target.get());
			moving = false;
			state = GMTWERK_STATE.STOPPED;
			onStop();
		}
	};
	
	// Constructor
	self.subject = subject;
	fromValue = undefined;
	self.target = target;
	toValue = undefined;
	moving = false;
	onNudge = noop;
	onReach = noop;
	snapOnStop = true;
	continuous = false;
}

///@class TrackActor(subject, target, time, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Struct.GMTwerkSelector} target The target selector
///@param {Real} time The time to take
///@param {array,undefined} [opts] Additional options
///@desc Actor for gradually synchronizing a value to a target
function TrackActor(subject, target, time, opts=undefined) : BaseTrackActor(subject, target) constructor {
	///@func trackPerform(timePassed)
	///@self TrackActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this tracking actor
	static trackPerform = function(timePassed) {
		elapsedTime += timePassed;
		if (elapsedTime > time) {
			elapsedTime = time;
		}
		if (is_undefined(blend)) {
			return script_execute(type, fromValue, toValue, elapsedTime/time);
		}
		return script_execute(blend, fromValue, toValue, script_execute(type, 0, 1, elapsedTime/time));
	};
	
	///@func trackReached()
	///@self TrackActor
	///@return {Bool}
	///@desc Return whether this tracking actor is done
	static trackReached = function() {
		if (elapsedTime >= time) {
			elapsedTime = 0;
			return true;
		}
		return false;
	};
	
	// Constructor
	self.time = time;
	type = te_swing;
	blend = undefined;
	if (!is_undefined(opts)) includeOpts(opts);
	self.time = convertTime(self.time);
	elapsedTime = 0;
}

///@func Track(subject, target, time, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Struct.GMTwerkSelector} target The target selector
///@param {Real} time The time to take
///@param {array,undefined} [opts] Additional options
///@return {Struct.TrackActor}
///@desc Enqueue and return a new normal tracking actor
function Track(subject, target, time, opts=undefined) {
	var actor = new TrackActor(subject, target, time, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

///@class ZenosTrackActor(subject, target, fraction, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Struct.GMTwerkSelector} target The target selector
///@param {real} fraction The fraction of the difference to cover per step
///@param {array,undefined} [opts] Additional options
///@desc Actor for fractionally synchronizing a value to a target
function ZenosTrackActor(subject, target, fraction, opts=undefined) : BaseTrackActor(subject, target) constructor {
	///@func trackPerform(timePassed)
	///@self ZenosTrackActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this tracking actor
	static trackPerform = function(timePassed) {
		if (deltaTime) {
			var fractionPower = 1-power(1-fraction, timePassed/game_get_speed(gamespeed_microseconds));
			///Feather disable GM1041
			latestValue = is_undefined(blend) ? lerp(fromValue, toValue, fractionPower) : script_execute(blend, fromValue, toValue, fractionPower);
			///Feather enable GM1041
		} else if (timePassed == 1) {
			///Feather disable GM1041
			latestValue = is_undefined(blend) ? lerp(fromValue, toValue, fraction) : script_execute(blend, fromValue, toValue, fraction);
			///Feather enable GM1041
		} else {
			var fractionPower = 1-power(1-fraction, timePassed);
			///Feather disable GM1041
			latestValue = is_undefined(blend) ? lerp(fromValue, toValue, fractionPower) : script_execute(blend, fromValue, toValue, fractionPower);
			///Feather enable GM1041
		}
		return latestValue;
	};
	
	///@func trackReached()
	///@self ZenosTrackActor
	///@return {Bool}
	///@desc Return whether this tracking actor is done
	static trackReached = function() {
		return (is_undefined(blend) ? abs(latestValue-toValue) : script_execute(blend, latestValue, toValue, undefined)) < tolerance;
	};
	
	// Constructor
	self.fraction = fraction;
	tolerance = 1;
	blend = undefined;
	continuous = true;
	if (!is_undefined(opts)) includeOpts(opts);
	latestValue = subject.get();
}

///@func ZenosTrack(subject, target, fraction, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Struct.GMTwerkSelector} target The target selector
///@param {real} fraction The fraction of the difference to cover per step
///@param {array,undefined} [opts] Additional options
///@return {Struct.ZenosTrackActor}
///@desc Enqueue and return an actor for fractionally synchronizing a value to a target
function ZenosTrack(subject, target, fraction, opts=undefined) {
	var actor = new ZenosTrackActor(subject, target, fraction, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

///@class StepTrackActor(subject, target, step, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Struct.GMTwerkSelector} target The target selector
///@param {Real} step The fixed step size per frame
///@param {array,undefined} [opts] Additional options
///@desc Actor for synchronizing a value to a target by moving in fixed increments
function StepTrackActor(subject, target, step, opts=undefined) : BaseTrackActor(subject, target) constructor {
	///@func trackPerform(timePassed)
	///@self StepTrackActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this tracking actor
	static trackPerform = function(timePassed) {
		var remainingDistance = is_undefined(blend) ? abs(toValue-fromValue) : script_execute(blend, fromValue, toValue, undefined);
		var stepMultiple = min(deltaTime ? (timePassed/game_get_speed(gamespeed_microseconds)) : timePassed, remainingDistance/step);
		if (is_undefined(blend)) {
			latestValue = fromValue+step*stepMultiple*sign(toValue-fromValue);
		} else {
			latestValue = script_execute(blend, fromValue, toValue, step*stepMultiple/remainingDistance);
		}
		if (integerOnly && frac(latestValue) != 0) {
			latestValue = floor(latestValue);
		}
		return latestValue;
	};
	
	///@func trackReached()
	///@self StepTrackActor
	///@return {Bool}
	///@desc Return whether this tracking actor is done
	static trackReached = function() {
		return (is_undefined(blend) ? abs(latestValue-toValue) : script_execute(blend, latestValue, toValue, undefined)) < step;
	};
	
	// Constructor
	self.step = step;
	blend = undefined;
	integerOnly = false;
	continuous = true;
	if (!is_undefined(opts)) includeOpts(opts);
	latestValue = subject.get();
}

///@func StepTrack(subject, target, step, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Struct.GMTwerkSelector} target The target selector
///@param {Real} step The fixed step size per act
///@param {array,undefined} [opts] Additional options
///@return {Struct.StepTrackActor}
///@desc Enqueue and return an actor for synchoronizing a value to a target by moving in fixed increments
function StepTrack(subject, target, step, opts=undefined) {
	var actor = new StepTrackActor(subject, target, step, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

///@class ChannelTrackActor(subject, target, time, channel, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Struct.GMTwerkSelector} target The target selector
///@param {Real} time The time to take
///@param {Struct.AnimCurveChannel,Array,Asset.GMAnimCurve} channel The animation curve channel to use for tweening values
///@param {array,undefined} [opts] Additional options
///@desc Actor for gradually synchronizing a value to a target using the given animation curve channel
function ChannelTrackActor(subject, target, time, channel, opts=undefined) : BaseTrackActor(subject, target) constructor {
	///@func trackPerform(timePassed)
	///@self ChannelTrackActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this tracking actor
	static trackPerform = function(timePassed) {
		elapsedTime += timePassed;
		if (elapsedTime > time) {
			elapsedTime = time;
		}
		var channelY = (animcurve_channel_evaluate(channel, elapsedTime/time)-y0)/(y1-y0);
		if (is_undefined(blend)) {
			///Feather disable GM1041
			return lerp(fromValue, toValue, channelY);
			///Feather enable GM1041
		}
		return script_execute(blend, fromValue, toValue, channelY);
	};
	
	///@func trackReached()
	///@self ChannelTrackActor
	///@return {Bool}
	///@desc Return whether this tracking actor is done
	static trackReached = function() {
		if (elapsedTime >= time) {
			elapsedTime = 0;
			return true;
		}
		return false;
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

///@func ChannelTrack(subject, target, time, channel, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Struct.GMTwerkSelector} target The target selector
///@param {Real} time The time to take
///@param {Struct.AnimCurveChannel,Array,Asset.GMAnimCurve} channel The animation curve channel to use for tweening values
///@param {array,undefined} [opts] Additional options
///@return {Struct.ChannelTrackActor}
///@desc Enqueue and return a new curve channel tracking actor
function ChannelTrack(subject, target, time, channel, opts=undefined) {
	var actor = new ChannelTrackActor(subject, target, time, channel, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

