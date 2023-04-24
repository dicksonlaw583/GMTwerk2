///@class BaseTwerkActor(subject, target, times)
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} times The number of times to repeat
///@desc Basis for a twerking actor
function BaseTwerkActor(subject, target, times) : GMTwerkActor() constructor {
	///@func onAct(timePassed)
	///@self BaseTwerkActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(timePassed) {
		if (subject.exists()) {
			subject.set(twerkPerform(timePassed));
			if (timesDone >= times) {
				done();
			}
		} else {
			state = GMTWERK_STATE.LOST;
			onLost();
		}
	};
	
	///@func done()
	///@self BaseTwerkActor
	///@desc Mark as done
	static done = function() {
		if (state >= GMTWERK_STATE.PAUSED) {
			subject.set(source);
			state = GMTWERK_STATE.DONE;
			onDone();
		}
	};
	
	///@func doneOnNext()
	///@self BaseTwerkActor
	///@desc Mark the next iteration as last and finish there
	static doneOnNext = function() {
		times = timesDone+1;
	};
	
	///@func stop()
	///@self BaseTwerkActor
	///@desc Stop immediately
	static stop = function() {
		if (state >= GMTWERK_STATE.PAUSED) {
			if (snapOnStop) subject.set(source);
			state = GMTWERK_STATE.STOPPED;
			onStop();
		}
	};
	
	// Constructor
	self.subject = subject;
	source = self.subject.get();
	self.target = target;
	self.times = times;
	timesDone = 0;
	snapOnStop = true;
}

///@class WaveTwerkActor(subject, target, times, wavelength, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} times The number of times to repeat
///@param {Real} wavelength The time to take to return to the start
///@param {array,undefined} [opts] Additional options
///@desc Actor for moving to and from a target value using a waveform
function WaveTwerkActor(subject, target, times, wavelength, opts=undefined) : BaseTwerkActor(subject, target, times) constructor {
	///@func twerkPerform(timePassed)
	///@self WaveTwerkActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this twerking actor
	static twerkPerform = function(timePassed) {
		phase += timePassed/wavelength;
		timesDone += floor(phase);
		phase = frac(phase);
		var waveHeight = (phase == 0) ? 0 : script_execute(wave, phase, positiveOnly);
		return is_undefined(blend) ? lerp(source, target, waveHeight) : script_execute(blend, source, target, waveHeight);
	};
	
	// Constructor
	phase = 0;
	self.wavelength = wavelength;
	positiveOnly = true;
	wave = tw_sinusoid;
	blend = undefined;
	if (!is_undefined(opts)) includeOpts(opts);
	self.wavelength = convertTime(self.wavelength);
}

