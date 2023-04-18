///@desc Run all tests
var timeA = current_time;
var fails = 0;
	
/** vv Place synchronous tests here vv **/
fails += gmtk2_test_all();
/** ^^ Place tests here ^^ **/
	
var timeB = current_time;
layer_background_blend(layer_background_get_id(layer_get_id("Background")), (fails == 0) ? c_yellow : c_red);

/** vv Place asynchronous tests here vv **/
elapsed = {
	total: function() {
		///Feather disable GM1041
		var keys = variable_struct_get_names(self);
		///Feather enable GM1041
		var _sum = 0;
		for (var i = array_length(keys)-1; i >= 0; --i) {
			var key = keys[i];
			///Feather disable GM1041
			var value = variable_struct_get(self, key);
			///Feather enable GM1041
			if (is_method(value)) continue;
			_sum += value;
		}
		return _sum;
	}
};

// Delay (1)
elapsed._Delay = 1;
Delay(1000, function() {
	--elapsed._Delay;
});

// Repeat (3)
elapsed._Repeat = 3;
Repeat(300, 3, function() {
	--elapsed._Repeat;
});

// ForEach (5)
elapsed._ForEach = 5;
ForEach(200, ["foo", "bar", "baz", "qux", "waahoo"], function() {
	--elapsed._ForEach;
});

// While (4)
elapsed._While = 4;
whilenum = 0;
While(200, function() {
	return whilenum < 4;
}, function() {
	++whilenum;
	--elapsed._While;
});

// WhenTrue (1)
elapsed._WhenTrue = 1;
WhenTrue(function() {
	return alarm[0] < 10;
}, function() {
	--elapsed._WhenTrue;
});

// WhenToggle (2)
elapsed._WhenToggle = 2;
progressWhenToggle = function() {
	--elapsed._WhenToggle;
};
WhenToggle(function() {
	return 10 <= alarm[0] && alarm[0] <= 20;
}, progressWhenToggle, progressWhenToggle);

// Itinerary (6)
elapsed._Itinerary = 6;
progressItinerary = function() {
	--elapsed._Itinerary;
};
Itinerary(0, [
	[100, progressItinerary],
	[300, progressItinerary],
	[700, progressItinerary],
]);
Itinerary(900, [
	[700, progressItinerary],
	[500, progressItinerary],
	[300, progressItinerary],
]);

// LogValue (5)
elapsed._LogValue = 5;
LogValue(DataUnit(0), 3, 200, ["onLog", function() {
	--elapsed._LogValue;
}]);

// Tween (4)
elapsed._Tween = 4;
progressTween = function() {
	--elapsed._Tween;
};
Tween(DataUnit(0), 5, 800, ["onDone", progressTween]);
ZenosTween(DataUnit(8), 0, 0.25, ["onDone", progressTween]);
StepTween(DataUnit(0), game_get_speed(gamespeed_fps), 1, ["onDone", progressTween]);
ChannelTween(DataUnit(8), 0, 800, ac_gmtk2_linear, ["onDone", progressTween]);

// Track (4)
elapsed._Track = 4;
progressTrack = function() {
	--elapsed._Track;
};
Track(DataUnit(0), DataUnit(5), 800, ["onReach", progressTrack]);
ZenosTrack(DataUnit(8), DataUnit(0), 0.25, ["onReach", progressTrack]);
StepTrack(DataUnit(0), DataUnit(game_get_speed(gamespeed_fps)), 1, ["onReach", progressTrack]);
ChannelTrack(DataUnit(8), DataUnit(0), 800, ac_gmtk2_linear, ["onReach", progressTrack]);

// Twerk (5)
elapsed._Twerk = 5;
progressTwerk = function() {
	--elapsed._Twerk;
};
WaveTwerk(DataUnit(0), 6, 2, 400, ["onDone", progressTwerk]);
FlashTwerk(DataUnit(0), 1, 5, 100, 100, ["onDone", progressTwerk]);
ShakeTwerk(DataUnit(0), 4, 2, 500, ["onDone", progressTwerk]);
ChannelTwerk(DataUnit(0), 7, 4, 200, ac_gmtk2_triangle_wave, ["onDone", progressTwerk]);
DubstepTwerk(DataUnit(0), 8, 3, 300, ["onDone", progressTwerk]);

// Workflow (3)
elapsed._Workflow = 3;
progressWorkflow = function() {
	--elapsed._Workflow;
};
Workflow([
	function() { return Delay(450, progressWorkflow); },
	function() { },
	function() { return Delay(450, progressWorkflow); },
], ["onDone", progressWorkflow]);

// Timeout for asynchronous test is 1 second (plus one step)
alarm[0] = game_get_speed(gamespeed_fps)+1;

// Calculate max progress
maxElapsed = elapsed.total();
currentElapsed = maxElapsed;
/** ^^ Place asynchronous tests here ^^ **/
