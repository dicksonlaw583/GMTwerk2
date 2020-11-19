///@func GMTwerkSelector()
///@desc Base class for all selectors
function GMTwerkSelector() constructor {
}

///@func GlobalVarSelector(name)
///@param {string} name The variable's name
///@desc Selector for a global variable
function GlobalVarSelector(_name) : GMTwerkSelector() constructor {
	name = _name;
	
	///@func exists()
	///@desc Return whether the target exists
	static exists = function() {
		return variable_global_exists(name);
	};
	
	///@func get()
	///@desc Return the target's value
	static get = function() {
		return variable_global_get(name);
	};
	
	///@func set()
	///@desc Set the target's value and return self
	static set = function(val) {
		variable_global_set(name, val);
		return self;
	};
}

///@func GlobalVar(name)
///@param {string} name The variable's name
///@desc Return a GlobalVarSelector targeting the named global variable
function GlobalVar(name) {
	gml_pragma("forceinline");
	return new GlobalVarSelector(name);
}

///@func GlobalVecSelector(names)
///@param {string[]} names Array of variable names
///@desc Selector for multiple global variables
function GlobalVecSelector(_names) : GMTwerkSelector() constructor {
	names = _names;
	dim = array_length(names);
	
	///@func exists()
	///@desc Return whether the target exists
	static exists = function() {
		for (var i = dim-1; i >= 0; --i) {
			if (!variable_global_exists(names[i])) return false;
		}
		return true;
	};
	
	///@func get()
	///@desc Return the target's value
	static get = function() {
		var v = array_create(dim);
		for (var i = dim-1; i >= 0; --i) {
			v[i] = variable_global_get(names[i]);
		}
		return v;
	};
	
	///@func set()
	///@desc Set the target's value and return self
	static set = function(val) {
		for (var i = dim-1; i >= 0; --i) {
			variable_global_set(names[i], val[i]);
		}
		return self;
	};
}

///@func GlobalVec(names)
///@param {string[]} names The variables' names
///@desc Return a GlobalVecSelector targeting the named global variables
function GlobalVec(names) {
	gml_pragma("forceinline");
	return new GlobalVecSelector(names);
}

///@func InstanceVarSelector(name, inst)
///@param {string} name The variable's name
///@param {id} inst The instance ID of the variable's owner
///@desc Selector for an instance variable
function InstanceVarSelector(_name, _inst) : GMTwerkSelector() constructor {
	name = _name;
	inst = _inst;
	
	///@func exists()
	///@desc Return whether the target exists
	static exists = function() {
		return instance_exists(inst) && variable_instance_exists(inst, name);
	};
	
	///@func get()
	///@desc Return the target's value
	static get = function() {
		return variable_instance_get(inst, name);
	};
	
	///@func set()
	///@desc Set the target's value and return self
	static set = function(val) {
		variable_instance_set(inst, name, val);
		return self;
	};
}

///@func InstanceVar(name, <inst>)
///@param {string} name The variable's name
///@param {id} <inst> (Optional) The instance ID of the variable's owner (default: current instance ID)
///@desc Return an InstanceVarSelector targeting the named instance variable
function InstanceVar() {
	gml_pragma("forceinline");
	return new InstanceVarSelector(argument[0], (argument_count > 1) ? argument[1] : id);
}

///@func InstanceVecSelector(names)
///@param {string[]} names Array of variable names
///@param {id} inst The instance ID of the variable's owner
///@desc Selector for multiple instance variables
function InstanceVecSelector(_names, _inst) : GMTwerkSelector() constructor {
	names = _names;
	dim = array_length(names);
	inst = _inst;
	
	///@func exists()
	///@desc Return whether the target exists
	static exists = function() {
		for (var i = dim-1; i >= 0; --i) {
			if (!variable_instance_exists(inst, names[i])) return false;
		}
		return true;
	};
	
	///@func get()
	///@desc Return the target's value
	static get = function() {
		var v = array_create(dim);
		for (var i = dim-1; i >= 0; --i) {
			v[i] = variable_instance_get(inst, names[i]);
		}
		return v;
	};
	
	///@func set()
	///@desc Set the target's value and return self
	static set = function(val) {
		for (var i = dim-1; i >= 0; --i) {
			variable_instance_set(inst, names[i], val[i]);
		}
		return self;
	};
}

