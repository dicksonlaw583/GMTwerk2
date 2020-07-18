enum GMTWERK_STATE {
	ACTIVE = 1,
	PAUSED = 0,
	DONE = -1,
	STOPPED = -2,
	LOST = -3,
};

///@func GMTwerkActor()
///@desc Base class for all GMTwerk actors
function GMTwerkActor() constructor {
	///@func noop()
	///@desc Do nothing (placeholder for callbacks)
	static noop = function() {};
	
	///@func pause(<p>)
	///@param {bool} <p> (Optional) true to pause (default), false to unpause.
	///@desc Pause (set state to inactive) or unpause (set state back to active if not in other inert states)
	static pause = function() {
		var p = (argument_count > 0) ? argument[0] : true;
		if (p && state == GMTWERK_STATE.ACTIVE) {
			state = GMTWERK_STATE.PAUSED;
			onPause(true);
		} else if (!p && state == GMTWERK_STATE.PAUSED) {
			state = GMTWERK_STATE.ACTIVE;
			onPause(false);
		}
	};
	
	///@func unpause()
	///@desc Alias for pause(false);
	static unpause = function() {
		pause(false);
	};
	
	///@func stop()
	///@desc Stop this actor immediately; do not act, and schedule for removal from queue
	static stop = function() {
		if (state >= GMTWERK_STATE.PAUSED) {
			state = GMTWERK_STATE.STOPPED;
			onStop();
		}
	};
	
	///@func done()
	///@desc Mark this actor as done immediately; do not act, and schedule for removal from queue
	static done = function() {
		if (state >= GMTWERK_STATE.PAUSED) {
			state = GMTWERK_STATE.DONE;
			onDone();
		}
	};
	
	///@func act(steps)
	///@param {real} steps Number of steps passed since last tick
	///@desc Call onAct if the actor is still live, return the state
	static act = function(steps) {
		if (state) {
			onAct(steps);
		}
		return state;
	};
	
	// Constructor
	state = GMTWERK_STATE.ACTIVE;
	onPause = noop;
	onStop = noop;
	onDone = noop;
	static onAct = noop; //Overridden by children
}

///@func GMTwerkBank()
///@desc Linked list containing all sequenced actors
function GMTwerkBank() constructor {
	_head = undefined;
	size = 0;
	
	///@func add(actor)
	///@param {GMTwerkActor} actor The actor to enqueue
	///@desc Enqueue the actor into the linked list
	static add = function(actor) {
		_head = [actor, _head];
		++size;
	};
	
	///@func act(time)
	///@param {real} time The amount of time to elapse for this tick
	///@desc Process all actors in the linked list given the elapsed time since last tick
	static act = function(time) {
		// For every node in the linked list
		var previousNode = undefined;
		var currentNode = _head;
		while (!is_undefined(currentNode)) {
			var currentActor = currentNode[0];
			// If the actor is done already or ended up done after acting, unlink it
			if (currentActor.state <= GMTWERK_STATE.DONE || currentActor.act(time) <= GMTWERK_STATE.DONE) {
				if (is_undefined(previousNode)) {
					_head = currentNode[1];
				} else {
					previousNode[@1] = currentNode[1];
				}
				--size;
			}
			// Otherwise, keep it anchored in the list
			else {
				previousNode = currentNode;
			}
			// Go to next
			currentNode = currentNode[1];
		}
	};
	
	///@func get(n)
	///@param {int} n
	///@desc Return the nth item in the linked list
	static get = function(n) {
		var currentNode = _head;
		while (n-- && !is_undefined(currentNode)) {
			currentNode = currentNode[1];
		}
		return is_undefined(currentNode) ? undefined : currentNode[0];
	};
}

///@func __gmtwerk_insert__(actor)
///@param {GMTwerkActor} actor The actor to insert into the main bank
///@desc Insert an actor into the main bank, creating the daemon if it doesn't exist already
function __gmtwerk_insert__(actor) {
	if (!instance_exists(__gmtwerk_host__)) {
		instance_create_layer(0, 0, 0, __gmtwerk_host__);
	}
	__gmtwerk_host__.__twerks__.add(actor);
}

///@func __gmtwerk_time__(time)
///@param {real|int64} time 
///@desc Convert the given time to the correct units, given current GMTwerk settings
function __gmtwerk_time__(time) {
	// Delta time in microseconds
	if (is_undefined(global.__gmtwerk_host_speed__)) {
		return real(time)*1000;
	}
	// Non-delta time in steps (int64) or milliseconds (real)
	return is_int64(time) ? real(time) : room_speed*time/1000;
}
