///@class ItineraryActor(time, itinerary, [opts])
///@param {Real} time Starting time in milliseconds (real) or steps (int64); 0 counts up, >0 counts down
///@param {array,Struct} itinerary An array of time-method pair arrays, or a struct implementing hasNext() and next() placing times in .index and methods in .value
///@param {array,undefined} [opts] Additional options
///@desc GMTwerk Actor for timeline-like action scheduling
function ItineraryActor(time, itinerary, opts=undefined) : GMTwerkActor() constructor {
	///@func onAct(timePassed)
	///@self ItineraryActor
	///@param {real} timePassed Steps (non-delta time) or milliseconds (delta time) passed
	///@return {real}
	///@desc Per-step action for this actor
	static onAct = function(timePassed) {
		if (countUp) {
			time += timePassed;
			while (time >= nextMoment) {
				nextAction();
				if (!__toNext__()) {
					done();
					return state;
				}
			}
		} else {
			time -= timePassed;
			while (time <= nextMoment) {
				nextAction();
				if (!__toNext__()) {
					done();
					return state;
				}
			}
		}
	};
	
	///@func __toNext__()
	///@self ItineraryActor
	///@ignore
	///@return {bool}
	///@desc Move nextMoment and nextAction to the next step. Return whether successful.
	static __toNext__ = function() {
		itinerary.next();
		// Has next content
		if (itinerary.hasNext()) {
			nextMoment = convertTime(itinerary.index);
			nextAction = itinerary.value;
			return true;
		}
		// No next content
		nextMoment = undefined;
		nextAction = undefined;
		return false;
	};
	
	// Constructor
	self.time = time;
	countUp = time <= 0;
	self.itinerary = is_array(itinerary) ? new GMTwerkItineraryIterator(itinerary) : itinerary;
	if (!is_undefined(opts)) includeOpts(opts);
	
	// Convert times
	self.time = convertTime(self.time);
	
	// Set up first moment if itinerary is non-empty
	if (self.itinerary.hasNext()) {
		nextMoment = convertTime(self.itinerary.index);
		nextAction = self.itinerary.value;
		// If first moment is equal to starting time, run it
		if (nextMoment == self.time) {
			nextAction();
			// If that first moment is also the last, it's done
			if (!__toNext__()) {
				done();
			}
		}
	}
	// Otherwise done right away
	else {
		nextMoment = undefined;
		nextAction = undefined;
		done();
	}
}

///@class GMTwerkItineraryIterator(itineraryArray)
///@param {Array} itineraryArray An array of time-method pair arrays
///@desc Iterator for itinerary arrays
function GMTwerkItineraryIterator(itineraryArray) constructor {
	///@func hasNext()
	///@self GMTwerkItineraryIterator
	///@return {bool}
	///@desc Return whether there is something left to iterate
	static hasNext = function() {
		return _i < array_length(itineraryArray);
	};
	
	///@func next()
	///@self GMTwerkItineraryIterator
	///@desc Move onto the next item
	static next = function() {
		if (++_i >= array_length(itineraryArray)) {
			index = undefined;
			value = undefined;
		} else {
			index = itineraryArray[_i][0];
			value = itineraryArray[_i][1];
		}
	};
	
	// Constructor
	self.itineraryArray = itineraryArray;
	_i = 0;
	if (array_length(self.itineraryArray) == 0) {
		index = undefined;
		value = undefined;
	} else {
		index = self.itineraryArray[_i][0];
		value = self.itineraryArray[_i][1];
	}
}

///@func Itinerary(time, itinerary, [opts])
///@param {Real} time Starting time in milliseconds (real) or steps (int64); 0 counts up, >0 counts down
///@param {array,struct} itinerary An array of time-method pair arrays, or a struct implementing hasNext() and next() placing times in .index and methods in .value
///@param {array,undefined} [opts] Additional options
///@return {Struct.ItineraryActor}
///@desc Enqueue and return a GMTwerk actor for timeline-like action scheduling
function Itinerary(time, itinerary, opts=undefined) {
	var actor = new ItineraryActor(time, itinerary, opts);
	__gmtwerk_insert__(actor);
	return actor;
}
