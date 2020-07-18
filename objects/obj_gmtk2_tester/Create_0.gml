///@desc Run all tests
var timeA = current_time;
var fails = 0;
	
/** vv Place synchronous tests here vv **/
fails += gmtk2_test_all();
/** ^^ Place tests here ^^ **/
	
var timeB = current_time;
layer_background_blend(layer_background_get_id(layer_get_id("Background")), (fails == 0) ? c_yellow : c_red);

/** vv Place asynchronous tests here vv **/
progress = 0;
maxProgress = 9;

// Delay
Delay(1000, function() {
	++progress;
});

// Repeat
Repeat(300, 3, function() {
	++progress;
});

// ForEach
ForEach(200, ["foo", "bar", "baz", "qux", "waahoo"], function() {
	++progress;
});

// Timeout for asynchronous test is 1 second (plus one step)
alarm[0] = room_speed+1;
/** ^^ Place asynchronous tests here ^^ **/
