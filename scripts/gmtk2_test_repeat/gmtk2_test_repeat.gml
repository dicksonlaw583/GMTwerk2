///@func gmtk2_test_repeat()
function gmtk2_test_repeat() {
	var repeater, subject;
	
	#region RepeatActor
	subject = {
		triggers: 0,
		trigger: function() { ++triggers; },
	};
	repeater = new RepeatActor(int64(2), 2, subject.trigger);
	assert_equal(repeater.act(1), GMTWERK_STATE.ACTIVE, "RepeatActor 1a");
	assert_equal(subject.triggers, 0, "RepeatActor 1b");
	assert_equal(repeater.act(1), GMTWERK_STATE.ACTIVE, "RepeatActor 2a");
	assert_equal(subject.triggers, 1, "RepeatActor 2b");
	assert_equal(repeater.act(1), GMTWERK_STATE.ACTIVE, "RepeatActor 3a");
	assert_equal(subject.triggers, 1, "RepeatActor 3b");
	assert_equal(repeater.act(1), GMTWERK_STATE.DONE, "RepeatActor 4a");
	assert_equal(subject.triggers, 2, "RepeatActor 4b");
	#endregion
}
