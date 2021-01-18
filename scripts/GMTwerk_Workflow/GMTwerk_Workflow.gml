///@func WorkflowActor(actions)
///@param {method[]} actions Array of methods to run in sequence. A method can return a GMTwerk actor to wait until it finishes.
///@param {array} <opts> Additional options
///@desc GMTwerk actor for one-by-one action sequences
function WorkflowActor(_actions) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_timePassed) {
		if (!acted) {
			var currentAction = actions[actionNumber];
			currentActor = currentAction();
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
			if (++actionNumber >= array_length(actions)) {
				done();
			} else {
				acted = false;
			}
		}
	};
	
	// Constructor
	actions = _actions;
	actionNumber = 0;
	acted = false;
	currentActor = undefined;
	if (argument_count > 1) includeOpts(argument[1]);
}

///@func Workflow(actions)
///@param {method[]} actions Array of actions to run in sequence. A method can return a GMTwerk actor to wait until it finishes.
///@param {array} <opts> Additional options
///@desc Enqueue and return a GMTwerk actor for one-by-one action sequences
function Workflow(_actions) {
	var actor = new WorkflowActor(_actions, (argument_count > 1) ? argument[1] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}