///@func InstanceVec(names)
///@param {string[]} names The variables' names
///@param {id} <inst> (Optional) The instance ID of the variable's owner (default: current instance ID)
///@desc Return a InstanceVecSelector targeting the named instance variables
function InstanceVec() {
	gml_pragma("forceinline");
	return new InstanceVecSelector(argument[0], (argument_count > 1) ? argument[1] : id);
}

///@func StructVarSelector(name, strc)
///@param {string} name The targeted struct key
///@param {struct} strc The target struct
///@desc Selector for a value in a struct
function StructVarSelector(_name, _strc) constructor {
	name = _name;
	strc = _strc;
	
	///@func exists()
	///@desc Return whether the target exists
	static exists = function() {
		return is_struct(strc) && variable_struct_exists(strc, name);
	};
	
	///@func get()
	///@desc Return the target's value
	static get = function() {
		return variable_struct_get(strc, name);
	};
	
	///@func set()
	///@desc Set the target's value and return self
	static set = function(val) {
		variable_struct_set(strc, name, val);
		return self;
	};
}

///@func StructVar(name, strc)
///@param {string} name The targeted struct key
///@param {struct} strc The target struct
///@desc Return an StructVarSelector targeting the named struct variable
function StructVar(name, strc) {
	gml_pragma("forceinline");
	return new StructVarSelector(name, strc);
}

///@func StructVecSelector(name, strc)
///@param {string[]} names The targeted struct keys
///@param {struct} strc The target struct
///@desc Selector for several values in a struct
function StructVecSelector(_names, _strc) constructor {
	names = _names;
	dim = array_length(names);
	strc = _strc;
	
	///@func exists()
	///@desc Return whether the target exists
	static exists = function() {
		if (!is_struct(strc)) return false;
		for (var i = dim-1; i >= 0; --i) {
			if (!variable_struct_exists(strc, names[i])) return false;
		}
		return true;
	};
	
	///@func get()
	///@desc Return the target's value
	static get = function() {
		var v = array_create(dim);
		for (var i = dim-1; i >= 0; --i) {
			v[i] = variable_struct_get(strc, names[i]);
		}
		return v;
	};
	
	///@func set()
	///@desc Set the target's value and return self
	static set = function(val) {
		for (var i = dim-1; i >= 0; --i) {
			variable_struct_set(strc, names[i], val[i]);
		}
		return self;
	};
}

///@func StructVec(names, strc)
///@param {string[]} name The targeted struct keys
///@param {struct} strc The target struct
///@desc Return an StructVecSelector targeting the named struct variables
function StructVec(names, strc) {
	gml_pragma("forceinline");
	return new StructVecSelector(names, strc);
}

///@func ArrayVarSelector(index, array)
///@param {int} index The targeted position in the array
///@param {array} array The targeted array
///@desc Selector for a value in an array
function ArrayVarSelector(_index, _array) constructor {
	index = _index;
	array = _array;
	
	///@func exists()
	///@desc Return whether the target exists
	static exists = function() {
		return is_array(array) && array_length(array) > index;
	};
	
	///@func get()
	///@desc Return the target's value
	static get = function() {
		return array[index];
	};
	
	///@func set()
	///@desc Set the target's value and return self
	static set = function(val) {
		array[@index] = val;
		return self;
	};
}

///@func ArrayVar(index, array)
///@param {int} index The targeted position in the array
///@param {array} array The targeted array
///@desc Return an ArrayVarSelector targeting the position in the given array
function ArrayVar(index, array) {
	gml_pragma("forceinline");
	return new ArrayVarSelector(index, array);
}

///@func DataUnitSelector(data)
///@param data The starting data value
///@desc Selector for a placeholder value
function DataUnitSelector(_data) : GMTwerkSelector() constructor {
	data = _data;
	
	///@func exists()
	///@desc Return whether the target exists
	static exists = function() {
		return true;
	};
	
	///@func get()
	///@desc Return the target's value
	static get = function() {
		return data;
	};
	
	///@func set()
	///@desc Set the target's value and return self
	static set = function(val) {
		data = val;
		return self;
	};
}

///@func DataUnit(data)
///@param data The starting data value
///@desc Return a DataUnitSelector for a placeholder value
function DataUnit(data) {
	gml_pragma("forceinline");
	return new DataUnitSelector(data);
}
