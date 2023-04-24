///@func gmtk2_test_twerk()
///@desc Test GMTwerk 2's Twerk actor.
function gmtk2_test_twerk() {
	var twerker, listener;
	
	#region FlashTwerk
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new FlashTwerkActor(StructVar("value", listener), 8, 2, int64(3), int64(2), ["onDone", listener.doDone]);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "FlashTwerk 0");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "FlashTwerk 1");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "FlashTwerk 2");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "FlashTwerk 3");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "FlashTwerk 4");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "FlashTwerk 5");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "FlashTwerk 6");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "FlashTwerk 7");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "FlashTwerk 8");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "FlashTwerk 9");
	#endregion
	
	#region ShakeTwerk
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new ShakeTwerkActor(StructVar("value", listener), 8, 2, int64(4), ["decay", te_linear, "onDone", listener.doDone]);
	assert_equal(listener.value, 4, "ShakeTwerk 0");
	twerker.act(1);
	assert_in_range(listener.value, 1, 7, "ShakeTwerk 1");
	twerker.act(1);
	assert_in_range(listener.value, 2, 6, "ShakeTwerk 2");
	twerker.act(1);
	assert_in_range(listener.value, 3, 5, "ShakeTwerk 3");
	twerker.act(1);
	assert_in_range(listener.value, 0, 8, "ShakeTwerk 4");
	twerker.act(1);
	assert_in_range(listener.value, 1, 7, "ShakeTwerk 5");
	twerker.act(1);
	assert_in_range(listener.value, 2, 6, "ShakeTwerk 6");
	twerker.act(1);
	assert_in_range(listener.value, 3, 5, "ShakeTwerk 7");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "ShakeTwerk 8");
	#endregion
	
	#region ChannelTwerk
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new ChannelTwerkActor(StructVar("value", listener), 8, 2, int64(4), ac_gmtk2_triangle_wave, ["onDone", listener.doDone]);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "ChannelTwerk 0");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "ChannelTwerk 1");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "ChannelTwerk 2");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "ChannelTwerk 3");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "ChannelTwerk 4");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "ChannelTwerk 5");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "ChannelTwerk 6");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "ChannelTwerk 7");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "ChannelTwerk 8");
	#endregion
	
	#region DubstepTwerk
	listener = {
		done: false,
		doDone: function() { done = true; },
		value: 4
	};
	twerker = new DubstepTwerkActor(StructVar("value", listener), 8, 2, int64(4), ["forward", te_linear, "backward", te_linear, "onDone", listener.doDone]);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "DubstepTwerk 0");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "DubstepTwerk 1");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "DubstepTwerk 2");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "DubstepTwerk 3");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 4, false], "DubstepTwerk 4");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "DubstepTwerk 5");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 8, false], "DubstepTwerk 6");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.ACTIVE, 6, false], "DubstepTwerk 7");
	twerker.act(1);
	assert_equal([twerker.state, listener.value, listener.done], [GMTWERK_STATE.DONE, 4, true], "DubstepTwerk 8");
	#endregion
}
