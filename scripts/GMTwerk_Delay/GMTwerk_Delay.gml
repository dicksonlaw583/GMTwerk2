///@func DelayActor(time, onDone)
///@param {real|int64} time Time in milliseconds (real) or steps (int64)
///@param {method} onDone Method to perform when time elapses
///@desc GMTwerk actor for simple time delay
function DelayActor(_time, _onDone) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_timePassed) {
		time -= _timePassed;
		if (time <= 0) {
			done();
		}
	};
	
	// Constructor
	time = __gmtwerk_time__(_time);
	onDone = _onDone;
	for (var i = 2; i < argument_count; i += 2) {
		variable_struct_set(self, argument[i], argument[i+1]);
	}
	
	// Done on start if time <= 0
	if (time <= 0) {
		done();
	}
}

///@func Delay(time, onDone)
///@param {real|int64} time Time in milliseconds (real) or steps (int64)
///@param {method} onDone Method to perform when time elapses
///@desc Enqueue and return a GMTwerk actor for simple time delay
function Delay(_time, _onDone) {
	var actor = new DelayActor(_time, _onDone);
	for (var i = 2; i < argument_count; i += 2) {
		variable_struct_set(actor, argument[i], argument[i+1]);
	}
	__gmtwerk_insert__(actor);
	return actor;
}
