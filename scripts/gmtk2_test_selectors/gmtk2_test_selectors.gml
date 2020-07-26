///@func gmtk2_test_selectors()
function gmtk2_test_selectors() {
	var selector, temp;
	global.__gmtk2_test_selectors_globalvar__ = undefined;
	
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
	
	#region StructVar
	temp = { foo: 5, bar: 7 };
	selector = StructVar("foo", temp);
	assert(selector.exists(), "StructVar exists exists");
	assert_equal(selector.get(), 5, "StructVar exists get");
	assert_is(selector.set(6), selector, "StructVar exists set");
	assert_equal(temp.foo, 6, "StructVar exists result after set");
	selector = StructVar("baz", temp);
	assert_fail(selector.exists(), "StructVar variable DNE exists");
	selector = StructVar("bar", pointer_null);
	assert_fail(selector.exists(), "StructVar pointer_null exists");	
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
	selector = ArrayVar(0, pointer_null);
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
