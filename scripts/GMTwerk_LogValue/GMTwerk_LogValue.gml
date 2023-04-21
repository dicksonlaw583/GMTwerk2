///@class LogValueActor(subject, size, interval, [opts])
///@param {Struct.GMTwerkSelector} subject The subject to log valuese of
///@param {Real} size The size of the log
///@param {Real} interval The time interval between captures (details below)
///@param {array,undefined} [opts] Additional options
///@desc GMTwerk actor for logging historical values of a selector
///
///Interval options:
///
///- Positive: Log subject values periodically.
///
///- 0: Log only upon change of the subject value.
///
///- Negative: Log subject values periodically, but only upon change.
function LogValueActor(subject, size, interval, opts=undefined) : GMTwerkActor() constructor {
	///@func onAct(timePassed)
	///@self LogValueActor
	///@param {real} timePassed Steps (non-delta time) or milliseconds (delta time) passed
	///@return {real}
	///@desc Per-step action for this actor
	static onAct = function(timePassed) {
		// Get current value
		var currentValue;
		if (subject.exists()) {
			currentValue = subject.get();
		} else {
			onLost();
			return state;
		}
		// Untimed, log only changes
		if (interval == 0) {
			if (currentValue != lastValue) {
				log(currentValue);
				lastValue = currentValue;
			}
		}
		// Timed
		else {
			time -= timePassed;
			var _absInterval = abs(interval);
			while (time <= 0) {
				if (interval > 0) || (currentValue != lastValue) {
					log(currentValue);
					lastValue = currentValue;
				}
				time += _absInterval;
			}
		}
	};

	///@func log([val])
	///@self LogValueActor
	///@param [val] (Optional) The value to log (default: subject selector's value)
	///@return {Struct.LogValueActor}
	///@desc Insert the value into the log now
	static log = function(val=subject.get()) {
		_log[@_logPos] = val;
		if (is_infinity(size)) {
			++_logPos;
		} else {
			_logPos = (_logPos+1) mod size;
		}
		onLog(val);
		return self;
	};
	
	///@func get([n])
	///@self LogValueActor
	///@param {real} [n] (Optional) The entry to look up (see legend below) (default: -1)
	///@return {Any}
	///@desc Return a historical value from the log.
	///
	///From 0 to size-1: Logged values from oldest to newest
	///
	///From -1 to -size: Logged values from newest to oldest
	static get = function(n=-1) {
		// Infinite-sized log: Get position _logPos-n
		if (is_infinity(size)) {
			return _log[max(0, _logPos-n)];
		}
		// Finite-sized log: Get wrapped position
		return _log[(_logPos+clamp(n, -size, size-1)+size) mod size]
	};

	// Constructor
	self.subject = subject;
	self.size = size;
	self.interval = interval;
	self.time = interval;
	startValue = subject.get();
	onLog = noop;
	if (!is_undefined(opts)) includeOpts(opts);

	// Convert times
	self.time = abs(convertTime(self.time));
	self.interval = convertTime(self.interval);

	// Start log array if not infinite-sized
	_log = is_infinity(self.size) ? [] : array_create(self.size, startValue);
	_logPos = 0;
	lastValue = startValue;
}

///@func LogValue(subject, size, interval, [opts])
///@param {Struct.GMTwerkSelector} subject The subject to log valuese of
///@param {Real} size The size of the log
///@param {Real} interval The time interval between captures (details below)
///@param {array,undefined} [opts] Additional options
///@return {Struct.LogValueActor}
///@desc Enqueue and return a GMTwerk actor for logging historical values of a selector
/**
Interval options:

- >0: Log subject values periodically.

- =0: Log only upon change of the subject value.

- <0: Log subject values periodically, but only upon change.
**/
function LogValue(subject, size, interval, opts=undefined) {
	var actor = new LogValueActor(subject, size, interval, opts);
	__gmtwerk_insert__(actor);
	return actor;
}
