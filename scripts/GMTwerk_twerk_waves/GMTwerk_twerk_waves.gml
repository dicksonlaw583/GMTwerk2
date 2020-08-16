///@func tw_sawtooth(phase, <positiveOnly>)
///@param {real} phase The phase of the wave (0-1)
///@param {bool} <positiveOnly> (Optional) true to use range [from, to], false to use range [from+(from-to), to]. Default: true
function tw_sawtooth(phase) {
	var positiveOnly = (argument_count > 1) ? argument[1] : true;
	return positiveOnly ? phase : ((phase <= 0.5) ? (2*phase) : (2*phase-2));
}

///@func tw_sawtooth_reverse(phase, <positiveOnly>)
///@param {real} phase The phase of the wave (0-1)
///@param {bool} <positiveOnly> (Optional) true to use range [from, to], false to use range [from+(from-to), to]. Default: true
function tw_sawtooth_reverse(phase) {
	var positiveOnly = (argument_count > 1) ? argument[1] : true;
	return positiveOnly ? (1-phase) : (1-2*phase);
}

///@func tw_sinusoid(phase, <positiveOnly>)
///@param {real} phase The phase of the wave (0-1)
///@param {bool} <positiveOnly> (Optional) true to use range [from, to], false to use range [from+(from-to), to]. Default: true
function tw_sinusoid(phase) {
	var positiveOnly = (argument_count > 1) ? argument[1] : true;
	return positiveOnly ? (0.5-0.5*cos(2*pi*phase)) : sin(2*pi*phase);
}

///@func tw_triangle(phase, <positiveOnly>)
///@param {real} phase The phase of the wave (0-1)
///@param {bool} <positiveOnly> (Optional) true to use range [from, to], false to use range [from+(from-to), to]. Default: true
function tw_triangle(phase) {
	var positiveOnly = (argument_count > 1) ? argument[1] : true;
	return positiveOnly ? ((phase <= 0.5) ? (2*phase) : (2-2*phase)) : ((phase <= 0.25) ? (4*phase) : ((phase <= 0.75) ? (2-4*phase) : (4*phase-4)));
}
