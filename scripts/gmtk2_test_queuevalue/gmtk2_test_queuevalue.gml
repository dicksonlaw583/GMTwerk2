///@func gmtk2_test_queuevalue()
function gmtk2_test_queuevalue() {
	var listener, listenerPush, listenerClear, queuer;
	listener = {
		lastCalledWith: undefined,
		call: function(v) { lastCalledWith = v; },
	};
	listenerPush = {
		lastCalledWith: undefined,
		call: function(v) { lastCalledWith = v; },
	};
	listenerClear = {
		called: false,
		call: function() { called = true; },
	};
	
	#region QueueValue test run
	// Empty queue should run first pushed value right away
	queuer = QueueValue(int64(2), listener.call, ["onPush", listenerPush.call, "onClear", listenerClear.call]);
	assert_equal([queuer.top(), queuer.top(0), queuer.top(1)], [undefined, undefined, undefined], "QueueValue test run pre-1 top");
	queuer.push(1);
	assert_equal(listener.lastCalledWith, 1, "QueueValue test run 1");
	assert_equal(listenerPush.lastCalledWith, 1, "QueueValue test run 1 push");
	assert_equal([queuer.top(), queuer.top(0), queuer.top(1)], [undefined, undefined, undefined], "QueueValue test run 1 top");
		
	// But not the second value pushed within the upcoming interval
	listener.lastCalledWith = undefined;
	listenerPush.lastCalledWith = undefined;
	queuer.push(2);
	assert_equal(listener.lastCalledWith, undefined, "QueueValue test run 2a");
	assert_equal(listenerPush.lastCalledWith, 2, "QueueValue test run 2a push");
	assert_equal([queuer.top(), queuer.top(0), queuer.top(1)], [2, 2, undefined], "QueueValue test run 2a top"); 
	queuer.act(1);
	assert_equal(listener.lastCalledWith, undefined, "QueueValue test run 2b");
	queuer.act(1);
	assert_equal(listener.lastCalledWith, 2, "QueueValue test run 2c");
	assert_equal([queuer.top(), queuer.top(0), queuer.top(1)], [undefined, undefined, undefined], "QueueValue test run 2c top");
		
	// Nor the third value pushed immediately after the second value is popped
	// Fourth value should wait one full interval after the third value is popped
	listener.lastCalledWith = undefined;
	listenerPush.lastCalledWith = undefined;
	queuer.push(3);
	assert_equal(listener.lastCalledWith, undefined, "QueueValue test run 3a");
	assert_equal(listenerPush.lastCalledWith, 3, "QueueValue test run 3a push");
	queuer.act(1);
	queuer.push(4);
	assert_equal(listener.lastCalledWith, undefined, "QueueValue test run 3b");
	assert_equal(listenerPush.lastCalledWith, 4, "QueueValue test run 3b push");
	assert_equal([queuer.top(0), queuer.top(1), queuer.top(2)], [3, 4, undefined], "QueueValue test run 3b top");
	queuer.act(1);
	assert_equal(listener.lastCalledWith, 3, "QueueValue test run 3c");
	listener.lastCalledWith = undefined;
	queuer.act(1);
	assert_equal(listener.lastCalledWith, undefined, "QueueValue test run 4a");
	queuer.act(1);
	assert_equal(listener.lastCalledWith, 4, "QueueValue test run 4b");
	
	// Give the queuer time to expire, then the fifth value should run right away
	listener.lastCalledWith = undefined;
	listenerPush.lastCalledWith = undefined;
	repeat (2) {
		queuer.act(1);
		assert_equal(listener.lastCalledWith, undefined, "QueueValue test run pre-5");
		assert_equal(listener.lastCalledWith, undefined, "QueueValue test run pre-5 push");
		assert_equal([queuer.top(), queuer.top(0), queuer.top(1)], [undefined, undefined, undefined], "QueueValue test run pre-5 top");
	}
	listener.lastCalledWith = undefined;
	listenerPush.lastCalledWith = undefined;
	queuer.push(5);
	assert_equal(listener.lastCalledWith, 5, "QueueValue test run 5");
	assert_equal(listenerPush.lastCalledWith, 5, "QueueValue test run 5 push");
	assert_equal([queuer.top(), queuer.top(0), queuer.top(1)], [undefined, undefined, undefined], "QueueValue test run 5 top");
	
	// Clearing the queue should prevent upcoming pop
	listener.lastCalledWith = undefined;
	listenerPush.lastCalledWith = undefined;
	listenerClear.called = false;
	queuer.push(6);
	queuer.act(1);
	assert_equal(listener.lastCalledWith, undefined, "QueueValue test run 6a");
	assert_equal(listenerPush.lastCalledWith, 6, "QueueValue test run 6a push");
	assert_fail(listenerClear.called, "QueueValue test run 6a clear");
	assert_equal([queuer.top(), queuer.top(0), queuer.top(1)], [6, 6, undefined], "QueueValue test run 6a top"); 
	listener.lastCalledWith = undefined;
	listenerPush.lastCalledWith = undefined;
	queuer.clear();
	queuer.act(1);
	assert_equal(listener.lastCalledWith, undefined, "QueueValue test run 6b");
	assert_equal(listenerPush.lastCalledWith, undefined, "QueueValue test run 6b push");
	assert(listenerClear.called, "QueueValue test run 6b clear");
	assert_equal([queuer.top(), queuer.top(0), queuer.top(1)], [undefined, undefined, undefined], "QueueValue test run 6b top"); 
	#endregion
}
