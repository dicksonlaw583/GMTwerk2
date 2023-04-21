///@class DelayActor(time, onDone, [opts])
///@param {Real} time Time in milliseconds (real) or steps (int64)
///@param {Function,undefined} onDone Method to perform when time elapses
///@param {array, undefined} [opts] Additional options
///@desc GMTwerk actor for simple time delay
function DelayActor(time, onDone=undefined, opts=undefined) : GMTwerkActor() constructor {
	///@func onAct(timePassed)
	///@self DelayActor
	///@param {real} timePassed Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(timePassed) {
		time -= timePassed;
		if (time <= 0) {
			done();
		}
	};
	
	// Constructor
	self.time = time;
	if (!is_undefined(onDone)) {
		self.onDone = onDone;
	}
	if (!is_undefined(opts)) includeOpts(opts);
	
	// Convert times
	time = convertTime(time);
}

///@func Delay(time, onDone, [opts])
///@param {Real} time Time in milliseconds (real) or steps (int64)
///@param {Function,undefined} onDone Method to perform when time elapses
///@param {array,undefined} [opts] Additional options
///@return {Struct.DelayActor}
///@desc Enqueue and return a GMTwerk actor for simple time delay
function Delay(time, onDone=undefined, opts=undefined) {
	var actor = new DelayActor(time, onDone, opts);
	__gmtwerk_insert__(actor);
	return actor;
}
