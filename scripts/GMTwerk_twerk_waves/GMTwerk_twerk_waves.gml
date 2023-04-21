///@func tw_sawtooth(phase, [positiveOnly])
///@param {real} phase The phase of the wave (0-1)
///@param {bool} [positiveOnly] (Optional) true to use range [from, to], false to use range [from+(from-to), to]. Default: true
///@return {real}
///@desc Wave function for a sawtooth wave with upward teeth.
function tw_sawtooth(phase, positiveOnly=true) {
	return positiveOnly ? phase : ((phase <= 0.5) ? (2*phase) : (2*phase-2));
}

///@func tw_sawtooth_reverse(phase, [positiveOnly])
///@param {real} phase The phase of the wave (0-1)
///@param {bool} [positiveOnly] (Optional) true to use range [from, to], false to use range [from+(from-to), to]. Default: true
///@return {real}
///@desc Wave function for a sawtooth wave with downward teeth.
function tw_sawtooth_reverse(phase, positiveOnly=true) {
	return positiveOnly ? (1-phase) : (1-2*phase);
}

///@func tw_sinusoid(phase, [positiveOnly])
///@param {real} phase The phase of the wave (0-1)
///@param {bool} [positiveOnly] (Optional) true to use range [from, to], false to use range [from+(from-to), to]. Default: true
///@return {real}
///@desc Wave function for a sine wave.
function tw_sinusoid(phase, positiveOnly=true) {
	return positiveOnly ? (0.5-0.5*cos(2*pi*phase)) : sin(2*pi*phase);
}

///@func tw_triangle(phase, [positiveOnly])
///@param {real} phase The phase of the wave (0-1)
///@param {bool} [positiveOnly] (Optional) true to use range [from, to], false to use range [from+(from-to), to]. Default: true
///@return {real}
///@desc Wave function for a triangle wave.
function tw_triangle(phase, positiveOnly=true) {
	return positiveOnly ? ((phase <= 0.5) ? (2*phase) : (2-2*phase)) : ((phase <= 0.25) ? (4*phase) : ((phase <= 0.75) ? (2-4*phase) : (4*phase-4)));
}
