///@func gmtk2_test_twerk_wave()
function gmtk2_test_twerk_wave() {
	var twerker, listener;
	
	#region + sawtooth wave
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new WaveTwerkActor(StructVar("value", listener), 8, 2, int64(4), "wave", tw_sawtooth, "positiveOnly", true, "onDone", listener.doDone);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+ sawtooth wave 0");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 5, false], "+ sawtooth wave 1");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ sawtooth wave 2");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 7, false], "+ sawtooth wave 3");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+ sawtooth wave 4");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 5, false], "+ sawtooth wave 5");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ sawtooth wave 6");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 7, false], "+ sawtooth wave 7");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "+ sawtooth wave 8");
	#endregion
	
	#region +/- sawtooth wave
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new WaveTwerkActor(StructVar("value", listener), 8, 2, int64(4), "wave", tw_sawtooth, "positiveOnly", false, "onDone", listener.doDone);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- sawtooth wave 0");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+/- sawtooth wave 1");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "+/- sawtooth wave 2");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 2, false], "+/- sawtooth wave 3");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- sawtooth wave 4");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+/- sawtooth wave 5");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "+/- sawtooth wave 6");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 2, false], "+/- sawtooth wave 7");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "+/- sawtooth wave 8");
	#endregion

	#region + triangle wave
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new WaveTwerkActor(StructVar("value", listener), 8, 2, int64(4), "wave", tw_triangle, "positiveOnly", true, "onDone", listener.doDone);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+ triangle wave 0");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ triangle wave 1");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "+ triangle wave 2");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ triangle wave 3");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+ triangle wave 4");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ triangle wave 5");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "+ triangle wave 6");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ triangle wave 7");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "+ triangle wave 8");
	#endregion
	
	#region +/- triangle wave
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new WaveTwerkActor(StructVar("value", listener), 8, 2, int64(4), "wave", tw_triangle, "positiveOnly", false, "onDone", listener.doDone);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- triangle wave 0");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "+/- triangle wave 1");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- triangle wave 2");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 0, false], "+/- triangle wave 3");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- triangle wave 4");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "+/- triangle wave 5");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- triangle wave 6");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 0, false], "+/- triangle wave 7");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "+/- triangle wave 8");
	#endregion
	
	#region + reverse sawtooth wave
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new WaveTwerkActor(StructVar("value", listener), 8, 2, int64(4), "wave", tw_sawtooth_reverse, "positiveOnly", true, "onDone", listener.doDone);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+ reverse sawtooth wave 0");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 7, false], "+ reverse sawtooth wave 1");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ reverse sawtooth wave 2");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 5, false], "+ reverse sawtooth wave 3");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+ reverse sawtooth wave 4");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 7, false], "+ reverse sawtooth wave 5");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ reverse sawtooth wave 6");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 5, false], "+ reverse sawtooth wave 7");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "+ reverse sawtooth wave 8");
	#endregion
	
	#region +/- reverse sawtooth wave
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new WaveTwerkActor(StructVar("value", listener), 8, 2, int64(4), "wave", tw_sawtooth_reverse, "positiveOnly", false, "onDone", listener.doDone);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- reverse sawtooth wave 0");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+/- reverse sawtooth wave 1");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- reverse sawtooth wave 2");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 2, false], "+/- reverse sawtooth wave 3");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- reverse sawtooth wave 4");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+/- reverse sawtooth wave 5");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- reverse sawtooth wave 6");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 2, false], "+/- reverse sawtooth wave 7");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "+/- reverse sawtooth wave 8");
	#endregion
	
	#region + sinusoid wave
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new WaveTwerkActor(StructVar("value", listener), 8, 2, int64(4), "wave", tw_sinusoid, "positiveOnly", true, "onDone", listener.doDone);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+ sinusoid wave 0");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ sinusoid wave 1");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "+ sinusoid wave 2");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ sinusoid wave 3");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+ sinusoid wave 4");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ sinusoid wave 5");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "+ sinusoid wave 6");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "+ sinusoid wave 7");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "+ sinusoid wave 8");
	#endregion
	
	#region +/- sinusoid wave
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new WaveTwerkActor(StructVar("value", listener), 8, 2, int64(4), "wave", tw_sinusoid, "positiveOnly", false, "onDone", listener.doDone);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- sinusoid wave 0");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "+/- sinusoid wave 1");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- sinusoid wave 2");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 0, false], "+/- sinusoid wave 3");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- sinusoid wave 4");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "+/- sinusoid wave 5");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "+/- sinusoid wave 6");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 0, false], "+/- sinusoid wave 7");
	twerker.act(1);
	assert_equalish([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "+/- sinusoid wave 8");
	#endregion
}