enum GMTWERK_STATE {
	ACTIVE = 1,
	PAUSED = 0,
	DONE = -1,
	STOPPED = -2,
	LOST = -3,
	ORPHANED = -4,
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

	///@func act(time)
	///@param {real} time Time units passed since last tick
	///@desc Call onAct if the actor is still live, return the state
	static act = function(_time) {
		if (state) {
			if (owner == noone || instance_exists(owner)) {
				onAct(_time);
			} else {
				state = GMTWERK_STATE.ORPHANED;
			}
		}
		return state;
	};

	///@func convertTime(time)
	///@param {real|int64} time
	///@desc Return the equivalent of the given time in the current time mode's lowest unit of time
	static convertTime = function(_time) {
		// int64: Treat as lowest denominator of current time mode
		// If delta time enabled: Microseconds
		// If delta time disabled: Steps
		if (is_int64(_time)) {
			return real(_time);
		}
		// real: Treat as millisecond figure.
		// If delta time enabled: Convert to microsecond figure
		// If delta time disabled: Convert to steps figure
		return _time * (deltaTime ? 1000 : room_speed/1000);
	};

	///@func includeOpts(opts)
	///@param {array} opts Alternating array of parameter names and values
	///@desc Include the given options into the actor
	static includeOpts = function(params) {
		if (is_array(params)) { // BUGFIX: 2.3.2.420 - Catch argument_count failure
			for (var i = array_length(params)-2; i >= 0; i -= 2) {
				variable_struct_set(self, params[i], params[i+1]);
			}
			if (!is_undefined(bank)) {
				bank.add(self);
			}
		}
	};

	// Constructor
	state = GMTWERK_STATE.ACTIVE;
	onPause = noop;
	onStop = noop;
	onDone = noop;
	onLost = noop;
	owner = noone;
	bank = undefined;
	deltaTime = GMTWERK_DEFAULT_TIME_MODE;
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

	///@func act(<steps>, <microseconds>)
	///@param {real} time The amount of time to elapse for this tick
	///@desc Process all actors in the linked list given the elapsed time since last tick
	static act = function(steps, microseconds) {
		var needCleanup = false;
		// For every node in the linked list
		var previousNode = undefined;
		var currentNode = _head;
		while (!is_undefined(currentNode)) {
			// Act
			var currentActor = currentNode[0];
			needCleanup = currentActor.act(currentActor.deltaTime ? (is_undefined(microseconds) ? delta_time : microseconds) : (is_undefined(steps) ? GMTWERK_DEFAULT_STEP_SPEED : steps)) <= GMTWERK_STATE.DONE || needCleanup;
			// Go to next
			currentNode = currentNode[1];
		}
		// Clean finished nodes if any new ones cropped up
		if (needCleanup) {
			previousNode = undefined;
			currentNode = _head;
			// For every node in the linked list
			while (!is_undefined(currentNode)) {
				// If the actor is done already or ended up done after acting, unlink it
				var currentActor = currentNode[0];
				if (currentActor.state <= GMTWERK_STATE.DONE) {
					if (_head == currentNode) {
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

///@func GMTwerkArrayIterator(array)
///@param {array} array An array to iterate over
///@desc Iterator over the given array
function GMTwerkArrayIterator(_array) constructor {
	///@func hasNext()
	///@desc Return whether there are entries to iterate
	static hasNext = function() {
		return index < array_length(array);
	};

	///@func next()
	///@desc Go to the next entry of the array
	static next = function() {
		value = (++index < array_length(array)) ? array[index] : undefined;
	};

	// Constructor
	array = _array;
	index = 0;
	value = (array_length(array) > 0) ? array[0] : undefined;
}

///@func __gmtwerk_insert__(actor)
///@param {GMTwerkActor} actor The actor to insert into the main bank
///@desc Insert an actor into the main bank, creating the daemon if it doesn't exist already
function __gmtwerk_insert__(actor) {
	if (is_undefined(actor.bank)) {
		if (id && variable_instance_exists(id, "__gmtwerk_self_host__")) {
			__gmtwerk_self_host__.add(actor);
		} else {
			if (!instance_exists(__gmtwerk_host__)) {
				instance_create_depth(0, 0, 0, __gmtwerk_host__);
			}
			if (id) {
				actor.owner = id;
			}
			__gmtwerk_host__.__twerks__.add(actor);
		}
	}
}

///@func gmtwerk_host()
///@desc Mark this instance as self-hosting
function gmtwerk_host() {
	__gmtwerk_self_host__ = new GMTwerkBank();
}

///@func gmtwerk_run(<steps>, <microseconds>)
///@param {int} <steps>
///@param {int} <microseconds>
///@desc Run the self-hosting twerk bank
function gmtwerk_run(steps, microseconds) {
	__gmtwerk_self_host__.act(steps, microseconds);
}
