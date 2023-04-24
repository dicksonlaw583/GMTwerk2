///@func gmtk2_test_track()
///@desc Test GMTwerk 2's Track actor.
function gmtk2_test_track() {
	var listener, tracker;
	
	#region Track run to completion
	listener = {
		value0: 5,
		value1: 8,
		nudge: 0,
		reach: 0,
		done: 0,
		lost: 0,
		stop: 0,
		onNudge: function() { ++nudge; },
		onReach: function() { ++reach; },
		onDone: function() { ++done; },
		onLost: function() { ++lost; },
		onStop: function() { ++stop; },
		toArray: function() {
			return [value0, value1, nudge, reach, done, lost, stop];
		},
	};
	tracker = new TrackActor(StructVar("value0", listener), StructVar("value1", listener), int64(3), ["type", te_linear, "onNudge", listener.onNudge, "onReach", listener.onReach, "onDone", listener.onDone, "onLost", listener.onLost, "onStop", listener.onStop]);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [5, 8, 0, 0, 0, 0, 0]], "Track run to completion 0");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 8, 1, 0, 0, 0, 0]], "Track run to completion 1");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 8, 1, 0, 0, 0, 0]], "Track run to completion 2");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "Track run to completion 3");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "Track run to completion 4");
	listener.value1 = 5;
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 5, 2, 1, 0, 0, 0]], "Track run to completion 5");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 5, 2, 1, 0, 0, 0]], "Track run to completion 6");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [5, 5, 2, 2, 0, 0, 0]], "Track run to completion 7");
	#endregion
	
	#region Track run with done
	listener = {
		value0: 5,
		value1: 8,
		nudge: 0,
		reach: 0,
		done: 0,
		lost: 0,
		stop: 0,
		onNudge: function() { ++nudge; },
		onReach: function() { ++reach; },
		onDone: function() { ++done; },
		onLost: function() { ++lost; },
		onStop: function() { ++stop; },
		toArray: function() {
			return [value0, value1, nudge, reach, done, lost, stop];
		},
	};
	tracker = new TrackActor(StructVar("value0", listener), StructVar("value1", listener), int64(3), ["type", te_linear, "onNudge", listener.onNudge, "onReach", listener.onReach, "onDone", listener.onDone, "onLost", listener.onLost, "onStop", listener.onStop]);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [5, 8, 0, 0, 0, 0, 0]], "Track run with done 0");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 8, 1, 0, 0, 0, 0]], "Track run with done 1");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 8, 1, 0, 0, 0, 0]], "Track run with done 2");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "Track run with done 3");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "Track run with done 4");
	listener.value1 = 5;
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 5, 2, 1, 0, 0, 0]], "Track run with done 5");
	tracker.done();
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.DONE, false, [5, 5, 2, 1, 1, 0, 0]], "Track run with done 6");
	#endregion
	
	#region Track run with snapful stop
	listener = {
		value0: 5,
		value1: 8,
		nudge: 0,
		reach: 0,
		done: 0,
		lost: 0,
		stop: 0,
		onNudge: function() { ++nudge; },
		onReach: function() { ++reach; },
		onDone: function() { ++done; },
		onLost: function() { ++lost; },
		onStop: function() { ++stop; },
		toArray: function() {
			return [value0, value1, nudge, reach, done, lost, stop];
		},
	};
	tracker = new TrackActor(StructVar("value0", listener), StructVar("value1", listener), int64(3), ["type", te_linear, "snapOnStop", true, "onNudge", listener.onNudge, "onReach", listener.onReach, "onDone", listener.onDone, "onLost", listener.onLost, "onStop", listener.onStop]);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [5, 8, 0, 0, 0, 0, 0]], "Track run with snapful stop 0");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 8, 1, 0, 0, 0, 0]], "Track run with snapful stop 1");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 8, 1, 0, 0, 0, 0]], "Track run with snapful stop 2");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "Track run with snapful stop 3");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "Track run with snapful stop 4");
	listener.value1 = 5;
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 5, 2, 1, 0, 0, 0]], "Track run with snapful stop 5");
	tracker.stop();
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.STOPPED, false, [5, 5, 2, 1, 0, 0, 1]], "Track run with snapful stop 6");
	#endregion
	
	#region Track run with snapless stop
	listener = {
		value0: 5,
		value1: 8,
		nudge: 0,
		reach: 0,
		done: 0,
		lost: 0,
		stop: 0,
		onNudge: function() { ++nudge; },
		onReach: function() { ++reach; },
		onDone: function() { ++done; },
		onLost: function() { ++lost; },
		onStop: function() { ++stop; },
		toArray: function() {
			return [value0, value1, nudge, reach, done, lost, stop];
		},
	};
	tracker = new TrackActor(StructVar("value0", listener), StructVar("value1", listener), int64(3), ["type", te_linear, "snapOnStop", false, "onNudge", listener.onNudge, "onReach", listener.onReach, "onDone", listener.onDone, "onLost", listener.onLost, "onStop", listener.onStop]);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [5, 8, 0, 0, 0, 0, 0]], "Track run with snapless stop 0");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 8, 1, 0, 0, 0, 0]], "Track run with snapless stop 1");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 8, 1, 0, 0, 0, 0]], "Track run with snapless stop 2");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "Track run with snapless stop 3");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "Track run with snapless stop 4");
	listener.value1 = 5;
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 5, 2, 1, 0, 0, 0]], "Track run with snapless stop 5");
	tracker.stop();
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.STOPPED, false, [7, 5, 2, 1, 0, 0, 1]], "Track run with snapless stop 6");
	#endregion
	
	#region Track run with loss
	listener = {
		value0: 5,
		value1: 8,
		nudge: 0,
		reach: 0,
		done: 0,
		lost: 0,
		stop: 0,
		onNudge: function() { ++nudge; },
		onReach: function() { ++reach; },
		onDone: function() { ++done; },
		onLost: function() { ++lost; },
		onStop: function() { ++stop; },
		toArray: function() {
			return [value0, value1, nudge, reach, done, lost, stop];
		},
	};
	tracker = new TrackActor(StructVar("value0", listener), StructVar("value1", listener), int64(3), ["type", te_linear, "onNudge", listener.onNudge, "onReach", listener.onReach, "onDone", listener.onDone, "onLost", listener.onLost, "onStop", listener.onStop]);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [5, 8, 0, 0, 0, 0, 0]], "Track run with loss 0");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 8, 1, 0, 0, 0, 0]], "Track run with loss 1");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 8, 1, 0, 0, 0, 0]], "Track run with loss 2");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "Track run with loss 3");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "Track run with loss 4");
	listener.value1 = 5;
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 5, 2, 1, 0, 0, 0]], "Track run with loss 5");
	tracker.subject.strc = undefined;
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.LOST, false, [7, 5, 2, 1, 0, 1, 0]], "Track run with loss 6");
	#endregion

	#region ZenosTrack run to completion
	listener = {
		value0: 4,
		value1: 8,
		nudge: 0,
		reach: 0,
		done: 0,
		lost: 0,
		stop: 0,
		onNudge: function() { ++nudge; },
		onReach: function() { ++reach; },
		onDone: function() { ++done; },
		onLost: function() { ++lost; },
		onStop: function() { ++stop; },
		toArray: function() {
			return [value0, value1, nudge, reach, done, lost, stop];
		},
	};
	tracker = new ZenosTrackActor(StructVar("value0", listener), StructVar("value1", listener), 0.5, ["onNudge", listener.onNudge, "onReach", listener.onReach, "onDone", listener.onDone, "onLost", listener.onLost, "onStop", listener.onStop]);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [4, 8, 0, 0, 0, 0, 0]], "ZenosTrack run to completion 0");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 8, 1, 0, 0, 0, 0]], "ZenosTrack run to completion 1");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 8, 1, 0, 0, 0, 0]], "ZenosTrack run to completion 2");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "ZenosTrack run to completion 3");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "ZenosTrack run to completion 4");
	listener.value1 = 4;
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 4, 2, 1, 0, 0, 0]], "ZenosTrack run to completion 5");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [5, 4, 2, 1, 0, 0, 0]], "ZenosTrack run to completion 6");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [4, 4, 2, 2, 0, 0, 0]], "ZenosTrack run to completion 7");
	#endregion

	#region StepTrack run to completion
	listener = {
		value0: 5,
		value1: 8,
		nudge: 0,
		reach: 0,
		done: 0,
		lost: 0,
		stop: 0,
		onNudge: function() { ++nudge; },
		onReach: function() { ++reach; },
		onDone: function() { ++done; },
		onLost: function() { ++lost; },
		onStop: function() { ++stop; },
		toArray: function() {
			return [value0, value1, nudge, reach, done, lost, stop];
		},
	};
	tracker = new StepTrackActor(StructVar("value0", listener), StructVar("value1", listener), 1, ["onNudge", listener.onNudge, "onReach", listener.onReach, "onDone", listener.onDone, "onLost", listener.onLost, "onStop", listener.onStop]);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [5, 8, 0, 0, 0, 0, 0]], "StepTrack run to completion 0");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 8, 1, 0, 0, 0, 0]], "StepTrack run to completion 1");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 8, 1, 0, 0, 0, 0]], "StepTrack run to completion 2");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "StepTrack run to completion 3");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "StepTrack run to completion 4");
	listener.value1 = 5;
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 5, 2, 1, 0, 0, 0]], "StepTrack run to completion 5");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 5, 2, 1, 0, 0, 0]], "StepTrack run to completion 6");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [5, 5, 2, 2, 0, 0, 0]], "StepTrack run to completion 7");
	#endregion

	#region ChannelTrack run to completion
	listener = {
		value0: 5,
		value1: 8,
		nudge: 0,
		reach: 0,
		done: 0,
		lost: 0,
		stop: 0,
		onNudge: function() { ++nudge; },
		onReach: function() { ++reach; },
		onDone: function() { ++done; },
		onLost: function() { ++lost; },
		onStop: function() { ++stop; },
		toArray: function() {
			return [value0, value1, nudge, reach, done, lost, stop];
		},
	};
	tracker = new ChannelTrackActor(StructVar("value0", listener), StructVar("value1", listener), int64(3), ac_gmtk2_linear, ["onNudge", listener.onNudge, "onReach", listener.onReach, "onDone", listener.onDone, "onLost", listener.onLost, "onStop", listener.onStop]);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [5, 8, 0, 0, 0, 0, 0]], "ChannelTrack run to completion 0");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 8, 1, 0, 0, 0, 0]], "ChannelTrack run to completion 1");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 8, 1, 0, 0, 0, 0]], "ChannelTrack run to completion 2");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "ChannelTrack run to completion 3");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [8, 8, 1, 1, 0, 0, 0]], "ChannelTrack run to completion 4");
	listener.value1 = 5;
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [7, 5, 2, 1, 0, 0, 0]], "ChannelTrack run to completion 5");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, true, [6, 5, 2, 1, 0, 0, 0]], "ChannelTrack run to completion 6");
	tracker.act(1);
	assert_equal([tracker.state, tracker.moving, listener.toArray()], [GMTWERK_STATE.ACTIVE, false, [5, 5, 2, 2, 0, 0, 0]], "ChannelTrack run to completion 7");
	#endregion
}
