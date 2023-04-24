///@class WorkflowActor(actions, [opts])
///@param {array<function>} actions Array of methods to run in sequence. A method can return a GMTwerk actor to wait until it finishes.
///@param {array,undefined} [opts] Additional options
///@desc GMTwerk actor for one-by-one action sequences
function WorkflowActor(actions, opts=undefined) : GMTwerkActor() constructor {
	///@func onAct(timePassed)
	///@self WorkflowActor
	///@param {real} timePassed Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(timePassed) {
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
	self.actions = actions;
	actionNumber = 0;
	acted = false;
	currentActor = undefined;
	if (!is_undefined(opts)) includeOpts(opts);
}

///@func Workflow(actions, [opts])
///@param {Array<Function>} actions Array of actions to run in sequence. A method can return a GMTwerk actor to wait until it finishes.
///@param {array,undefined} [opts] Additional options
///@return {Struct.WorkflowActor}
///@desc Enqueue and return a GMTwerk actor for one-by-one action sequences
function Workflow(actions, opts=undefined) {
	var actor = new WorkflowActor(actions, opts);
	__gmtwerk_insert__(actor);
	return actor;
}
