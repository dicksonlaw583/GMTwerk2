///@class ForEachActor(interval, iterable, onIterate, <opts>)
///@param {Real} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {array,struct} iterable An array or a struct implementing hasNext() and next()
///@param {Function} onIterate Method to perform upon each repetition (will be given value and index)
///@param {array,undefined} <opts> Additional options
///@desc GMTwerk Actor for periodic time repetitions over an array or an Iterable
function ForEachActor(interval, iterable, onIterate, opts=undefined) : GMTwerkActor() constructor {
	///@func onAct(timePassed)
	///@self ForEachActor
	///@param {real} timePassed Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(timePassed) {
		time -= timePassed;
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
	time = interval;
	self.interval = time;
	self.iterable = is_array(iterable) ? new GMTwerkArrayIterator(iterable) : iterable;
	self.onIterate = onIterate;
	if (!is_undefined(opts)) includeOpts(opts);
	
	// Convert times
	time = convertTime(time);
	self.interval = convertTime(self.interval);
}

///@func ForEach(interval, iterable, onIterate, <opts>)
///@param {Real} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {array,struct} iterable An array or a struct implementing hasNext() and next()
///@param {Function} onIterate Method to perform upon each repetition (will be given value and index)
///@param {array,undefined} <opts> Additional options
///@return {Struct.ForEachActor}
///@desc Enqueue and return a GMTwerk actor for periodic time repetitions over an array or an Iterable
function ForEach(interval, iterable, onIterate, opts=undefined) {
	var actor = new ForEachActor(interval, iterable, onIterate, opts);
	__gmtwerk_insert__(actor);
	return actor;
}
