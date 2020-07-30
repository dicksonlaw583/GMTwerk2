function __te_bounce_kernel__(t, b, c) {
	if (t < (1/2.75)) {
		return c*(7.5625*t*t) + b;
	} else if (t < (2/2.75)) {
		t -= 1.5/2.75;
		return c*(7.5625*t*t + .75) + b;
	} else if (t < (2.5/2.75)) {
		t -= 2.25/2.75;
		return c*(7.5625*t*t + .9375) + b;
	} else {
		t -= 2.625/2.75;
		return c*(7.5625*t*t + .984375) + b;
	}
}

///@func te_back_in(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_back_in(x0, x1, t) {
	var s = 1.70158;
	return (x1-x0)*t*t*((s+1)*t - s) + x0;
}

///@func te_back_inout(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_back_inout(x0, x1, t) {
	var s = 1.70158*1.525;
	t /= 1/2;
	if (t < 1) {
		return (x1-x0)/2*(t*t*((s+1)*t - s)) + x0;
	}
	else {
		t -= 2;
		return (x1-x0)/2*(t*t*((s+1)*t + s) + 2) + x0;
	}
}

///@func te_back_out(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_back_out(x0, x1, t) {
	var s = 1.70158;
	t = t-1;
	return (x1-x0)*(t*t*((s+1)*t + s) + 1) + x0;
}

///@func te_bounce_in(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_bounce_in(x0, x1, t) {
	var c = x1-x0;
	return c - __te_bounce_kernel__(1-t, 0, c) + x0;
}

///@func te_bounce_inout(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_bounce_inout(x0, x1, t) {
	var c = x1-x0;
	if (t < 1/2) {
		return te_bounce_in(x0, x0+c/2, 2*t)
	}
	else {
		return te_bounce_out(x0+c/2, x0+c, 2*(t-0.5));
	}
}

///@func te_bounce_out(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_bounce_out(x0, x1, t) {
	return __te_bounce_kernel__(t, x0, x1-x0);
}

///@func te_circ_in(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_circ_in(x0, x1, t) {
	return (x0-x1) * (sqrt(1 - t*t) - 1) + x0;
}

///@func te_circ_inout(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_circ_inout(x0, x1, t) {
	t /= 1/2;
	if (t < 1) {
		return (x0-x1)/2 * (sqrt(1 - t*t) - 1) + x0;
	}
	else {
		t -= 2;
		return (x1-x0)/2 * (sqrt(1 - t*t) + 1) + x0;
	}
}

///@func te_circ_out(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_circ_out(x0, x1, t) {
	t = t-1;
	return (x1-x0) * sqrt(1 - t*t) + x0;
}

///@func te_cubic_in(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_cubic_in(x0 ,x1, t) {
	return (x1-x0)*t*t*t+x0;
}

///@func te_cubic_inout(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_cubic_inout(x0, x1, t) {
	t /= 1/2;
	if (t < 1) {
		return (x1-x0)/2*t*t*t + x0;
	}
	else {
		t -= 2;
		return (x1-x0)/2 * (t*t*t + 2) + x0;
	}
}

///@func te_cubic_out(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_cubic_out(x0, x1, t) {
	t = t - 1;
	return (x1-x0)*(t*t*t+1)+x0;
}

///@func te_elastic_in(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_elastic_in(x0, x1, t) {
	var c = x1-x0;
	var s = 1.70158;
	if (t == 0) {
		return x0;
	}
	if (t == 1) {
		return x0+c;
	}

	var p = 1*0.6; //Original is 0.3
	var a = c;
	if (a < abs(c)) {
		a = c;
		s = p/4;
	}
	else {
		s = (p/(2*pi)) * arcsin(c/a);
	}

	t -= 1;
	return -(a*power(2,10*t) * sin( (t*1-s)*(2*pi)/p )) + x0;
}

///@func te_elastic_inout(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_elastic_inout(x0, x1, t) {
	var c = x1-x0;
	var s = 1.70158;
	t /= 1/2;

	if (t == 0) {
		return x0;
	}
	if (t == 2) {
		return x0+c;
	}

	var p = 1*(0.6*1.5); //Original is 0.3 => Modified to 0.6
	var a = c;
	if (a < abs(c)) {
		a = c;
		s = p/4;
	}
	else {
		s = (p/(2*pi)) * arcsin(c/a);
	}

	t -= 1;
	if (t < 0) {
		return -0.5*(a*power(2,10*t) * sin( (t*1-s)*(2*pi)/p )) + x0;
	}
	else {
		return a*power(2,-10*t) * sin( (t*1-s)*(2*pi)/p )*0.5 + c + x0;
	}
}

