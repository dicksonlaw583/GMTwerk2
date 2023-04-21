///@func WhenTrueActor(condition, onDone, [opts])
///@param {Function} condition Method that returns true for finishing, false for waiting more
///@param {Function,undefined} onDone Method to perform when the condition becomes true
///@param {array} [opts] Additional options
///@desc GMTwerk Actor for responding when a condition becomes true
function WhenTrueActor(condition, onDone=undefined, opts=undefined) : GMTwerkActor() constructor {
	///@func onAct()
	///@self WhenTrueActor
	///@desc Per-step action for this actor
	static onAct = function() {
		// Finish when condition becomes true
		if (condition()) {
			done();
		}
	};
	
	// Constructor
	self.condition = condition;
	self.onDone = is_undefined(onDone) ? self.onDone : onDone;
	if (!is_undefined(opts)) includeOpts(opts);
}

///@func WhenTrue(condition, onDone, [opts])
///@param {Function} condition Method that returns true for finishing, false for waiting more
///@param {Function,undefined} onDone Method to perform when the condition becomes true
///@param {array,undefined} [opts] Additional options
///@desc Enqueue and return a GMTwerk actor for responding when a condition becomes true
function WhenTrue(condition, onDone=undefined, opts=undefined) {
	var actor = new WhenTrueActor(condition, onDone, opts);
	__gmtwerk_insert__(actor);
	return actor;
}
