///@class RepeatActor(interval, repeats, onIterate, [opts])
///@param {Real} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {Real} repeats Number of times to repeat onIterate
///@param {Function} onIterate Method to perform upon each repetition
///@param {array,undefined} [opts] Additional options
///@desc GMTwerk Actor for periodic time repetitions
function RepeatActor(interval, repeats, onIterate, opts=undefined) : GMTwerkActor() constructor {
	///@func onAct(timePassed)
	///@self RepeatActor
	///@param {real} timePassed Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(timePassed) {
		time -= timePassed;
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
	self.time = interval;
	self.interval = self.time;
	self.repeats = repeats;
	self.onIterate = onIterate;
	if (!is_undefined(opts)) includeOpts(opts);
	
	// Convert times
	self.time = convertTime(self.time);
	self.interval = convertTime(self.interval);
}

///@func Repeat(interval, repeats, onIterate, [opts])
///@param {Real} interval Time between repetitions in milliseconds (real) or steps (int64)
///@param {Real} repeats Number of times to repeat onIterate
///@param {Function} onIterate Method to perform upon each repetition
///@param {array,undefined} [opts] Additional options
///@return {Struct.RepeatActor}
///@desc Enqueue and return a GMTwerk actor for periodic time repetitions
function Repeat(interval, repeats, onIterate, opts=undefined) {
	var actor = new RepeatActor(interval, repeats, onIterate, opts);
	__gmtwerk_insert__(actor);
	return actor;
}
