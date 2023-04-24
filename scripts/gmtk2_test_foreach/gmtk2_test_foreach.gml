///@func gmtk2_test_foreach()
///@desc Test GMTwerk 2's ForEach actor.
function gmtk2_test_foreach() {
	var foreacher;
	var subject = {
		lastTrigger: undefined,
		trigger: function(v) { lastTrigger = v; },
		dones: 0,
		done: function() { ++dones; },
	};
	
	#region ForEachActor
	subject.lastTrigger = undefined;
	subject.dones = 0;
	foreacher = new ForEachActor(int64(2), ["foo", "bar"], subject.trigger, ["onDone", subject.done]);
	assert_equal(foreacher.act(1), GMTWERK_STATE.ACTIVE, "ForEachActor 1a");
	assert_equal([subject.lastTrigger, subject.dones], [undefined, 0], "ForEachActor 1b");
	assert_equal(foreacher.act(1), GMTWERK_STATE.ACTIVE, "ForEachActor 2a");
	assert_equal([subject.lastTrigger, subject.dones], ["foo", 0], "ForEachActor 2b");
	assert_equal(foreacher.act(1), GMTWERK_STATE.ACTIVE, "ForEachActor 3a");
	assert_equal([subject.lastTrigger, subject.dones], ["foo", 0], "ForEachActor 3b");
	assert_equal(foreacher.act(1), GMTWERK_STATE.DONE, "ForEachActor 4a");
	assert_equal([subject.lastTrigger, subject.dones], ["bar", 1], "ForEachActor 4b");
	#endregion
	
	#region ForEachActor with iterable
	subject.lastTrigger = undefined;
	subject.dones = 0;
	foreacher = new ForEachActor(int64(2), new GMTwerkArrayIterator(["foo", "bar"]), subject.trigger, ["onDone", subject.done]);
	assert_equal(foreacher.act(1), GMTWERK_STATE.ACTIVE, "ForEachActor with iterable1a");
	assert_equal([subject.lastTrigger, subject.dones], [undefined, 0], "ForEachActor with iterable1b");
	assert_equal(foreacher.act(1), GMTWERK_STATE.ACTIVE, "ForEachActor with iterable2a");
	assert_equal([subject.lastTrigger, subject.dones], ["foo", 0], "ForEachActor with iterable2b");
	assert_equal(foreacher.act(1), GMTWERK_STATE.ACTIVE, "ForEachActor with iterable3a");
	assert_equal([subject.lastTrigger, subject.dones], ["foo", 0], "ForEachActor with iterable3b");
	assert_equal(foreacher.act(1), GMTWERK_STATE.DONE, "ForEachActor with iterable4a");
	assert_equal([subject.lastTrigger, subject.dones], ["bar", 1], "ForEachActor with iterable4b");
	#endregion
}
