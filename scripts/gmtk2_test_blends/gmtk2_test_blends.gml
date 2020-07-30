///@func gmtk2_test_blends()
function gmtk2_test_blends() {
	// RGB kernel
	assert_equal(tb_rgb(make_color_rgb(255, 255, 255), make_color_rgb(127, 127, 127), undefined), 128);
	assert_equal(tb_rgb(make_color_rgb(255, 255, 255), make_color_rgb(127, 127, 127), 0.5), make_color_rgb(191, 191, 191));

	// HSV kernel
	assert_equal(tb_hsv(c_red, c_lime, undefined), 85);
	assert_equal(tb_hsv(c_red, c_lime, 0.5), make_color_rgb(255, 252, 0));

	// Angle kernel
	assert_equal(tb_angle(45, 65, undefined), 20);
	assert_equal(tb_angle(20, 340, undefined), 40);
	assert_equal(tb_angle(340, 20, undefined), 40);
	assert_equal(tb_angle(45, 65, 0.75), 60);
	assert_equal(tb_angle(20, 340, 0.75), 350);
	assert_equal(tb_angle(340, 20, 0.75), 10);
}