///@desc Run twerks if active
var _timeUnits = is_undefined(global.__gmtwerk_host_speed__) ? delta_time : global.__gmtwerk_host_speed__;
__twerks__.act(_timeUnits);
