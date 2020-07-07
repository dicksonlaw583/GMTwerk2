var timeA = current_time;
var fails = 0;
	
/** vv Place tests here vv **/
fails += gmtk2_test_all();
/** ^^ Place tests here ^^ **/
	
var timeB = current_time;
show_debug_message("GMTwerk2 tests completed in " + string(timeB-timeA) + "ms.");
layer_background_blend(layer_background_get_id(layer_get_id("Background")), (fails == 0) ? c_green : c_red);
