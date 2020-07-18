///@func RepeatActor(interval, repeats, onRepeat)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {int} repeats Number of times to repeat onRepeat
///@param {method} onRepeat Method to perform upon each repetition
///@desc GMTwerk Actor for periodic time repetitions
function RepeatActor(_interval, _repeats, _onRepeat) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_timePassed) {
		time -= _timePassed;
		while (time <= 0 && repeats > 0) {
			onRepeat();
			if (--repeats <= 0) {
				done();
			} else {
				time += interval;
			}
		}
	};
	
	// Constructor
	time = __gmtwerk_time__(_interval);
	interval = time;
	repeats = _repeats;
	onRepeat = _onRepeat;
	for (var i = 3; i < argument_count; i += 2) {
		variable_struct_set(self, argument[i], argument[i+1]);
	}
	
	// Done on start if repeats <= 0
	if (repeats <= 0) {
		done();
	}
}

///@func Repeat(interval, repeats, onRepeat)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {int} repeats Number of times to repeat onRepeat
///@param {method} onRepeat Method to perform upon each repetition
///@desc Enqueue and return a GMTwerk actor for periodic time repetitions
function Repeat(_interval, _repeats, _onRepeat) {
	var actor = new RepeatActor(_interval, _repeats, _onRepeat);
	for (var i = 3; i < argument_count; i += 2) {
		variable_struct_set(actor, argument[i], argument[i+1]);
	}
	__gmtwerk_insert__(actor);
	return actor;
}
