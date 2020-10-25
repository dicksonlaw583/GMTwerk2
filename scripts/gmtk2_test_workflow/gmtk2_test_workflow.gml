///@func gmtk2_test_workflow()
function gmtk2_test_workflow() {
	var workflow, delays, delaySubjects;
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
		new DelayActor(int64(2), delaySubjects[0].trigger),
		new DelayActor(int64(3), delaySubjects[1].trigger),
	];
	workflow = new WorkflowActor(delays, "onDone", subject.trigger);
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor 1a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, false, false], "WorkflowActor 1b");
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor 2a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, true, false], "WorkflowActor 2b");
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor 3a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, true, false], "WorkflowActor 3b");
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor 4a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, true, false], "WorkflowActor 4b");
	assert_equal(workflow.act(1), GMTWERK_STATE.DONE, "WorkflowActor 5a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [true, true, true], "WorkflowActor 5b");
	#endregion
	
	#region WorkflowActor lost
	subject.triggered = false;
	delaySubjects[0].triggered = false;
	delaySubjects[1].triggered = false;
	delays = [
		new TweenActor(StructVar("foo", {foo: 0}), 2, int64(2), "onDone", delaySubjects[0].trigger),
		new DelayActor(int64(3), delaySubjects[1].trigger),
	];
	workflow = new WorkflowActor(delays, "onDone", subject.trigger);
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor lost 1a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, false, false], "WorkflowActor lost 1b");
	delays[0].subject.strc = undefined;
	assert_equal(workflow.act(1), GMTWERK_STATE.LOST, "WorkflowActor lost 2a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, false, false], "WorkflowActor lost 2b");
	#endregion
	
	#region WorkflowActor stopped
	subject.triggered = false;
	delaySubjects[0].triggered = false;
	delaySubjects[1].triggered = false;
	delays = [
		new TweenActor(StructVar("foo", {foo: 0}), 2, int64(2), "onDone", delaySubjects[0].trigger),
		new DelayActor(int64(3), delaySubjects[1].trigger),
	];
	workflow = new WorkflowActor(delays, "onDone", subject.trigger);
	assert_equal(workflow.act(1), GMTWERK_STATE.ACTIVE, "WorkflowActor stopped 1a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, false, false], "WorkflowActor stopped 1b");
	delays[0].stop();
	assert_equal(workflow.act(1), GMTWERK_STATE.STOPPED, "WorkflowActor stopped 2a");
	assert_equal([subject.triggered, delaySubjects[0].triggered, delaySubjects[1].triggered], [false, false, false], "WorkflowActor stopped 2b");
	#endregion
}
