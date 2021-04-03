///@func gmtk2_test_bugs()
///@desc Regression tests against reported bugs
function gmtk2_test_bugs() {
	gmtk2_test_github_1();
}

///@func gmtk2_test_github_1()
///@desc See: https://github.com/dicksonlaw583/GMTwerk2/issues/1
function gmtk2_test_github_1() {
	var _subject = {
		bank: new GMTwerkBank(),
		bgx: -1,
		mgx: -1,
	};
	_subject.bank.add(new ItineraryActor(int64(12), [
		[int64(12), method(_subject, function() { bank.add(new TweenActor(StructVar("bgx", self).set(56), 0, int64(30), ["type", te_cubic_out])); })],
		[int64(12), method(_subject, function() { bank.add(new TweenActor(StructVar("mgx", self).set(56), 0, int64(30), ["type", te_cubic_out])); })],
	]));
	repeat (60) {
		_subject.bank.act(1, 1000000 div 60);
	}
	assert_equal(_subject.bgx, 0, "GitHub #1: bgx wrong");
	assert_equal(_subject.mgx, 0, "GitHub #1: mgx wrong");
}
