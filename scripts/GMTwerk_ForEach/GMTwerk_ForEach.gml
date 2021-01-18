///@func ForEachActor(interval, iterable, onIterate, <opts>)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {array|Iterable} iterable An array or a struct implementing hasNext() and next()
///@param {method} onIterate Method to perform upon each repetition (will be given value and index)
///@param {array} <opts> Additional options
///@desc GMTwerk Actor for periodic time repetitions over an array or an Iterable
function ForEachActor(_interval, _iterable, _onIterate) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_timePassed) {
		time -= _timePassed;
		while (time <= 0) {
			onIterate(iterable.value, iterable.index);
			iterable.next();
			if (iterable.hasNext()) {
				time += interval;
			} else {
				done();
				return state;
			}
		}
	};
	
	// Constructor
	time = _interval;
	interval = time;
	iterable = is_array(_iterable) ? new GMTwerkArrayIterator(_iterable) : _iterable;
	onIterate = _onIterate;
	if (argument_count > 3) includeOpts(argument[3]);
	
	// Convert times
	time = convertTime(time);
	interval = convertTime(interval);
}

///@func ForEach(interval, iterable, onIterate, <opts>)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {array|Iterable} iterable An array or a struct implementing hasNext() and next()
///@param {method} onIterate Method to perform upon each repetition (will be given value and index)
///@param {array} <opts> Additional options
///@desc Enqueue and return a GMTwerk actor for periodic time repetitions over an array or an Iterable
function ForEach(_interval, _iterable, _onIterate) {
	var actor = new ForEachActor(_interval, _iterable, _onIterate, (argument_count > 3) ? argument[3] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}
