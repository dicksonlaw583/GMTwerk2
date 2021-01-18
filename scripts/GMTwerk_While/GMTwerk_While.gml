///@func WhileActor(interval, condition, onIterate, <opts>)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {method} condition Method that returns true for continuing, false for stopping
///@param {method} onIterate Method to perform upon each repetition
///@param {array} <opts> Additional options
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
	if (argument_count > 3) includeOpts(argument[3]);
	
	// Convert time
	time = convertTime(time);
	interval = convertTime(interval);
}

///@func While(interval, iterable, onIterate, <opts>)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {method} condition Method that returns true for continuing, false for stopping
///@param {method} onIterate Method to perform upon each repetition
///@param {array} <opts> Additional options
///@desc Enqueue and return a GMTwerk actor for periodic time repetitions as long as a condition is true
function While(_interval, _condition, _onIterate) {
	var actor = new WhileActor(_interval, _condition, _onIterate, (argument_count > 3) ? argument[3] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}
