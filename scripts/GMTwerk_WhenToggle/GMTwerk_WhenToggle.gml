///@func WhenToggleActor(condition, onFalseTrue, onTrueFalse, <opts>)
///@param {method} condition Method that returns a boolean value indicating state
///@param {method|undefined} onFalseTrue Method to perform when the condition goes from false to true
///@param {method|undefined} onTrueFalse Method to perform when the condition goes from true to false
///@param {array} <opts> Additional options
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
	if (argument_count > 3) includeOpts(argument[3]);
	toggleState = condition();
}

///@func WhenToggle(condition, onFalseTrue, onTrueFalse, <opts>)
///@param {method} condition Method that returns a boolean value indicating state
///@param {method|undefined} onFalseTrue Method to perform when the condition goes from false to true
///@param {method|undefined} onTrueFalse Method to perform when the condition goes from true to false
///@param {array} <opts> Additional options
///@desc Enqueue and return a GMTwerk actor for responding when a condition flips between true and false
function WhenToggle(_condition, _onFalseTrue, _onTrueFalse) {
	var actor = new WhenToggleActor(_condition, _onFalseTrue, _onTrueFalse, (argument_count > 3) ? argument[3] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}
