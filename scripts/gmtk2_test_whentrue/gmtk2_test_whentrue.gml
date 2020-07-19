///@func gmtk2_test_whentrue()
function gmtk2_test_whentrue() {
	var whentruer;
	var subject = {
		dones: 0,
		done: function() { ++dones; },
	};
	var cosubject = {
		ready: false,
		isReady: function() { return ready; },
	};
	
	#region WhenTrueActor
	subject.dones = 0;
	cosubject.ready = false;
	whentruer = new WhenTrueActor(cosubject.isReady, subject.done);
	assert_equal(whentruer.state, GMTWERK_STATE.ACTIVE, "WhenTrueActor 0a");
	assert_equal(subject.dones, 0, "WhenTrueActor 0b");
	assert_equal(whentruer.act(1), GMTWERK_STATE.ACTIVE, "WhenTrueActor 1a");
	assert_equal(subject.dones, 0, "WhenTrueActor 1b");
	assert_equal(whentruer.act(1), GMTWERK_STATE.ACTIVE, "WhenTrueActor 2a");
	assert_equal(subject.dones, 0, "WhenTrueActor 2b");
	cosubject.ready = true;
	assert_equal(whentruer.act(1), GMTWERK_STATE.DONE, "WhenTrueActor 3a");
	assert_equal(subject.dones, 1, "WhenTrueActor 3b");
	#endregion
	
	#region WhenTrueActor no iterations
	subject.dones = 0;
	cosubject.ready = true;
	whentruer = new WhenTrueActor(cosubject.isReady, subject.done);
	assert_equal(whentruer.state, GMTWERK_STATE.DONE, "WhenTrueActor no iterations 1a");
	assert_equal(subject.dones, 1, "WhenTrueActor no iterations 1b");
	#endregion
}
