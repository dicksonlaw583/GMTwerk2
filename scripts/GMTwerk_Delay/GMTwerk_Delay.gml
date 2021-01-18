///@func DelayActor(time, onDone, <opts>)
///@param {real|int64} time Time in milliseconds (real) or steps (int64)
///@param {method} onDone Method to perform when time elapses
///@param {array} <opts> Additional options
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
	time = _time;
	onDone = is_undefined(_onDone) ? onDone : _onDone;
	if (argument_count > 2) includeOpts(argument[2]);
	
	// Convert times
	time = convertTime(time);
}

///@func Delay(time, onDone, <opts>)
///@param {real|int64} time Time in milliseconds (real) or steps (int64)
///@param {method} onDone Method to perform when time elapses
///@param {array} <opts> Additional options
///@desc Enqueue and return a GMTwerk actor for simple time delay
function Delay(_time, _onDone) {
	var actor = new DelayActor(_time, _onDone, (argument_count > 2) ? argument[2] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}
