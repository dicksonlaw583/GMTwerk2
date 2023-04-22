///@func QueueValueActor(interval, onPop, [opts])
///@param {real} interval The time interval between releases
///@param {function} onPop Method to perform upon each value release
///@param {array} [opts] Additional options
///@desc GMTwerk actor for capturing incoming values and releasing them one at a time in fixed time intervals
function QueueValueActor(interval, onPop, opts=undefined) : GMTwerkActor() constructor {
	///@func onAct(timePassed)
	///@self QueueValueActor
	///@param {real} timePassed Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(timePassed) {
		// If queue is active, tick down and release value updates
		if (_dequeuePos >= 0) {
			time -= timePassed;
			while (time <= 0) {
				if (_enqueuePos-_dequeuePos > 0) {
					pop();
				} else {
					_clear(-1);
					time = interval;
					break;
				}
				time += interval;
			}
		} else {
			time = interval;
		}
	};

	///@func _clear(pos)
	///@self QueueValueActor
	///@param pos The position to reset to
	///@ignore
	///@desc (INTERNAL: GMTwerk 2) Low-level clear without triggering onClear
	static _clear = function(pos) {
		array_resize(queue, 0);
		_dequeuePos = pos;
		_enqueuePos = pos;
	};

	///@func clear()
	///@self QueueValueActor
	///@return {Struct.QueueValueActor}
	///@desc Clear the queue, triggering onClear
	static clear = function() {
		_clear(-1);
		onClear();
		return self;
	};

	///@func push(val)
	///@self QueueValueActor
	///@param val The value to capture
	///@return {Struct.QueueValueActor}
	///@desc Capture a value and put it in queue, triggering onPush
	static push = function(val) {
		onPush(val);
		if (_enqueuePos < 0) {
			onPop(val);
			++_dequeuePos;
			++_enqueuePos;
		} else {
			queue[@_enqueuePos++] = val;
		}
		return self;
	};
	
	///@func pop()
	///@self QueueValueActor
	///@return {Any}
	///@desc Dequeue and return the upcoming value, triggering onPop
	static pop = function() {
		var val = queue[_dequeuePos++];
		if (_dequeuePos >= _enqueuePos) {
			_clear(0);
		}
		onPop(val);
		return val;
	};
	
	///@func size()
	///@self QueueValueActor
	///@return {real}
	///@desc Return the number of pending values
	static size = function() {
		return _enqueuePos-_dequeuePos;
	};

	///@func top(n)
	///@self QueueValueActor
	///@param {Real} [n] (Optional) The entry to look up past the current head (default: 0)
	///@return {Any}
	///@desc Return the (n+1)th next entry, undefined if there is nothing
	static top = function(n=0) {
		var _targetPos = n+_dequeuePos;
		return (_targetPos < _enqueuePos) ? queue[_targetPos] : undefined;
	};

	// Constructor
	self.interval = interval;
	time = interval;
	self.onPop = onPop;
	onPush = noop;
	onClear = noop;
	if (!is_undefined(opts)) includeOpts(opts);

	// Convert times
	self.time = convertTime(self.time);
	self.interval = convertTime(self.interval);

	// Start with empty queue
	queue = [];
	_dequeuePos = -1;
	_enqueuePos = -1;
}

///@func QueueValue(interval, onPop, [opts])
///@param {real} interval The time interval to pop values at
///@param {function} onPop Method to perform upon each value release
///@param {array} [opts] Additional options
///@desc Enqueue and return a GMTwerk actor for capturing incoming values and releasing them one at a time in fixed time intervals
function QueueValue(interval, onPop, opts=undefined) {
	var actor = new QueueValueActor(interval, onPop, opts);
	__gmtwerk_insert__(actor);
	return actor;
}