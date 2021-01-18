///@func BaseTrackActor(subject, target)
///@param {GMTwerkSelector} subject The subject selector
///@param {GMTwerkSelector} target The target selector
///@desc Basis for a synchronizing a selector with another
function BaseTrackActor(_subject, _target) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_time) {
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
				subject.set(trackPerform(_time));
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
	subject = _subject;
	fromValue = undefined;
	target = _target;
	toValue = undefined;
	moving = false;
	onNudge = noop;
	onReach = noop;
	snapOnStop = true;
	continuous = false;
}

///@func TrackActor(subject, target, time, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {GMTwerkSelector} target The target selector
///@param {real|int64} time The time to take
///@param {array} <opts> Additional options
///@desc Actor for gradually synchronizing a value to a target
function TrackActor(_subject, _target, _time) : BaseTrackActor(_subject, _target) constructor {
	///@func trackPerform(time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this tracking actor
	static trackPerform = function(_timePassed) {
		elapsedTime += _timePassed;
		if (elapsedTime > time) {
			elapsedTime = time;
		}
		if (is_undefined(blend)) {
			return script_execute(type, fromValue, toValue, elapsedTime/time);
		}
		return script_execute(blend, fromValue, toValue, script_execute(type, 0, 1, elapsedTime/time));
	};
	
	///@func trackReached()
	///@desc Return whether this tracking actor is done
	static trackReached = function() {
		if (elapsedTime >= time) {
			elapsedTime = 0;
			return true;
		}
		return false;
	};
	
	// Constructor
	time = _time;
	type = te_swing;
	blend = undefined;
	if (argument_count > 3) includeOpts(argument[3]);
	time = convertTime(time);
	elapsedTime = 0;
}

///@func Track(subject, target, time, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {GMTwerkSelector} target The target selector
///@param {real|int64} time The time to take
///@param {array} <opts> Additional options
///@desc Enqueue and return a new normal tracking actor
function Track(_subject, _target, _time) {
	var actor = new TrackActor(_subject, _target, _time, (argument_count > 3) ? argument[3] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

///@func ZenosTrackActor(subject, target, fraction, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {GMTwerkSelector} target The target selector
///@param {real} fraction The fraction of the difference to cover per step
///@param {array} <opts> Additional options
///@desc Actor for fractionally synchronizing a value to a target
function ZenosTrackActor(_subject, _target, _fraction) : BaseTrackActor(_subject, _target) constructor {
	///@func trackPerform(time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this tracking actor
	static trackPerform = function(_timePassed) {
		if (deltaTime) {
			var fractionPower = 1-power(1-fraction, _timePassed/game_get_speed(gamespeed_microseconds));
			latestValue = is_undefined(blend) ? lerp(fromValue, toValue, fractionPower) : script_execute(blend, fromValue, toValue, fractionPower);
		} else if (_timePassed == 1) {
			latestValue = is_undefined(blend) ? lerp(fromValue, toValue, fraction) : script_execute(blend, fromValue, toValue, fraction);
		} else {
			var fractionPower = 1-power(1-fraction, _timePassed)
			latestValue = is_undefined(blend) ? lerp(fromValue, toValue, fractionPower) : script_execute(blend, fromValue, toValue, fractionPower);
		}
		return latestValue;
	};
	
	///@func trackReached()
	///@desc Return whether this tracking actor is done
	static trackReached = function() {
		return (is_undefined(blend) ? abs(latestValue-toValue) : script_execute(blend, latestValue, toValue, undefined)) < tolerance;
	};
	
	// Constructor
	fraction = _fraction;
	tolerance = 1;
	blend = undefined;
	continuous = true;
	if (argument_count > 3) includeOpts(argument[3]);
	latestValue = subject.get();
}

///@func ZenosTrack(subject, target, fraction, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {GMTwerkSelector} target The target selector
///@param {real} fraction The fraction of the difference to cover per step
///@param {array} <opts> Additional options
///@desc Enqueue and return an actor for fractionally synchronizing a value to a target
function ZenosTrack(_subject, _target, _fraction) {
	var actor = new ZenosTrackActor(_subject, _target, _fraction, (argument_count > 3) ? argument[3] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

///@func StepTrackActor(subject, target, step, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {GMTwerkSelector} target The target selector
///@param {real|int} step The fixed step size per frame
///@param {array} <opts> Additional options
///@desc Actor for synchronizing a value to a target by moving in fixed increments
function StepTrackActor(_subject, _target, _step) : BaseTrackActor(_subject, _target) constructor {
	///@func trackPerform(time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this tracking actor
	static trackPerform = function(_timePassed) {
		var remainingDistance = is_undefined(blend) ? abs(toValue-fromValue) : script_execute(blend, fromValue, toValue, undefined);
		var stepMultiple = min(deltaTime ? (_timePassed/game_get_speed(gamespeed_microseconds)) : _timePassed, remainingDistance/step);
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
	///@desc Return whether this tracking actor is done
	static trackReached = function() {
		return (is_undefined(blend) ? abs(latestValue-toValue) : script_execute(blend, latestValue, toValue, undefined)) < step;
	};
	
	// Constructor
	step = _step;
	blend = undefined;
	integerOnly = false;
	continuous = true;
	if (argument_count > 3) includeOpts(argument[3]);
	latestValue = subject.get();
}

///@func StepTrack(subject, target, step, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {GMTwerkSelector} target The target selector
///@param {real|int} step The fixed step size per act
///@param {array} <opts> Additional options
///@desc Enqueue and return an actor for synchoronizing a value to a target by moving in fixed increments
function StepTrack(_subject, _target, _step) {
	var actor = new StepTrackActor(_subject, _target, _step, (argument_count > 3) ? argument[3] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

///@func ChannelTrackActor(subject, target, time, channel, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {GMTwerkSelector} target The target selector
///@param {real|int64} time The time to take
///@param {channel|array|animcurve} channel The animation curve channel to use for tweening values
///@param {array} <opts> Additional options
///@desc Actor for gradually synchronizing a value to a target using the given animation curve channel
function ChannelTrackActor(_subject, _target, _time, _channel) : BaseTrackActor(_subject, _target) constructor {
	///@func trackPerform(time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this tracking actor
	static trackPerform = function(_timePassed) {
		elapsedTime += _timePassed;
		if (elapsedTime > time) {
			elapsedTime = time;
		}
		var channelY = (animcurve_channel_evaluate(channel, elapsedTime/time)-y0)/(y1-y0);
		if (is_undefined(blend)) {
			return lerp(fromValue, toValue, channelY);
		}
		return script_execute(blend, fromValue, toValue, channelY);
	};
	
	///@func trackReached()
	///@desc Return whether this tracking actor is done
	static trackReached = function() {
		if (elapsedTime >= time) {
			elapsedTime = 0;
			return true;
		}
		return false;
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

///@func ChannelTrack(subject, target, time, channel, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {GMTwerkSelector} target The target selector
///@param {real|int64} time The time to take
///@param {channel|array|animcurve} channel The animation curve channel to use for tweening values
///@param {array} <opts> Additional options
///@desc Enqueue and return a new curve channel tracking actor
function ChannelTrack(_subject, _target, _time, _channel) {
	var actor = new ChannelTrackActor(_subject, _target, _time, _channel, (argument_count > 4) ? argument[4] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