///@func WaveTwerk(subject, target, times, wavelength, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} times The number of times to repeat
///@param {Real} wavelength The time to take to return to the start
///@param {array,undefined} [opts] Additional options
///@return {Struct.WaveTwerkActor}
///@desc Enqueue and return the actor for moving to and from a target value using a waveform
function WaveTwerk(subject, target, times, wavelength, opts=undefined) {
	var actor = new WaveTwerkActor(subject, target, times, wavelength, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

///@class FlashTwerkActor(subject, target, times, onTime, offTime, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} times The number of times to repeat
///@param {Real} onTime The time to stay on the target value
///@param {Real} offTime The time to stay on the original value
///@param {array,undefined} [opts] Additional options
///@desc Actor for blinking to and from a target value
function FlashTwerkActor(subject, target, times, onTime, offTime=onTime, opts=undefined) : BaseTwerkActor(subject, target, times) constructor {
	///@func twerkPerform(timePassed)
	///@self FlashTwerkActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this twerking actor
	static twerkPerform = function(timePassed) {
		flashTime += timePassed;
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
	self.onTime = onTime;
	self.offTime = offTime;
	flashOn = true;
	flashTime = 0;
	if (!is_undefined(opts)) includeOpts(opts);
	self.onTime = convertTime(self.onTime);
	self.offTime = convertTime(self.offTime);
	self.flashTime = convertTime(self.flashTime);
}

///@func FlashTwerk(subject, target, times, onTime, offTime, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} times The number of times to repeat
///@param {Real} onTime The time to stay on the target value
///@param {Real} offTime The time to stay on the original value
///@param {array,undefined} [opts] Additional options
///@return {Struct.FlashTwerkActor}
///@desc Enqueue and return an actor for blinking to and from a target value
function FlashTwerk(subject, target, times, onTime, offTime, opts=undefined) {
	var actor = new FlashTwerkActor(subject, target, times, onTime, offTime, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

///@class ShakeTwerkActor(subject, target, times, length, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} times The number of times to repeat
///@param {Real} length The duration of the shake
///@param {array,undefined} [opts] Additional options
///@desc Actor for shaking a selector's value randomly in a range between the current and target values
function ShakeTwerkActor(subject, target, times, length, opts=undefined) : BaseTwerkActor(subject, target, times) constructor {
	///@func twerkPerform(timePassed)
	///@self ShakeTwerkActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this twerking actor
	static twerkPerform = function(timePassed) {
		time += timePassed;
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
	self.length = length;
	positiveOnly = false;
	blend = undefined;
	decay = te_quadratic_out;
	if (!is_undefined(opts)) includeOpts(opts);
	self.time = convertTime(self.time);
	self.length = convertTime(self.length);
}

///@func ShakeTwerk(subject, target, times, length, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} times The number of times to repeat
///@param {Real} length The duration of the shake
///@param {array,undefined} [opts] Additional options
///@return {Struct.ShakeTwerkActor}
///@desc Enqueue and return an actor for shaking a selector's value randomly in a range between the current and target values
function ShakeTwerk(subject, target, times, length, opts=undefined) {
	var actor = new ShakeTwerkActor(subject, target, times, length, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

///@class ChannelTwerkActor(subject, target, times, length, channel, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} times The number of times to repeat
///@param {Real} length The duration of one cycle
///@param {Struct.AnimCurveChannel,Array,Asset.GMAnimCurve} channel The animation curve channel to use for tweening values
///@param {array,undefined} [opts] Additional options
///@desc An actor for animating a value to and from a target value using an animation curve channel
function ChannelTwerkActor(subject, target, times, length, channel, opts=undefined) : BaseTwerkActor(subject, target, times) constructor {
	///@func twerkPerform(timePassed)
	///@self ChannelTwerkActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this twerking actor
	static twerkPerform = function(timePassed) {
		time += timePassed;
		while (time >= length) {
			time -= length;
			++timesDone;
		}
		var t = (animcurve_channel_evaluate(channel, time/length)-y0)/(y1-y0);
		return is_undefined(blend) ? lerp(source, target, t) : script_execute(blend, source, target, t);
	};
	
	// Constructor
	time = 0;
	self.channel = is_struct(channel) ? channel : (is_array(channel) ? animcurve_get_channel(channel[0], channel[1]) : animcurve_get_channel(channel, 0));
	y0 = 0;
	y1 = 1;
	self.length = length;
	blend = undefined;
	if (!is_undefined(opts)) includeOpts(opts);
	self.time = convertTime(self.time);
	self.length = convertTime(self.length);
}

///@func ChannelTwerk(subject, target, times, length, channel, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} times The number of times to repeat
///@param {Real} length The duration of one cycle
///@param {Struct.AnimCurveChannel,Array,Asset.GMAnimCurve} channel The animation curve channel to use for tweening values
///@param {array,undefined} [opts] Additional options
///@return {Struct.ChannelTwerkActor}
///@desc Enqueue and return an actor for animating a value to and from a target value using an animation curve channel
function ChannelTwerk(subject, target, times, length, channel, opts=undefined) {
	var actor = new ChannelTwerkActor(subject, target, times, length, channel, opts);
	__gmtwerk_insert__(actor);
	return actor;
}

///@class DubstepTwerkActor(subject, target, times, length, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} times The number of times to repeat
///@param {Real} length The duration of one cycle
///@param {array,undefined} [opts] Additional options
///@desc An actor for animating a value to and from a target value using tweening equations
function DubstepTwerkActor(subject, target, times, length, opts=undefined) : BaseTwerkActor(subject, target, times) constructor {
	///@func twerkPerform(timePassed)
	///@self DubstepTwerkActor
	///@param {real} timePassed Steps (non-delta time) or microseconds (delta time) passed
	///@return {Any}
	///@desc Per-step action for this twerking actor
	static twerkPerform = function(timePassed) {
		time += timePassed;
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
	self.length = length;
	blend = undefined;
	forward = te_swing;
	backward = te_swing;
	if (!is_undefined(opts)) includeOpts(opts);
	self.time = convertTime(self.time);
	self.length = convertTime(self.length);
}

///@func DubstepTwerk(subject, target, times, length, [opts])
///@param {Struct.GMTwerkSelector} subject The subject selector
///@param {Real,Constant.Color} target The target value
///@param {Real} times The number of times to repeat
///@param {Real} length The duration of one cycle
///@param {array,undefined} [opts] Additional options
///@return {Struct.DubstepTwerkActor}
///@desc Enqueue and return an actor for animating a value to and from a target value using tweening equations
function DubstepTwerk(subject, target, times, length, opts=undefined) {
	var actor = new DubstepTwerkActor(subject, target, times, length, opts);
	__gmtwerk_insert__(actor);
	return actor;
}
