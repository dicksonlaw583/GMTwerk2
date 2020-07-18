///@func ForEachActor(interval, iterable, onIterate)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {array|Iterable} iterable An array or a struct implementing hasNext() and next()
///@param {method} onIterate Method to perform upon each repetition (will be given value and index)
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
	time = __gmtwerk_time__(_interval);
	interval = time;
	iterable = is_array(_iterable) ? new GMTwerkArrayIterator(_iterable) : _iterable;
	onIterate = _onIterate;
	for (var i = 3; i < argument_count; i += 2) {
		variable_struct_set(self, argument[i], argument[i+1]);
	}
	
	// Done on start if nothing to iterate
	if (!iterable.hasNext()) {
		done();
	}
}

///@func ForEach(interval, iterable, onIterate)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {array|Iterable} iterable An array or a struct implementing hasNext() and next()
///@param {method} onIterate Method to perform upon each repetition (will be given value and index)
///@desc Enqueue and return a GMTwerk actor for periodic time repetitions over an array or an Iterable
function ForEach(_interval, _iterable, _onIterate) {
	var actor = new ForEachActor(_interval, _iterable, _onIterate);
	for (var i = 3; i < argument_count; i += 2) {
		variable_struct_set(actor, argument[i], argument[i+1]);
	}
	__gmtwerk_insert__(actor);
	return actor;
}
