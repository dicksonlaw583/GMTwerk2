///@desc Asynchronous tests must complete in 1 second
assert_equal(maxProgress, progress, "GMTwerk 2 asynchronous test timeout");
if (progress == maxProgress) {
	layer_background_blend(layer_background_get_id(layer_get_id("Background")), c_green);
	instance_destroy();
}
