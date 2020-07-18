///@func gmtk2_test_while()
function gmtk2_test_while() {
	var whiler;
	var subject = {
		dones: 0,
		done: function() { ++dones; },
	};
	var cosubject = {
		num: 2,
		dec: function() { --num; },
		more: function() { return num > 0; },
	};
	
	#region WhileActor
	subject.triggers = 0;
	subject.dones = 0;
	cosubject.num = 2;
	whiler = new WhileActor(int64(2), cosubject.more, cosubject.dec, "onDone", subject.done);
	assert_equal(whiler.act(1), GMTWERK_STATE.ACTIVE, "WhileActor 1a");
	assert_equal([cosubject.num, subject.dones], [2, 0], "WhileActor 1b");
	assert_equal(whiler.act(1), GMTWERK_STATE.ACTIVE, "WhileActor 2a");
	assert_equal([cosubject.num, subject.dones], [1, 0], "WhileActor 2b");
	assert_equal(whiler.act(1), GMTWERK_STATE.ACTIVE, "WhileActor 3a");
	assert_equal([cosubject.num, subject.dones], [1, 0], "WhileActor 3b");
	assert_equal(whiler.act(1), GMTWERK_STATE.DONE, "WhileActor 4a");
	assert_equal([cosubject.num, subject.dones], [0, 1], "WhileActor 4b");
	#endregion
	
	#region WhileActor no iterations
	subject.triggers = 0;
	subject.dones = 0;
	cosubject.num = 0;
	whiler = new WhileActor(int64(2), cosubject.more, cosubject.dec, "onDone", subject.done);
	assert_equal(whiler.state, GMTWERK_STATE.DONE, "WhileActor no iterations 1a");
	assert_equal([cosubject.num, subject.dones], [0, 1], "WhileActor no iterations 1b");
	#endregion
}
