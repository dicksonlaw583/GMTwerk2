///@func gmtk2_test_delay()
function gmtk2_test_delay() {
	var delay, subject;
	
	#region DelayActor
	subject = {
		triggered: false,
		trigger: function() { triggered = true; },
	};
	delay = new DelayActor(int64(3), subject.trigger);
	assert_equal(delay.act(1), GMTWERK_STATE.ACTIVE, "DelayActor 1a");
	assert_fail(subject.triggered, "DelayActor 1b");
	assert_equal(delay.act(1), GMTWERK_STATE.ACTIVE, "DelayActor 2a");
	assert_fail(subject.triggered, "DelayActor 2b");
	assert_equal(delay.act(1), GMTWERK_STATE.DONE, "DelayActor 3a");
	assert(subject.triggered, "DelayActor 3b");
	#endregion
}