///@func te_elastic_out(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_elastic_out(x0, x1, t) {
	var c = x1-x0;
	var s = 1.70158;

	if (t == 0) {
		return x0;
	}
	if (t == 1) {
		return x0+c;
	}

	var p = 1*0.6; //Original is 0.3
	var a = c;
	if (a < abs(c)) {
		a = c;
		s = p/4;
	}
	else {
		s = (p/(2*pi)) * arcsin(c/a);
	}

	return a*power(2,-10*t) * sin( (t*1-s)*(2*pi)/p ) + c + x0;
}

///@func te_exp_in(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_exp_in(x0, x1, t) {
	if (t == 0) {
		return x0;
	}
	else {
		return (x1-x0) * power(2, 10*(t/1-1)) + x0;
	}
}

///@func te_exp_inout(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_exp_inout(x0, x1, t) {
	if (t == 0) {
		return x0;
	}
	if (t == 1) {
		return x1;
	}
	t /= 1/2;
	if (t < 1) {
		return (x1-x0)/2 * power(2, 10*(t-1)) + x0;
	}
	else {
		t -= 1;
		return (x1-x0)/2 * (-power(2, -10*t)+2) + x0;
	}
}

///@func te_exp_out(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_exp_out(x0, x1, t) {
	if (t == 1) {
		return x1;
	}
	else {
		return (x1-x0) * (-power(2, -10*t/1)+1) + x0;
	}
}

///@func te_linear(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_linear(x0, x1, t) {
	return lerp(x0, x1, t);
}

///@func te_quadratic_in(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_quadratic_in(x0 ,x1, t) {
	return (x1-x0)*t*t+x0;
}

///@func te_quadratic_inout(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_quadratic_inout(x0, x1, t) {
	t /= 1/2;
	if (t < 1) {
		return (x1-x0)/2*t*t + x0;
	}
	else {
		--t;
		return (x0-x1)/2 * (t*(t-2) - 1) + x0;
	}
}

///@func te_quadratic_out(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_quadratic_out(x0, x1, t) {
	return (x0-x1)*t*(t-2)+x0;
}

///@func te_quartic_in(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_quartic_in(x0, x1, t) {
	return (x1-x0)*t*t*t*t + x0;
}

///@func te_quartic_inout(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_quartic_inout(x0, x1, t) {
	t /= 1/2;
	if (t < 1) {
		return (x1-x0)/2*t*t*t*t + x0;
	}
	else {
		t -= 2;
		return (x0-x1)/2 * (t*t*t*t - 2) + x0;
	}
}

///@func te_quartic_out(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_quartic_out(x0, x1, t) {
	t = t - 1;
	return (x0-x1)*(t*t*t*t-1) + x0;
}

///@func te_quintic_in(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_quintic_in(x0, x1, t) {
	return (x1-x0)*t*t*t*t*t + x0;
}

///@func te_quintic_inout(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_quintic_inout(x0, x1, t) {
	t /= 1/2;
	if (t < 1) {
		return (x1-x0)/2*t*t*t*t*t + x0;
	}
	else {
		t -= 2;
		return (x1-x0)/2 * (t*t*t*t*t + 2) + x0;
	}
}

///@func te_quintic_out(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_quintic_out(x0, x1, t) {
	t = t - 1;
	return (x1-x0)*(t*t*t*t*t+1) + x0;
}

///@func te_sine_in(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_sine_in(x0, x1, t) {
	var c = x1-x0;
	return -c * cos(t * pi/2) + c + x0;
}

///@func te_sine_inout(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_sine_inout(x0, x1, t) {
	return (x0-x1)/2 * (cos(t * pi) - 1) + x0;
}

///@func te_sine_out(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_sine_out(x0, x1, t) {
	return (x1-x0) * sin(t * pi/2) + x0;
}

///@func te_swing(x0, x1, t)
///@param x0
///@param x1
///@param t
function te_swing(x0, x1, t) {
	return lerp(x0, x1, 0.5-cos(t*pi)/2);
}
