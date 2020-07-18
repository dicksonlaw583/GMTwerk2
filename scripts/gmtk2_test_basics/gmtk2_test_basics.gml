///@func gmtk2_test_basics()
function gmtk2_test_basics() {
	var actor, actor2, actor3, bank;
	
	#region GMTwerkActor
	actor = new GMTwerkActor();
	
	// Defaults
	assert_equal(actor.state, GMTWERK_STATE.ACTIVE, "GMTwerkActor Defaults 1");
	
	// Pause
	actor.pause();
	assert_equal(actor.state, GMTWERK_STATE.PAUSED, "GMTwerkActor Pause 1");
	actor.unpause();
	assert_equal(actor.state, GMTWERK_STATE.ACTIVE, "GMTwerkActor Pause 2");
	actor.pause(true);
	assert_equal(actor.state, GMTWERK_STATE.PAUSED, "GMTwerkActor Pause 3");
	actor.pause(false);
	assert_equal(actor.state, GMTWERK_STATE.ACTIVE, "GMTwerkActor Pause 4");
	
	// Stop
	actor.stop();
	assert_equal(actor.state, GMTWERK_STATE.STOPPED, "GMTwerkActor Stop 1");
	
	// Done
	actor2 = new GMTwerkActor();
	assert_equal(actor2.state, GMTWERK_STATE.ACTIVE, "GMTwerkActor Done 1");
	actor2.done();
	assert_equal(actor2.state, GMTWERK_STATE.DONE, "GMTwerkActor Done 2");
	#endregion
	
	#region GMTwerkBank
	actor = new GMTwerkActor();
	actor2 = new GMTwerkActor();
	actor3 = new GMTwerkActor();
	bank = new GMTwerkBank();
	
	// Defaults
	assert_is_undefined(bank._head, "GMTwerkBank Defaults 1");
	assert_equal(bank.size, 0, "GMTwerkBank Defaults 2");
	
	// Enqueue actors
	bank.add(actor);
	assert_equal(bank.size, 1, "GMTwerkBank Enqueue actors 1a");
	assert_equal(bank.get(0), actor, "GMTwerkBank Enqueue actors 1b");
	bank.add(actor2);
	assert_equal(bank.size, 2, "GMTwerkBank Enqueue actors 2a");
	assert_equal(bank.get(0), actor2, "GMTwerkBank Enqueue actors 2b");
	assert_equal(bank.get(1), actor, "GMTwerkBank Enqueue actors 2c");
	bank.act(1);
	assert_equal(bank.size, 2, "GMTwerkBank Enqueue actors 3a");
	assert_equal(bank.get(0), actor2, "GMTwerkBank Enqueue actors 3b");
	assert_equal(bank.get(1), actor, "GMTwerkBank Enqueue actors 3c");
	
	// Drop actors
	bank.add(actor3);
	assert_equal(bank.size, 3, "GMTwerkBank Drop actors 0");
	actor2.done();
	bank.act(1);
	assert_equal(bank.size, 2, "GMTwerkBank Drop actors 1a");
	assert_equal(bank.get(0), actor3, "GMTwerkBank Drop actors 1b");
	assert_equal(bank.get(1), actor, "GMTwerkBank Drop actors 1c");
	actor3.done();
	bank.act(1);
	assert_equal(bank.size, 1, "GMTwerkBank Drop actors 2a");
	assert_equal(bank.get(0), actor, "GMTwerkBank Drop actors 2b");
	#endregion
	
	#region GMTwerkArrayIterator
	var iterator;
	
	// 0 entries
	iterator = new GMTwerkArrayIterator([]);
	assert_fail(iterator.hasNext(), "GMTwerkArrayIterator 0 entries 1a");
	assert_equal([iterator.index, iterator.value], [0, undefined], "GMTwerkArrayIterator 0 entries 1b");
	
	// 1 entry
	iterator = new GMTwerkArrayIterator(["foo"]);
	assert(iterator.hasNext(), "GMTwerkArrayIterator 1 entry 1a");
	assert_equal([iterator.index, iterator.value], [0, "foo"], "GMTwerkArrayIterator 1 entry 1b");
	iterator.next();
	assert_fail(iterator.hasNext(), "GMTwerkArrayIterator 1 entry 2a");
	assert_equal([iterator.index, iterator.value], [1, undefined], "GMTwerkArrayIterator 1 entry 2b");
	
	// 2+ entries
	iterator = new GMTwerkArrayIterator(["FOO", "BAR", "BAZ"]);
	assert(iterator.hasNext(), "GMTwerkArrayIterator 2+ entries 1a");
	assert_equal([iterator.index, iterator.value], [0, "FOO"], "GMTwerkArrayIterator 2+ entries 1b");
	iterator.next();
	assert(iterator.hasNext(), "GMTwerkArrayIterator 2+ entries 2a");
	assert_equal([iterator.index, iterator.value], [1, "BAR"], "GMTwerkArrayIterator 2+ entries 2b");
	iterator.next();
	assert(iterator.hasNext(), "GMTwerkArrayIterator 2+ entries 3a");
	assert_equal([iterator.index, iterator.value], [2, "BAZ"], "GMTwerkArrayIterator 2+ entries 3b");
	iterator.next();
	assert_fail(iterator.hasNext(), "GMTwerkArrayIterator 2+ entries 4a");
	assert_equal([iterator.index, iterator.value], [3, undefined], "GMTwerkArrayIterator 2+ entries 4b");
	#endregion
	
	#region __gmtwerk_time__(time)
	// Save original host speed
	var originalHostSpeed = global.__gmtwerk_host_speed__;
	
	// Delta time: Return microseconds from milliseconds
	global.__gmtwerk_host_speed__ = undefined;
	assert_equal(__gmtwerk_time__(234), 234000, "__gmtwerk_time__ Delta time 1");
	assert_equal(__gmtwerk_time__(int64(345)), 345000, "__gmtwerk_time__ Delta time 2");
	
	// Non-delta time: Return steps
	global.__gmtwerk_host_speed__ = 1;
	assert_equal(__gmtwerk_time__(500), room_speed/2, "__gmtwerk_time__ Non-delta time 1");
	assert_equal(__gmtwerk_time__(int64(20)), 20, "__gmtwerk_time__ Non-delta time 2");
	
	// Restore original host speed
	global.__gmtwerk_host_speed__ = originalHostSpeed;
	#endregion
}
