///@func WorkflowActor(actors)
///@param {GMTwerkActor[]} actors Array of actors to run in sequence.
///@desc GMTwerk actor for one-by-one actor sequences
function WorkflowActor(_actors) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_timePassed) {
		var _actor = actors[currentActor];
		_actor.act(_timePassed);
		switch (_actor.state) {
			case GMTWERK_STATE.ACTIVE:
			case GMTWERK_STATE.PAUSED:
			break;
			case GMTWERK_STATE.DONE:
				if (++currentActor >= array_length(actors)) {
					done();
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
	};
	
	// Constructor
	actors = _actors;
	currentActor = 0;
	
	for (var i = 1; i < argument_count; i += 2) {
		variable_struct_set(self, argument[i], argument[i+1]);
	}
}

///@func Workflow(actors)
///@param {GMTwerkActor[]} actors Array of actors to run in sequence.
///@desc Enqueue and return a GMTwerk actor for one-by-one actor sequences
function Workflow(_actors) {
	var actor = new WorkflowActor(_actors);
	for (var i = 1; i < argument_count; i += 2) {
		variable_struct_set(actor, argument[i], argument[i+1]);
	}
	__gmtwerk_insert__(actor);
	return actor;
}
