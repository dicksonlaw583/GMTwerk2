///@class WhenToggleActor(condition, onFalseTrue, onTrueFalse, [opts])
///@param {Function} condition Method that returns a boolean value indicating state
///@param {Function,Undefined} onFalseTrue Method to perform when the condition goes from false to true
///@param {Function,Undefined} onTrueFalse Method to perform when the condition goes from true to false
///@param {array,undefined} [opts] Additional options
///@desc GMTwerk Actor for responding when a condition flips between true and false
function WhenToggleActor(condition, onFalseTrue=undefined, onTrueFalse=undefined, opts=undefined) : GMTwerkActor() constructor {
	///@func onAct()
	///@self WhenToggleActor
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
	self.condition = condition;
	self.onFalseTrue = is_undefined(onFalseTrue) ? noop : onFalseTrue;
	self.onTrueFalse = is_undefined(onTrueFalse) ? noop : onTrueFalse;
	if (!is_undefined(opts)) includeOpts(opts);
	toggleState = condition();
}

///@func WhenToggle(condition, [onFalseTrue], [onTrueFalse], [opts])
///@param {Function} condition Method that returns a boolean value indicating state
///@param {Function,Undefined} [onFalseTrue] Method to perform when the condition goes from false to true
///@param {Function,Undefined} [onTrueFalse] Method to perform when the condition goes from true to false
///@param {array,undefined} [opts] Additional options
///@return {Struct.WhenToggleActor}
///@desc Enqueue and return a GMTwerk actor for responding when a condition flips between true and false
function WhenToggle(condition, onFalseTrue=undefined, onTrueFalse=undefined, opts=undefined) {
	var actor = new WhenToggleActor(condition, onFalseTrue, onTrueFalse, opts);
	__gmtwerk_insert__(actor);
	return actor;
}
