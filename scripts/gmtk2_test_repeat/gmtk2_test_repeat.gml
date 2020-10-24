///@func gmtk2_test_repeat()
function gmtk2_test_repeat() {
	var repeater;
	var subject = {
		triggers: 0,
		trigger: function() { ++triggers; },
		dones: 0,
		done: function() { ++dones; },
	};
	
	#region RepeatActor
	subject.triggers = 0;
	subject.dones = 0;
	repeater = new RepeatActor(int64(2), 2, subject.trigger, "onDone", subject.done);
	assert_equal(repeater.act(1), GMTWERK_STATE.ACTIVE, "RepeatActor 1a");
	assert_equal([subject.triggers, subject.dones], [0, 0], "RepeatActor 1b");
	assert_equal(repeater.act(1), GMTWERK_STATE.ACTIVE, "RepeatActor 2a");
	assert_equal([subject.triggers, subject.dones], [1, 0], "RepeatActor 2b");
	assert_equal(repeater.act(1), GMTWERK_STATE.ACTIVE, "RepeatActor 3a");
	assert_equal([subject.triggers, subject.dones], [1, 0], "RepeatActor 3b");
	assert_equal(repeater.act(1), GMTWERK_STATE.DONE, "RepeatActor 4a");
	assert_equal([subject.triggers, subject.dones], [2, 1], "RepeatActor 4b");
	#endregion
}
