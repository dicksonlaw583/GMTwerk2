///@func WhenTrueActor(condition, onDone)
///@param {method} condition Method that returns true for finishing, false for waiting more
///@param {method} onDone Method to perform when the condition becomes true
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
	onDone = _onDone;
	for (var i = 2; i < argument_count; i += 2) {
		variable_struct_set(self, argument[i], argument[i+1]);
	}
}

///@func WhenTrue(condition, onDone)
///@param {method} condition Method that returns true for finishing, false for waiting more
///@param {method} onDone Method to perform when the condition becomes true
///@desc Enqueue and return a GMTwerk actor for responding when a condition becomes true
function WhenTrue(_condition, _onDone) {
	var actor = new WhenTrueActor(_condition, _onDone);
	for (var i = 2; i < argument_count; i += 2) {
		variable_struct_set(actor, argument[i], argument[i+1]);
	}
	__gmtwerk_insert__(actor);
	return actor;
}
