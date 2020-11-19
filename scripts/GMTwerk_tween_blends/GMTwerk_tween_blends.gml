///@func tb_rgb(col0, col1, t)
///@param col0
///@param col1
///@param t
function tb_rgb(col0, col1, t) {
	return is_undefined(t) ? max(abs(color_get_red(col0)-color_get_red(col1)), abs(color_get_green(col0)-color_get_green(col1)), abs(color_get_blue(col0)-color_get_blue(col1))) : merge_colour(col0, col1, t);
}

///@func tb_hsv(col0, col1, t)
///@param col0
///@param col1
///@param t
function tb_hsv(col0, col1, t) {
	var _hd0 = floor(color_get_hue(col0)*360/256);
	var _hd1 = floor(color_get_hue(col1)*360/256);
	var _s0 = color_get_saturation(col0);
	var _s1 = color_get_saturation(col1);
	var _v0 = color_get_value(col0);
	var _v1 = color_get_value(col1);
	var _ad = angle_difference(_hd1, _hd0);
	if (is_undefined(t)) {
		return max(abs(ceil(_ad*256/360)), abs(_s1-_s0), abs(_v1-_v0));
	}
	var _na = _hd0+_ad*t;
	return make_color_hsv(round(((_na < 0) ? _na+360 : ((_na >= 360) ? _na-360 : _na))*256/360), round(lerp(_s0, _s1, t)), round(lerp(_v0, _v1, t)));
}

///@func tb_angle(angle0, angle1, t)
///@param angle0
///@param angle1
///@param t
function tb_angle(angle0, angle1, t) {
	var _ad = angle_difference(angle1, angle0);
	if (is_undefined(t)) {
		return abs(_ad);
	}
	var _na = angle0+_ad*t;
	return (_na < 0) ? _na+360 : ((_na >= 360) ? _na-360 : _na);
}

///@func tb_vector(v0, v1, t)
///@param v0
///@param v1
///@param t
function tb_vector(v0, v1, t) {
	var _vdim = array_length(v0);
	if (is_undefined(t)) {
		var _vsum = 0;
		for (var i = _vdim-1; i >= 0; --i) {
			_vsum += sqr(v0[i]-v1[i]);
		}
		return sqrt(_vsum);
	}
	var _vout = array_create(_vdim);
	for (var i = _vdim-1; i >= 0; --i) {
		_vout[i] = lerp(v0[i], v1[i], t);
	}
	return _vout;
}
