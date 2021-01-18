///@func BaseTwerkActor(subject, target, times)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {int} times The number of times to repeat
///@desc Basis for a twerking actor
function BaseTwerkActor(_subject, _target, _times) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_time) {
		if (subject.exists()) {
			subject.set(twerkPerform(_time));
			if (timesDone >= times) {
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
			subject.set(source);
			state = GMTWERK_STATE.DONE;
			onDone();
		}
	};
	
	///@func doneOnNext()
	///@desc Mark the next iteration as last and finish there
	static doneOnNext = function() {
		times = timesDone+1;
	};
	
	///@func stop()
	///@desc Stop immediately
	static stop = function() {
		if (state >= GMTWERK_STATE.PAUSED) {
			if (snapOnStop) subject.set(source);
			state = GMTWERK_STATE.STOPPED;
			onStop();
		}
	};
	
	// Constructor
	subject = _subject;
	source = subject.get();
	target = _target;
	times = _times;
	timesDone = 0;
	snapOnStop = true;
}

///@func WaveTwerkActor(subject, target, times, wavelength, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {int} times The number of times to repeat
///@param {real|int64} wavelength The time to take to return to the start
///@param {array} <opts> Additional options
///@desc Actor for moving to and from a target value using a waveform
function WaveTwerkActor(_subject, _target, _times, _wavelength) : BaseTwerkActor(_subject, _target, _times) constructor {
	///@func twerkPerform(_time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this twerking actor
	static twerkPerform = function(_timePassed) {
		phase += _timePassed/wavelength;
		timesDone += floor(phase);
		phase = frac(phase);
		var waveHeight = (phase == 0) ? 0 : script_execute(wave, phase, positiveOnly);
		return is_undefined(blend) ? lerp(source, target, waveHeight) : script_execute(blend, source, target, waveHeight);
	};
	
	// Constructor
	phase = 0;
	wavelength = _wavelength;
	positiveOnly = true;
	wave = tw_sinusoid;
	blend = undefined;
	if (argument_count > 4) includeOpts(argument[4]);
	wavelength = convertTime(wavelength);
}

