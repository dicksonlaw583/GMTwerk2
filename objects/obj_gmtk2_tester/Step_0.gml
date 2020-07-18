///@desc Check async test status

// When done, set background to green and self-destruct
if (progress == maxProgress) {
	layer_background_blend(layer_background_get_id(layer_get_id("Background")), c_green);
	instance_destroy();
}
