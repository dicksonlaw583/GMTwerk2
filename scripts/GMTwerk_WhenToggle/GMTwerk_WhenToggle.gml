///@func WhenToggleActor(condition, onFalseTrue, onTrueFalse)
///@param {method} condition Method that returns a boolean value indicating state
///@param {method|undefined} onFalseTrue Method to perform when the condition goes from false to true
///@param {method|undefined} onTrueFalse Method to perform when the condition goes from true to false
///@desc GMTwerk Actor for responding when a condition flips between true and false
function WhenToggleActor(_condition, _onFalseTrue, _onTrueFalse) : GMTwerkActor() constructor {
	///@func onAct()
	///@desc Per-step action for this actor
	static onAct = function() {
		var currentState = condition();
		if (currentState ^^ toggleState) {
			// False to true transition
			if (currentState) {
				onFalseTrue();
			}
			// True to false transition
			else {
				onTrueFalse();
			}
		}
		toggleState = currentState;
	};
	
	// Constructor
	condition = _condition;
	onFalseTrue = is_undefined(_onFalseTrue) ? noop : _onFalseTrue;
	onTrueFalse = is_undefined(_onTrueFalse) ? noop : _onTrueFalse;
	toggleState = condition();
	for (var i = 3; i < argument_count; i += 2) {
		variable_struct_set(self, argument[i], argument[i+1]);
	}
}

///@func WhenToggle(condition, onFalseTrue, onTrueFalse)
///@param {method} condition Method that returns a boolean value indicating state
///@param {method|undefined} onFalseTrue Method to perform when the condition goes from false to true
///@param {method|undefined} onTrueFalse Method to perform when the condition goes from true to false
///@desc Enqueue and return a GMTwerk actor for responding when a condition flips between true and false
function WhenToggle(_condition, _onFalseTrue, _onTrueFalse) {
	var actor = new WhenToggleActor(_condition, _onFalseTrue, _onTrueFalse);
	for (var i = 3; i < argument_count; i += 2) {
		variable_struct_set(actor, argument[i], argument[i+1]);
	}
	__gmtwerk_insert__(actor);
	return actor;
}
