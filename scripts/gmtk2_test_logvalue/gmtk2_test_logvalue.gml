///@func gmtk2_test_logvalue()
function gmtk2_test_logvalue() {
	var selector, listener, logger;
	
	#region LogValue periodic run
	selector = DataUnit("begin");
	listener = {
		lastCalledWith: undefined,
		call: function(v) { lastCalledWith = v; },
	};
	logger = new LogValueActor(selector, 2, int64(2), "startValue", "", "onLog", listener.call);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["", "", undefined], "Logger periodic run 0");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["", "", undefined], "Logger periodic run 1");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin", "", "begin"], "Logger periodic run 2a");
	assert_equal([logger.get(0), logger.get(1)], ["", "begin"], "Logger periodic run 2b");
	selector.set("begin2");
	listener.lastCalledWith = undefined;
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin", "", undefined], "Logger periodic run 3");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin2", "begin", "begin2"], "Logger periodic run 4a");
	assert_equal([logger.get(0), logger.get(1)], ["begin", "begin2"], "Logger periodic run 4b");
	selector.set("begin3");
	listener.lastCalledWith = undefined;
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin2", "begin", undefined], "Logger periodic run 5");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin3", "begin2", "begin3"], "Logger periodic run 6a");
	assert_equal([logger.get(0), logger.get(1)], ["begin2", "begin3"], "Logger periodic run 6b");
	listener.lastCalledWith = undefined;
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin3", "begin2", undefined], "Logger periodic run 7");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin3", "begin3", "begin3"], "Logger periodic run 8a");
	assert_equal([logger.get(0), logger.get(1)], ["begin3", "begin3"], "Logger periodic run 8b");
	#endregion
	
	#region LogValue periodic on-change run
	selector = DataUnit("begin");
	listener = {
		lastCalledWith: undefined,
		call: function(v) { lastCalledWith = v; },
	};
	logger = new LogValueActor(selector, 2, int64(-2), "startValue", "", "onLog", listener.call);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["", "", undefined], "Logger periodic on-change run 0");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["", "", undefined], "Logger periodic on-change run 1");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin", "", "begin"], "Logger periodic on-change run 2a");
	assert_equal([logger.get(0), logger.get(1)], ["", "begin"], "Logger periodic on-change run 2b");
	selector.set("begin2");
	listener.lastCalledWith = undefined;
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin", "", undefined], "Logger periodic on-change run 3");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin2", "begin", "begin2"], "Logger periodic on-change run 4a");
	assert_equal([logger.get(0), logger.get(1)], ["begin", "begin2"], "Logger periodic on-change run 4b");
	selector.set("begin3");
	listener.lastCalledWith = undefined;
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin2", "begin", undefined], "Logger periodic on-change run 5");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin3", "begin2", "begin3"], "Logger periodic on-change run 6a");
	assert_equal([logger.get(0), logger.get(1)], ["begin2", "begin3"], "Logger periodic on-change run 6b");
	listener.lastCalledWith = undefined;
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin3", "begin2", undefined], "Logger periodic on-change run 7");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin3", "begin2", undefined], "Logger periodic on-change run 8a");
	assert_equal([logger.get(0), logger.get(1)], ["begin2", "begin3"], "Logger periodic on-change run 8b");
	#endregion
	
	#region LogValue on-change run
	selector = DataUnit("begin");
	listener = {
		lastCalledWith: undefined,
		call: function(v) { lastCalledWith = v; },
	};
	logger = new LogValueActor(selector, 2, 0, "startValue", "", "onLog", listener.call);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["", "", undefined], "Logger on-change run 0");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin", "", "begin"], "Logger on-change run 1a");
	assert_equal([logger.get(0), logger.get(1)], ["", "begin"], "Logger periodic on-change run 1b");
	listener.lastCalledWith = undefined;
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin", "", undefined], "Logger on-change run 2");
	selector.set("begin2");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin2", "begin", "begin2"], "Logger on-change run 3a");
	assert_equal([logger.get(0), logger.get(1)], ["begin", "begin2"], "Logger periodic on-change run 3b");
	listener.lastCalledWith = undefined;
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin2", "begin", undefined], "Logger on-change run 4");
	selector.set("begin3");
	logger.act(1);
	assert_equal([logger.get(-1), logger.get(-2), listener.lastCalledWith], ["begin3", "begin2", "begin3"], "Logger on-change run 5a");
	assert_equal([logger.get(0), logger.get(1)], ["begin2", "begin3"], "Logger periodic on-change run 5b");
	#endregion
}
