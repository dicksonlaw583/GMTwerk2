///@func gmtk2_test_itinerary()
///@desc Test GMTwerk 2's Itinerary actor.
function gmtk2_test_itinerary() {
	var itineraryActor;
	var subject = {
		hits: [0, 0, 0],
		hit0: function() { ++hits[@0]; },
		hit1: function() { ++hits[@1]; },
		hit2: function() { ++hits[@2]; },
	};
	
	#region ItineraryActor countup
	subject.hits = [0, 0, 0];
	itineraryActor = new ItineraryActor(0, [
		[int64(2), subject.hit0],
		[int64(3), subject.hit1],
		[int64(5), subject.hit2],
	]);
	assert_equal(itineraryActor.state, GMTWERK_STATE.ACTIVE, "ItineraryActor countup 0a");
	assert_equal(subject.hits, [0, 0, 0], "ItineraryActor countup 0b");
	assert_equal(itineraryActor.act(1), GMTWERK_STATE.ACTIVE, "ItineraryActor countup 1a");
	assert_equal(subject.hits, [0, 0, 0], "ItineraryActor countup 1b");
	assert_equal(itineraryActor.act(1), GMTWERK_STATE.ACTIVE, "ItineraryActor countup 2a");
	assert_equal(subject.hits, [1, 0, 0], "ItineraryActor countup 2b");
	assert_equal(itineraryActor.act(1), GMTWERK_STATE.ACTIVE, "ItineraryActor countup 3a");
	assert_equal(subject.hits, [1, 1, 0], "ItineraryActor countup 3b");
	assert_equal(itineraryActor.act(1), GMTWERK_STATE.ACTIVE, "ItineraryActor countup 4a");
	assert_equal(subject.hits, [1, 1, 0], "ItineraryActor countup 4b");
	assert_equal(itineraryActor.act(1), GMTWERK_STATE.DONE, "ItineraryActor countup 5a");
	assert_equal(subject.hits, [1, 1, 1], "ItineraryActor countup 5b");
	#endregion
	
	#region ItineraryActor countup empty
	subject.hits = [0, 0, 0];
	itineraryActor = new ItineraryActor(0, []);
	assert_equal(itineraryActor.state, GMTWERK_STATE.DONE, "ItineraryActor countup empty");
	#endregion
	
	#region Itinerary Actor countup solo
	subject.hits = [0, 0, 0];
	itineraryActor = new ItineraryActor(0, [[0, subject.hit0]]);
	assert_equal(itineraryActor.state, GMTWERK_STATE.DONE, "ItineraryActor countup solo 0a");
	assert_equal(subject.hits, [1, 0, 0], "ItineraryActor countup solo 0b");
	#endregion

	#region ItineraryActor countdown
	subject.hits = [0, 0, 0];
	itineraryActor = new ItineraryActor(int64(6), [
		[int64(4), subject.hit0],
		[int64(3), subject.hit1],
		[int64(1), subject.hit2],
	]);
	assert_equal(itineraryActor.state, GMTWERK_STATE.ACTIVE, "ItineraryActor countdown 0a");
	assert_equal(subject.hits, [0, 0, 0], "ItineraryActor countdown 0b");
	assert_equal(itineraryActor.act(1), GMTWERK_STATE.ACTIVE, "ItineraryActor countdown 1a");
	assert_equal(subject.hits, [0, 0, 0], "ItineraryActor countdown 1b");
	assert_equal(itineraryActor.act(1), GMTWERK_STATE.ACTIVE, "ItineraryActor countdown 2a");
	assert_equal(subject.hits, [1, 0, 0], "ItineraryActor countdown 2b");
	assert_equal(itineraryActor.act(1), GMTWERK_STATE.ACTIVE, "ItineraryActor countdown 3a");
	assert_equal(subject.hits, [1, 1, 0], "ItineraryActor countdown 3b");
	assert_equal(itineraryActor.act(1), GMTWERK_STATE.ACTIVE, "ItineraryActor countdown 4a");
	assert_equal(subject.hits, [1, 1, 0], "ItineraryActor countdown 4b");
	assert_equal(itineraryActor.act(1), GMTWERK_STATE.DONE, "ItineraryActor countdown 5a");
	assert_equal(subject.hits, [1, 1, 1], "ItineraryActor countdown 5b");
	#endregion
	
	#region ItineraryActor countdown empty
	subject.hits = [0, 0, 0];
	itineraryActor = new ItineraryActor(int64(6), []);
	assert_equal(itineraryActor.state, GMTWERK_STATE.DONE, "ItineraryActor countdown empty");
	#endregion
	
	#region Itinerary Actor countdown solo
	subject.hits = [0, 0, 0];
	itineraryActor = new ItineraryActor(6000, [[6000, subject.hit0]]);
	assert_equal(itineraryActor.state, GMTWERK_STATE.DONE, "ItineraryActor countdown solo 0a");
	assert_equal(subject.hits, [1, 0, 0], "ItineraryActor countdown solo 0b");
	#endregion
}
