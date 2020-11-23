///@func WorkflowActor(actions)
///@param {method[]} actions Array of methods to run in sequence. A method can return a GMTwerk actor to wait until it finishes.
///@desc GMTwerk actor for one-by-one action sequences
function WorkflowActor(_actions) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_timePassed) {
		if (!acted) {
			currentActor = actions[actionNumber]();
			acted = true;
		}
		if (is_struct(currentActor)) {
			switch (currentActor.state) {
				case GMTWERK_STATE.ACTIVE:
				case GMTWERK_STATE.PAUSED:
				break;
				case GMTWERK_STATE.DONE:
					if (++actionNumber >= array_length(actions)) {
						done();
					} else {
						acted = false;
					}
				break;
				case GMTWERK_STATE.LOST:
					state = GMTWERK_STATE.LOST;
					onLost();
				break;
				default:
					stop();
				break;
			}
		} else {
			++actionNumber;
			acted = false;
		}
	};
	
	// Constructor
	actions = _actions;
	actionNumber = 0;
	acted = false;
	currentActor = undefined;
	for (var i = 1; i < argument_count; i += 2) {
		variable_struct_set(self, argument[i], argument[i+1]);
	}
}

///@func Workflow(actions)
///@param {method[]} actions Array of actions to run in sequence. A method can return a GMTwerk actor to wait until it finishes.
///@desc Enqueue and return a GMTwerk actor for one-by-one action sequences
function Workflow(_actions) {
	var actor = new WorkflowActor(_actions);
	for (var i = 1; i < argument_count; i += 2) {
		variable_struct_set(actor, argument[i], argument[i+1]);
	}
	__gmtwerk_insert__(actor);
	return actor;
}
