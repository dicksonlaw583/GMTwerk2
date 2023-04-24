///@func gmtk2_test_selectors()
///@desc Test GMTwerk 2's variable selectors.
function gmtk2_test_selectors() // Feather disable GM1041
{
	var selector, temp;
	global.__gmtk2_test_selectors_globalvar__ = undefined;
	global.__gmtk2_test_selectors_globalvar2__ = undefined;
	
	#region GlobalVar
	global.__gmtk2_test_selectors_globalvar__ = "foo";
	selector = GlobalVar("__gmtk2_test_selectors_globalvar__");
	assert(selector.exists(), "GlobalVar exists exists");
	assert_equal(selector.get(), "foo", "GlobalVar exists get");
	assert_is(selector.set("bar"), selector, "GlobalVar exists set");
	assert_equal(global.__gmtk2_test_selectors_globalvar__, "bar", "GlobalVar exists result after set");
	selector = GlobalVar("doesntexist");
	assert_fail(selector.exists(), "GlobalVar DNE exists");
	#endregion
	
	#region GlobalVec
	global.__gmtk2_test_selectors_globalvar__ = 100;
	global.__gmtk2_test_selectors_globalvar2__ = 200;
	selector = GlobalVec(["__gmtk2_test_selectors_globalvar__", "__gmtk2_test_selectors_globalvar2__"]);
	assert(selector.exists(), "GlobalVec exists exists");
	assert_equal(selector.get(), [100, 200], "GlobalVec exists get");
	assert_is(selector.set([101, 202]), selector, "GlobalVec exists set");
	assert_equal([global.__gmtk2_test_selectors_globalvar__, global.__gmtk2_test_selectors_globalvar2__], [101, 202], "GlobalVec exists result after set");
	selector = GlobalVec(["__gmtk2_test_selectors_globalvar__", "doesntexist"]);
	assert_fail(selector.exists(), "GlobalVec DNE exists");
	#endregion
	
	#region InstanceVar
	xstart = x;
	selector = InstanceVar("x");
	assert(selector.exists(), "InstanceVar exists exists");
	assert_equal(selector.get(), x, "InstanceVar exists get");
	assert_is(selector.set(x+5), selector, "InstanceVar exists set");
	assert_equal(x, xstart+5, "InstanceVar exists result after set");
	x = xstart;
	selector = InstanceVar("doesntexist");
	assert_fail(selector.exists(), "InstanceVar variable DNE exists");
	selector = InstanceVar("x", noone);
	assert_fail(selector.exists(), "InstanceVar noone exists");
	#endregion
	
	#region InstanceVec
	xstart = x;
	ystart = y;
	selector = InstanceVec(["x", "y"]);
	assert(selector.exists(), "InstanceVec exists exists");
	assert_equal(selector.get(), [x, y], "InstanceVec exists get");
	assert_is(selector.set([x+5, y+6]), selector, "InstanceVec exists set");
	assert_equal([x, y], [xstart+5, ystart+6], "InstanceVec exists result after set");
	x = xstart;
	y = ystart;
	selector = InstanceVec(["doesntexist", "x"]);
	assert_fail(selector.exists(), "InstanceVec variable DNE exists");
	selector = InstanceVec(["x", "y"], noone);
	assert_fail(selector.exists(), "InstanceVec noone exists");
	#endregion
	
	#region StructVar
	temp = { foo: 5, bar: 7 };
	selector = StructVar("foo", temp);
	assert(selector.exists(), "StructVar exists exists");
	assert_equal(selector.get(), 5, "StructVar exists get");
	assert_is(selector.set(6), selector, "StructVar exists set");
	assert_equal(temp.foo, 6, "StructVar exists result after set");
	selector = StructVar("baz", temp);
	assert_fail(selector.exists(), "StructVar variable DNE exists");
	// Feather disable GM1041
	selector = StructVar("bar", pointer_null);
	// Feather enable GM1041
	assert_fail(selector.exists(), "StructVar pointer_null exists");
	#endregion
	
	#region StructVec
	temp = { foo: 5, bar: 7 };
	selector = StructVec(["foo", "bar"], temp);
	assert(selector.exists(), "StructVec exists exists");
	assert_equal(selector.get(), [5, 7], "StructVec exists get");
	assert_is(selector.set([6, 8]), selector, "StructVec exists set");
	assert_equal(temp, { foo: 6, bar: 8 }, "StructVec exists result after set");
	selector = StructVec(["baz", "bar"], temp);
	assert_fail(selector.exists(), "StructVec variable DNE exists");
	// Feather disable GM1041
	selector = StructVec(["foo", "bar"], pointer_null);
	// Feather enable GM1041
	assert_fail(selector.exists(), "StructVec pointer_null exists");
	#endregion
	
	#region ArrayVar
	temp = [7, 5];
	selector = ArrayVar(1, temp);
	assert(selector.exists(), "ArrayVar exists exists");
	assert_equal(selector.get(), 5, "ArrayVar exists get");
	assert_is(selector.set(6), selector, "ArrayVar exists set");
	assert_equal(temp[1], 6, "ArrayVar exists result after set");
	selector = ArrayVar(2, temp);
	assert_fail(selector.exists(), "ArrayVar variable DNE exists");
	// Feather disable GM1041
	selector = ArrayVar(0, pointer_null);
	// Feather enable GM1041
	assert_fail(selector.exists(), "ArrayVar pointer_null exists");
	#endregion
	
	#region DataUnit
	selector = DataUnit(5);
	assert(selector.exists(), "DataUnit exists exists");
	assert_equal(selector.get(), 5, "DataUnit exists get");
	assert_is(selector.set(6), selector, "DataUnit exists set");
	assert_equal(selector.data, 6, "DataUnit exists result after set");
	#endregion
}
