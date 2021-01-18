///@func LogValueActor(subject, size, interval, <opts>)
///@param {GMTwerkSelector} subject The subject to log valuese of
///@param {int|infinity} size The size of the log
///@param {real|int64} interval The time interval between captures (details below)
///@param {array} <opts> Additional options
///@desc GMTwerk actor for logging historical values of a selector
/**
Interval options:
- >0: Log subject values periodically.
- =0: Log only upon change of the subject value.
- <0: Log subject values periodically, but only upon change.
**/
function LogValueActor(_subject, _size, _interval) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_timePassed) {
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
			time -= _timePassed;
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

	///@func log(<val>)
	///@param <val> (Optional) The value to log (default: subject selector's value)
	///@desc Insert the value into the log now
	static log = function() {
		var val = (argument_count > 0) ? argument[0] : subject.get();
		_log[@_logPos] = val;
		if (is_infinity(size)) {
			++_logPos;
		} else {
			_logPos = (_logPos+1) mod size;
		}
		onLog(val);
		return self;
	};

	///@func get(<n>)
	///@param <n> (Optional) The entry to look up (see legend below) (default: -1)
	///@desc Return a historical value from the log
	/**
	0...size-1: Logged values from oldest to newest
	-1...-size: Logged values from newest to oldest
	**/
	static get = function() {
		var n = (argument_count > 0) ? argument[0] : -1;
		// Infinite-sized log: Get position _logPos-n
		if (is_infinity(size)) {
			return _log[max(0, _logPos-n)];
		}
		// Finite-sized log: Get wrapped position
		return _log[(_logPos+clamp(n, -size, size-1)+size) mod size]
	};

	// Constructor
	subject = _subject;
	size = _size;
	interval = _interval;
	time = _interval;
	startValue = subject.get();
	onLog = noop;
	if (argument_count > 3) includeOpts(argument[3]);

	// Convert times
	time = abs(convertTime(time));
	interval = convertTime(interval);

	// Start log array if not infinite-sized
	_log = is_infinity(size) ? [] : array_create(size, startValue);
	_logPos = 0;
	lastValue = startValue;
}

///@func LogValue(subject, size, interval, <opts>)
///@param {GMTwerkSelector} subject The subject to log valuese of
///@param {int|infinity} size The size of the log
///@param {real|int64} interval The time interval between captures (details below)
///@param {array} <opts> Additional options
///@desc Enqueue and return a GMTwerk actor for logging historical values of a selector
/**
Interval options:
- >0: Log subject values periodically.
- =0: Log only upon change of the subject value.
- <0: Log subject values periodically, but only upon change.
**/
function LogValue(_subject, _size, _interval) {
	var actor = new LogValueActor(_subject, _size, _interval, (argument_count > 3) ? argument[3] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}
