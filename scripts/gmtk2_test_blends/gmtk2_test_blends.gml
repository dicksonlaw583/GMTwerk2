///@func gmtk2_test_blends()
function gmtk2_test_blends() {
	// RGB kernel
	assert_equal(tb_rgb(make_color_rgb(255, 255, 255), make_color_rgb(127, 127, 127), undefined), 128, "RGB kernel 1");
	assert_equal(tb_rgb(make_color_rgb(255, 255, 255), make_color_rgb(127, 127, 127), 0.5), make_color_rgb(191, 191, 191), "RGB kernel 2");

	// HSV kernel
	assert_equal(tb_hsv(c_red, c_lime, undefined), 85, "HSV kernel 1");
	assert_equal(tb_hsv(c_red, c_lime, 0.5), make_color_rgb(255, 252, 0), "HSV kernel 2");

	// Angle kernel
	assert_equal(tb_angle(45, 65, undefined), 20, "Angle kernel 1");
	assert_equal(tb_angle(20, 340, undefined), 40, "Angle kernel 2");
	assert_equal(tb_angle(340, 20, undefined), 40, "Angle kernel 3");
	assert_equal(tb_angle(45, 65, 0.75), 60, "Angle kernel 4");
	assert_equal(tb_angle(20, 340, 0.75), 350, "Angle kernel 5");
	assert_equal(tb_angle(340, 20, 0.75), 10, "Angle kernel 6");
	
	// Vector kernel
	assert_equalish(tb_vector([2, 4], [5, 8], undefined), 5, "Vector kernel 1");
	assert_equalish(tb_vector([1, 1], [-5, -7], undefined), 10, "Vector kernel 2");
	assert_equalish(tb_vector([2, 4], [5, 8], 0.5), [3.5, 6], "Vector kernel 3");
	assert_equalish(tb_vector([1, 1], [-5, -7], 0.75), [-3.5, -5], "Vector kernel 4");
}