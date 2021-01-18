///@func RepeatActor(interval, repeats, onIterate, <opts>)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {int} repeats Number of times to repeat onIterate
///@param {method} onIterate Method to perform upon each repetition
///@param {array} <opts> Additional options
///@desc GMTwerk Actor for periodic time repetitions
function RepeatActor(_interval, _repeats, _onIterate) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_timePassed) {
		time -= _timePassed;
		while (time <= 0 && repeats > 0) {
			onIterate();
			if (--repeats <= 0) {
				done();
			} else {
				time += interval;
			}
		}
	};
	
	// Constructor
	time = _interval;
	interval = time;
	repeats = _repeats;
	onIterate = _onIterate;
	if (argument_count > 3) includeOpts(argument[3]);
	
	// Convert times
	time = convertTime(time);
	interval = convertTime(interval);
}

///@func Repeat(interval, repeats, onIterate, <opts>)
///@param {real|int64} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {int} repeats Number of times to repeat onIterate
///@param {method} onIterate Method to perform upon each repetition
///@param {array} <opts> Additional options
///@desc Enqueue and return a GMTwerk actor for periodic time repetitions
function Repeat(_interval, _repeats, _onIterate) {
	var actor = new RepeatActor(_interval, _repeats, _onIterate, (argument_count > 3) ? argument[3] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}
