///@func gmtk2_test_tween()
function gmtk2_test_tween() {
	var tweener, listener, selector;
	#region Tween run to completion
	listener = {
		value: 6,
		done: false,
		lost: false,
		stop: false,
		doDone: function() { done = true; },
		doLost: function() { lost = true; },
		doStop: function() { stop = true; },
	};
	selector = StructVar("value", listener);
	tweener = new TweenActor(selector, 10, int64(2), ["type", te_linear, "onDone", listener.doDone, "onLost", listener.doLost, "onStop", listener.doStop]);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, 6, false, false, false], "Tween run to completion 0");
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, 8, false, false, false], "Tween run to completion 1");
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.DONE, 10, true, false, false], "Tween run to completion 2");
	#endregion
	
	#region Tween stop with snap
	listener = {
		value: 6,
		done: false,
		lost: false,
		stop: false,
		doDone: function() { done = true; },
		doLost: function() { lost = true; },
		doStop: function() { stop = true; },
	};
	selector = StructVar("value", listener);
	tweener = new TweenActor(selector, 12, int64(3), ["type", te_linear, "onDone", listener.doDone, "onLost", listener.doLost, "onStop", listener.doStop]);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, 6, false, false, false], "Tween stop with snap 0");
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, 8, false, false, false], "Tween stop with snap 1");
	tweener.stop();
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.STOPPED, 12, false, false, true], "Tween stop with snap 2");
	#endregion
	
	#region Tween stop without snap
	listener = {
		value: 6,
		done: false,
		lost: false,
		stop: false,
		doDone: function() { done = true; },
		doLost: function() { lost = true; },
		doStop: function() { stop = true; },
	};
	selector = StructVar("value", listener);
	tweener = new TweenActor(selector, 12, int64(3), ["type", te_linear, "onDone", listener.doDone, "onLost", listener.doLost, "onStop", listener.doStop, "snapOnStop", false]);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, 6, false, false, false], "Tween stop without snap 0");
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, 8, false, false, false], "Tween stop without snap 1");
	tweener.stop();
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.STOPPED, 8, false, false, true], "Tween stop without snap 2");
	#endregion

	#region Tween lost
	listener = {
		value: 6,
		done: false,
		lost: false,
		stop: false,
		doDone: function() { done = true; },
		doLost: function() { lost = true; },
		doStop: function() { stop = true; },
	};
	selector = StructVar("value", listener);
	tweener = new TweenActor(selector, 12, int64(3), ["type", te_linear, "onDone", listener.doDone, "onLost", listener.doLost, "onStop", listener.doStop]);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, 6, false, false, false], "Tween stop with snap 0");
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, 8, false, false, false], "Tween stop with snap 1");
	selector.strc = undefined
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.LOST, 8, false, true, false], "Tween stop with snap 2");
	#endregion

	#region ZenosTween run to completion
	listener = {
		value: -4,
		done: false,
		lost: false,
		stop: false,
		doDone: function() { done = true; },
		doLost: function() { lost = true; },
		doStop: function() { stop = true; },
	};
	selector = StructVar("value", listener);
	tweener = new ZenosTweenActor(selector, 0, 0.5, ["onDone", listener.doDone, "onLost", listener.doLost, "onStop", listener.doStop]);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, -4, false, false, false], "ZenosTween run to completion 0");
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, -2, false, false, false], "ZenosTween run to completion 1");
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, -1, false, false, false], "ZenosTween run to completion 2");
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.DONE, 0, true, false, false], "ZenosTween run to completion 3");
	#endregion
	
	#region StepTween run to completion
	listener = {
		value: 1,
		done: false,
		lost: false,
		stop: false,
		doDone: function() { done = true; },
		doLost: function() { lost = true; },
		doStop: function() { stop = true; },
	}
	selector = StructVar("value", listener);
	tweener = new StepTweenActor(selector, -2, 1, ["onDone", listener.doDone, "onLost", listener.doLost, "onStop", listener.doStop]);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, 1, false, false, false], "StepTween run to completion 0");
	tweener.act(2);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, -1, false, false, false], "StepTween run to completion 1");
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.DONE, -2, true, false, false], "StepTween run to completion 2");
	#endregion

	#region ChannelTween run to completion
	listener = {
		value: 6,
		done: false,
		lost: false,
		stop: false,
		doDone: function() { done = true; },
		doLost: function() { lost = true; },
		doStop: function() { stop = true; },
	};
	selector = StructVar("value", listener);
	tweener = new ChannelTweenActor(selector, 10, int64(2), [ac_gmtk2_linear, 0], ["onDone", listener.doDone, "onLost", listener.doLost, "onStop", listener.doStop]);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, 6, false, false, false], "ChannelTween run to completion 0");
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.ACTIVE, 8, false, false, false], "ChannelTween run to completion 1");
	tweener.act(1);
	assert_equal([tweener.state, listener.value, listener.done, listener.lost, listener.stop], [GMTWERK_STATE.DONE, 10, true, false, false], "ChannelTween run to completion 2");
	#endregion
}
