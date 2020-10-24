///@func WhileActor(interval, condition, onIterate)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {method} condition Method that returns true for continuing, false for stopping
///@param {method} onIterate Method to perform upon each repetition
///@desc GMTwerk Actor for periodic time repetitions as long as a condition is true
function WhileActor(_interval, _condition, _onIterate) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_timePassed) {
		time -= _timePassed;
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
	time = _interval;
	interval = time;
	condition = _condition;
	onIterate = _onIterate;
	for (var i = 3; i < argument_count; i += 2) {
		variable_struct_set(self, argument[i], argument[i+1]);
	}
	
	// Convert time
	time = convertTime(time);
	interval = convertTime(interval);
}

///@func While(interval, iterable, onIterate)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {method} condition Method that returns true for continuing, false for stopping
///@param {method} onIterate Method to perform upon each repetition
///@desc Enqueue and return a GMTwerk actor for periodic time repetitions as long as a condition is true
function While(_interval, _condition, _onIterate) {
	var actor = new WhileActor(_interval, _condition, _onIterate);
	for (var i = 3; i < argument_count; i += 2) {
		variable_struct_set(actor, argument[i], argument[i+1]);
	}
	__gmtwerk_insert__(actor);
	return actor;
}
