///@func WhenTrueActor(condition, onDone, <opts>)
///@param {method} condition Method that returns true for finishing, false for waiting more
///@param {method} onDone Method to perform when the condition becomes true
///@param {array} <opts> Additional options
///@desc GMTwerk Actor for responding when a condition becomes true
function WhenTrueActor(_condition, _onDone) : GMTwerkActor() constructor {
	///@func onAct()
	///@desc Per-step action for this actor
	static onAct = function() {
		// Finish when condition becomes true
		if (condition()) {
			done();
		}
	};
	
	// Constructor
	condition = _condition;
	onDone = is_undefined(_onDone) ? onDone : _onDone;
	if (argument_count > 2) includeOpts(argument[2]);
}

///@func WhenTrue(condition, onDone, <opts>)
///@param {method} condition Method that returns true for finishing, false for waiting more
///@param {method} onDone Method to perform when the condition becomes true
///@param {array} <opts> Additional options
///@desc Enqueue and return a GMTwerk actor for responding when a condition becomes true
function WhenTrue(_condition, _onDone) {
	var actor = new WhenTrueActor(_condition, _onDone, (argument_count > 2) ? argument[2] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}
