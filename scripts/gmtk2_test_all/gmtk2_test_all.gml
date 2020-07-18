///@func gmtk2_test_all()
function gmtk2_test_all() {
	global.__test_fails__ = 0;
	var timeA = current_time;
	
	/** vv Place tests here vv **/
	gmtk2_test_basics();
	gmtk2_test_delay();
	gmtk2_test_repeat();
	gmtk2_test_foreach();
	gmtk2_test_while();
	/** ^^ Place tests here ^^ **/
	
	var timeB = current_time;
	show_debug_message("GMTwerk2 synchronous tests completed in " + string(timeB-timeA) + "ms.");
	return global.__test_fails__;
}
