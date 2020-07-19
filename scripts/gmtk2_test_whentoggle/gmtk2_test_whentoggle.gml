///@func gmtk2_test_whentoggle()
function gmtk2_test_whentoggle() {
	var whentoggler;
	var subject = {
		tfs: 0,
		fts: 0,
		trueFalse: function() { ++tfs; },
		falseTrue: function() { ++fts; },
	};
	var cosubject = {
		ready: false,
		isReady: function() { return ready; },
	};
	
	#region WhenToggleActor
	subject.tfs = 0;
	subject.fts = 0;
	cosubject.ready = false;
	whentoggler = new WhenToggleActor(cosubject.isReady, subject.falseTrue, subject.trueFalse);
	assert_equal(whentoggler.state, GMTWERK_STATE.ACTIVE, "WhenToggleActor 0a");
	assert_equal([subject.fts, subject.tfs], [0, 0], "WhenToggleActor 0b");
	assert_equal(whentoggler.act(1), GMTWERK_STATE.ACTIVE, "WhenToggleActor 1a");
	assert_equal([subject.fts, subject.tfs], [0, 0], "WhenToggleActor 1b");
	cosubject.ready = true;
	assert_equal(whentoggler.act(1), GMTWERK_STATE.ACTIVE, "WhenToggleActor 2a");
	assert_equal([subject.fts, subject.tfs], [1, 0], "WhenToggleActor 2b");
	assert_equal(whentoggler.act(1), GMTWERK_STATE.ACTIVE, "WhenToggleActor 3a");
	assert_equal([subject.fts, subject.tfs], [1, 0], "WhenToggleActor 3b");
	cosubject.ready = false;
	assert_equal(whentoggler.act(1), GMTWERK_STATE.ACTIVE, "WhenToggleActor 4a");
	assert_equal([subject.fts, subject.tfs], [1, 1], "WhenToggleActor 4b");
	assert_equal(whentoggler.act(1), GMTWERK_STATE.ACTIVE, "WhenToggleActor 5a");
	assert_equal([subject.fts, subject.tfs], [1, 1], "WhenToggleActor 5b");
	#endregion
}
