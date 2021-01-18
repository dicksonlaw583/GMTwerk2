///@func gmtk2_test_workflow()
function gmtk2_test_workflow() {
	var workflow, delays, delaySubjects;
	var host = new GMTwerkBank();
	var subject = {
		triggered: false,
		trigger: function() { triggered = true; },
	};
	delaySubjects = [
		{
			triggered: false,
			trigger: function() { triggered = true; },
		},
		{
			triggered: false,
			trigger: function() { triggered = true; },
		},
	];
	
	#region WorkflowActor
	subject.triggered = false;
	delaySubjects[0].triggered = false;
	delaySubjects[1].triggered = false;
	delays = [
		method({delaySubjects: delaySubjects}, function() { return new DelayActor(int64(2), delaySubjects[0].trigger); }),
		function() { },
		method({delaySubjects: delaySubjects}, function() { return new DelayActor(int64(3), delaySubjects[1].trigger); }),
	];
	workflow = new WorkflowActor(delays, ["onDone", subject.trigger]);
	// About to start first delay
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor 0a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, false, false], "WorkflowActor 0b");
	// First delay
	workflow.currentActor.act(1);
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor 1a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, false, false], "WorkflowActor 1b");
	workflow.currentActor.act(1);
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor 2a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, true, false], "WorkflowActor 2b");
	// Interim action
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor ia");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, true, false], "WorkflowActor ib");
	assert_isnt_struct(workflow.currentActor, "WorkflowActor ic");
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor id");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, true, false], "WorkflowActor ie");
	assert_is_struct(workflow.currentActor, "WorkflowActor if");
	// Second delay
	workflow.currentActor.act(1);
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor 3a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, true, false], "WorkflowActor 3b");
	workflow.currentActor.act(1);
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor 4a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, true, false], "WorkflowActor 4b");
	workflow.currentActor.act(1);
	assert_equal(workflow.act(1), GMTWERK_STATE.DONE, "WorkflowActor 5a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [true, true, true], "WorkflowActor 5b");
	#endregion
	
	#region WorkflowActor lost
	subject.triggered = false;
	delaySubjects[0].triggered = false;
	delaySubjects[1].triggered = false;
	delays = [
		method({delaySubjects: delaySubjects}, function() { return new TweenActor(StructVar("foo", {foo: 0}), 2, int64(2), ["onDone", delaySubjects[0].trigger]); }),
		function() { },
		method({delaySubjects: delaySubjects}, function() { return new DelayActor(int64(3), delaySubjects[1].trigger); }),
	];
	workflow = new WorkflowActor(delays, ["onDone", subject.trigger]);
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor lost 1a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, false, false], "WorkflowActor lost 1b");
	workflow.currentActor.subject.strc = undefined;
	workflow.currentActor.act(1);
	assert_equal(workflow.act(1), GMTWERK_STATE.LOST, "WorkflowActor lost 2a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, false, false], "WorkflowActor lost 2b");
	#endregion
	
	#region WorkflowActor stopped
	subject.triggered = false;
	delaySubjects[0].triggered = false;
	delaySubjects[1].triggered = false;
	delays = [
		method({delaySubjects: delaySubjects}, function() { return new TweenActor(StructVar("foo", {foo: 0}), 2, int64(2), ["onDone", delaySubjects[0].trigger]); }),
		function() { },
		method({delaySubjects: delaySubjects}, function() { return new DelayActor(int64(3), delaySubjects[1].trigger); }),
	];
	workflow = new WorkflowActor(delays, ["onDone", subject.trigger]);
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor stopped 1a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, false, false], "WorkflowActor stopped 1b");
	workflow.currentActor.stop();
	assert_equal(workflow.act(1), GMTWERK_STATE.STOPPED, "WorkflowActor stopped 2a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, false, false], "WorkflowActor stopped 2b");
	#endregion
}
