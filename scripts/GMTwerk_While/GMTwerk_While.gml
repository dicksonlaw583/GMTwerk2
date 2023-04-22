///@class WhileActor(interval, condition, onIterate, [opts])
///@param {Real} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {Function} condition Method that returns true for continuing, false for stopping
///@param {Function} onIterate Method to perform upon each repetition
///@param {array,undefined} [opts] Additional options
///@desc GMTwerk Actor for periodic time repetitions as long as a condition is true
function WhileActor(interval, condition, onIterate, opts=undefined) : GMTwerkActor() constructor {
	///@func onAct(timePassed)
	///@self WhileActor
	///@param {real} timePassed Steps (non-delta time) or milliseconds (delta time) passed
	///@return {real}
	///@desc Per-step action for this actor
	static onAct = function(timePassed) {
		time -= timePassed;
		while (time <= 0) {
			// Run the iteration payload if condition is true
			// Otherwise, mark as done
			if (condition()) {
				onIterate();
			} else {
				done();
				return state;
			}
			// Restart cycle only if condition is still true (may be changed by payload)
			// Otherwise, mark as done
			if (condition()) {
				time += interval;
			} else {
				done();
				return state;
			}
		}
	};
	
	// Constructor
	self.time = interval;
	self.interval = self.time;
	self.condition = condition;
	self.onIterate = onIterate;
	if (!is_undefined(opts)) includeOpts(opts);
	
	// Convert time
	self.time = convertTime(self.time);
	self.interval = convertTime(self.interval);
}

///@func While(interval, iterable, onIterate, [opts])
///@param {Real} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {Function} condition Method that returns true for continuing, false for stopping
///@param {Function} onIterate Method to perform upon each repetition
///@param {array,undefined} [opts] Additional options
///@return {Struct.WhileActor}
///@desc Enqueue and return a GMTwerk actor for periodic time repetitions as long as a condition is true
function While(interval, condition, onIterate, opts=undefined) {
	var actor = new WhileActor(interval, condition, onIterate, opts);
	__gmtwerk_insert__(actor);
	return actor;
}