///@func WaveTwerk(subject, target, times, wavelength, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {int} times The number of times to repeat
///@param {real|int64} wavelength The time to take to return to the start
///@param {array} <opts> Additional options
///@desc Enqueue and return the actor for moving to and from a target value using a waveform
function WaveTwerk(_subject, _target, _times, _wavelength) {
	var actor = new WaveTwerkActor(_subject, _target, _times, _wavelength, (argument_count > 4) ? argument[4] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

///@func FlashTwerkActor(subject, target, times, onTime, offTime, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {int} times The number of times to repeat
///@param {real|int64} onTime The time to stay on the target value
///@param {real|int64} offTime The time to stay on the original value
///@param {array} <opts> Additional options
///@desc Actor for blinking to and from a target value
function FlashTwerkActor(_subject, _target, _times, _onTime, _offTime) : BaseTwerkActor(_subject, _target, _times) constructor {
	///@func twerkPerform(_time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this twerking actor
	static twerkPerform = function(_timePassed) {
		flashTime += _timePassed;
		while (flashTime > (flashOn ? onTime : offTime)) {
			flashTime -= flashOn ? onTime : offTime;
			flashOn = !flashOn;
			if (!flashOn) {
				++timesDone;
			}
		}
		return flashOn ? target : source;
	};
	
	// Constructor
	onTime = _onTime;
	offTime = is_undefined(_offTime) ? _onTime : _offTime;
	flashOn = true;
	flashTime = 0;
	if (argument_count > 5) includeOpts(argument[5]);
	onTime = convertTime(onTime);
	offTime = convertTime(offTime);
	flashTime = convertTime(flashTime);
}

///@func FlashTwerk(subject, target, times, onTime, offTime, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {int} times The number of times to repeat
///@param {real|int64} onTime The time to stay on the target value
///@param {real|int64} offTime The time to stay on the original value
///@param {array} <opts> Additional options
///@desc Enqueue and return an actor for blinking to and from a target value
function FlashTwerk(_subject, _target, _times, _onTime, _offTime) {
	var actor = new FlashTwerkActor(_subject, _target, _times, _onTime, _offTime, (argument_count > 5) ? argument[5] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

///@func ShakeTwerkActor(subject, target, times, length, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {int} times The number of times to repeat
///@param {real|int64} length The duration of the shake
///@param {array} <opts> Additional options
///@desc Actor for shaking a selector's value randomly in a range between the current and target values
function ShakeTwerkActor(_subject, _target, _times, _length) : BaseTwerkActor(_subject, _target, _times) constructor {
	///@func twerkPerform(_time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this twerking actor
	static twerkPerform = function(_timePassed) {
		time += _timePassed;
		while (time >= length) {
			time -= length;
			++timesDone;
		}
		var amplitude = is_undefined(decay) ? 1 : script_execute(decay, 1, 0, time/length);
		var shakeT = random(amplitude)*(positiveOnly ? 1 : choose(-1, 1));
		return is_undefined(blend) ? lerp(source, target, shakeT) : script_execute(blend, source, target, shakeT);
	};
	
	// Constructor
	time = 0;
	length = _length;
	positiveOnly = false;
	blend = undefined;
	decay = te_quadratic_out;
	if (argument_count > 4) includeOpts(argument[4]);
	time = convertTime(time);
	length = convertTime(length);
}

///@func ShakeTwerk(subject, target, times, length, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {int} times The number of times to repeat
///@param {real|int64} length The duration of the shake
///@param {array} <opts> Additional options
///@desc Enqueue and return an actor for shaking a selector's value randomly in a range between the current and target values
function ShakeTwerk(_subject, _target, _times, _length) {
	var actor = new ShakeTwerkActor(_subject, _target, _times, _length, (argument_count > 4) ? argument[4] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

///@func ChannelTwerkActor(subject, target, times, length, channel, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {int} times The number of times to repeat
///@param {real|int64} length The duration of one cycle
///@param {channel|array|animcurve} channel The animation curve channel to use for tweening values
///@param {array} <opts> Additional options
///@desc An actor for animating a value to and from a target value using an animation curve channel
function ChannelTwerkActor(_subject, _target, _times, _length, _channel) : BaseTwerkActor(_subject, _target, _times) constructor {
	///@func twerkPerform(_time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this twerking actor
	static twerkPerform = function(_timePassed) {
		time += _timePassed;
		while (time >= length) {
			time -= length;
			++timesDone;
		}
		var t = (animcurve_channel_evaluate(channel, time/length)-y0)/(y1-y0);
		return is_undefined(blend) ? lerp(source, target, t) : script_execute(blend, source, target, t);
	};
	
	// Constructor
	time = 0;
	channel = is_struct(_channel) ? _channel : (is_array(_channel) ? animcurve_get_channel(_channel[0], _channel[1]) : animcurve_get_channel(_channel, 0));
	y0 = 0;
	y1 = 1;
	length = _length;
	blend = undefined;
	if (argument_count > 5) includeOpts(argument[5]);
	time = convertTime(time);
	length = convertTime(length);
}

///@func ChannelTwerk(subject, target, times, length, channel, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {int} times The number of times to repeat
///@param {real|int64} length The duration of one cycle
///@param {channel|array|animcurve} channel The animation curve channel to use for tweening values
///@param {array} <opts> Additional options
///@desc Enqueue and return an actor for animating a value to and from a target value using an animation curve channel
function ChannelTwerk(_subject, _targetValue, _times, _length, _channel) {
	var actor = new ChannelTwerkActor(_subject, _targetValue, _times, _length, _channel, (argument_count > 5) ? argument[5] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}

///@func DubstepTwerkActor(subject, target, times, length, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {int} times The number of times to repeat
///@param {real|int64} length The duration of one cycle
///@param {array} <opts> Additional options
///@desc An actor for animating a value to and from a target value using tweening equations
function DubstepTwerkActor(_subject, _target, _times, _length) : BaseTwerkActor(_subject, _target, _times) constructor {
	///@func twerkPerform(_time)
	///@param {real} time Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this twerking actor
	static twerkPerform = function(_timePassed) {
		time += _timePassed;
		while (time >= length) {
			time -= length;
			++timesDone;
		}
		var p = time/length;
		var t = (p < 0.5) ? script_execute(forward, 0, 1, p*2) : script_execute(backward, 1, 0, (p-0.5)*2);
		return is_undefined(blend) ? lerp(source, target, t) : script_execute(blend, source, target, t);
	};
	
	// Constructor
	time = 0;
	length = _length;
	blend = undefined;
	forward = te_swing;
	backward = te_swing;
	if (argument_count > 4) includeOpts(argument[4]);
	time = convertTime(time);
	length = convertTime(length);
}

///@func DubstepTwerk(subject, target, times, length, <opts>)
///@param {GMTwerkSelector} subject The subject selector
///@param {real|int|colour} target The target value
///@param {int} times The number of times to repeat
///@param {real|int64} length The duration of one cycle
///@param {array} <opts> Additional options
///@desc Enqueue and return an actor for animating a value to and from a target value using tweening equations
function DubstepTwerk(_subject, _target, _times, _length) {
	var actor = new DubstepTwerkActor(_subject, _target, _times, _length, (argument_count > 4) ? argument[4] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}
