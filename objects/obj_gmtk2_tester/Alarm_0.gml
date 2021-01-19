///@desc Asynchronous tests must complete in 1 second
var keys = variable_struct_get_names(elapsed);
var nKeys = array_length(keys);
for (var i = 0; i < nKeys; ++i) {
	var key = keys[i];
	var value = variable_struct_get(elapsed, key);
	if (is_method(value)) continue;
	assert_equal(value, 0, "Unfinished GMTwerk 2 actor by asynchronous timeout: " + key);
}
if (currentElapsed == 0) {
	layer_background_blend(layer_background_get_id(layer_get_id("Background")), c_green);
} else {
	layer_background_blend(layer_background_get_id(layer_get_id("Background")), c_orange);
}
instance_destroy();
