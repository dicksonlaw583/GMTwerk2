///@func ItineraryActor(time, itinerary, <opts>)
///@param {real|int64} time Starting time in milliseconds (real) or steps (int64); 0 counts up, >0 counts down
///@param {array|Iterable} itinerary An array of time-method pair arrays, or a struct implementing hasNext() and next() placing times in .index and methods in .value
///@param {array} <opts> Additional options
///@desc GMTwerk Actor for timeline-like action scheduling
function ItineraryActor(_time, _itinerary) : GMTwerkActor() constructor {
	///@func onAct(time)
	///@param {real} time Steps (non-delta time) or milliseconds (delta time) passed
	///@desc Per-step action for this actor
	static onAct = function(_timePassed) {
		if (countUp) {
			time += _timePassed;
			while (time >= nextMoment) {
				nextAction();
				if (!__toNext__()) {
					done();
					return state;
				}
			}
		} else {
			time -= _timePassed;
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
	///@desc Move nextMoment and nextAction to the next step
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
	time = _time;
	countUp = time <= 0;
	itinerary = is_array(_itinerary) ? new GMTwerkItineraryIterator(_itinerary) : _itinerary;
	if (argument_count > 2) includeOpts(argument[2]);
	
	// Convert times
	time = convertTime(time);
	
	// Set up first moment if itinerary is non-empty
	if (itinerary.hasNext()) {
		nextMoment = convertTime(itinerary.index);
		nextAction = itinerary.value;
		// If first moment is equal to starting time, run it
		if (nextMoment == time) {
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

///@func GMTwerkItineraryIterator(itineraryArray)
///@param {[real|int64,method][]} itineraryArray An array of time-method pair arrays
///@desc Iterator for itinerary arrays
function GMTwerkItineraryIterator(_itineraryArray) constructor {
	///@func hasNext()
	///@desc Return whether there is something left to iterate
	static hasNext = function() {
		return _i < array_length(itineraryArray);
	};
	
	///@func next()
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
	itineraryArray = _itineraryArray;
	_i = 0;
	if (array_length(itineraryArray) == 0) {
		index = undefined;
		value = undefined;
	} else {
		index = itineraryArray[_i][0];
		value = itineraryArray[_i][1];
	}
}

///@func Itinerary(time, itinerary, <opts>)
///@param {real|int64} time Starting time in milliseconds (real) or steps (int64); 0 counts up, >0 counts down
///@param {array|Iterable} itinerary An array of time-method pair arrays, or a struct implementing hasNext() and next() placing times in .index and methods in .value
///@param {array} <opts> Additional options
///@desc Enqueue and return a GMTwerk actor for timeline-like action scheduling
function Itinerary(_time, _itinerary) {
	var actor = new ItineraryActor(_time, _itinerary, (argument_count > 2) ? argument[2] : undefined);
	__gmtwerk_insert__(actor);
	return actor;
}
