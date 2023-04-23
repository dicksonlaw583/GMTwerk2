///@class GMTwerkSelector()
///@desc Base class for all selectors
function GMTwerkSelector() constructor {
}

///@class GlobalVarSelector(name)
///@param {string} name The variable's name
///@desc Selector for a global variable
function GlobalVarSelector(name) : GMTwerkSelector() constructor {
	self.name = name;
	
	///@func exists()
	///@self GlobalVarSelector
	///@return {Bool}
	///@desc Return whether the target exists
	static exists = function() {
		return variable_global_exists(name);
	};
	
	///@func get()
	///@self GlobalVarSelector
	///@return {Any}
	///@desc Return the target's value
	static get = function() {
		return variable_global_get(name);
	};
	
	///@func set(val)
	///@self GlobalVarSelector
	///@param {Any} val The value to set to
	///@return {Struct.GlobalVarSelector}
	///@desc Set the target's value and return self
	static set = function(val) {
		variable_global_set(name, val);
		///Feather disable GM1045
		return self;
		///Feather enable GM1045
	};
}

///@func GlobalVar(name)
///@param {string} name The variable's name
///@return {Struct.GlobalVarSelector}
///@pure
///@desc Return a GlobalVarSelector targeting the named global variable
function GlobalVar(name) {
	gml_pragma("forceinline");
	return new GlobalVarSelector(name);
}

///@class GlobalVecSelector(names)
///@param {Array<String>} names Array of variable names
///@desc Selector for multiple global variables
function GlobalVecSelector(names) : GMTwerkSelector() constructor {
	self.names = names;
	dim = array_length(names);
	
	///@func exists()
	///@self GlobalVecSelector
	///@return {Bool}
	///@desc Return whether the target exists
	static exists = function() {
		for (var i = dim-1; i >= 0; --i) {
			if (!variable_global_exists(names[i])) return false;
		}
		return true;
	};
	
	///@func get()
	///@self GlobalVecSelector
	///@return {Array<Any>}
	///@desc Return the target's value
	static get = function() {
		var v = array_create(dim);
		for (var i = dim-1; i >= 0; --i) {
			v[i] = variable_global_get(names[i]);
		}
		return v;
	};
	
	///@func set(val)
	///@self GlobalVecSelector
	///@param {Array} val The values to set to
	///@return {Struct.GlobalVecSelector}
	///@desc Set the target's value and return self
	static set = function(val) {
		for (var i = dim-1; i >= 0; --i) {
			variable_global_set(names[i], val[i]);
		}
		///Feather disable GM1045
		return self;
		///Feather enable GM1045
	};
}

///@func GlobalVec(names)
///@param {Array<String>} names The variables' names
///@return {Struct.GlobalVecSelector}
///@pure
///@desc Return a GlobalVecSelector targeting the named global variables
function GlobalVec(names) {
	gml_pragma("forceinline");
	return new GlobalVecSelector(names);
}

///@class InstanceVarSelector(name, inst)
///@param {string} name The variable's name
///@param {Id.Instance} inst The instance ID of the variable's owner
///@desc Selector for an instance variable
function InstanceVarSelector(name, inst) : GMTwerkSelector() constructor {
	self.name = name;
	self.inst = inst;
	
	///@func exists()
	///@self InstanceVarSelector
	///@return {Bool}
	///@desc Return whether the target exists
	static exists = function() {
		return instance_exists(inst) && variable_instance_exists(inst, name);
	};
	
	///@func get()
	///@self InstanceVarSelector
	///@return {Any}
	///@desc Return the target's value
	static get = function() {
		return variable_instance_get(inst, name);
	};
	
	///@func set(val)
	///@self InstanceVarSelector
	///@param {Any} val The value to set to
	///@return {Struct.InstanceVarSelector}
	///@desc Set the target's value and return self
	static set = function(val) {
		variable_instance_set(inst, name, val);
		///Feather disable GM1045
		return self;
		///Feather enable GM1045
	};
}

///@func InstanceVar(name, [inst])
///@param {string} name The variable's name
///@param {Id.Instance} [inst] (Optional) The instance ID of the variable's owner (default: current instance ID)
///@return {Struct.InstanceVarSelector}
///@pure
///@desc Return an InstanceVarSelector targeting the named instance variable
function InstanceVar(name, inst=id) {
	gml_pragma("forceinline");
	return new InstanceVarSelector(name, inst);
}

///@class InstanceVecSelector(names, inst)
///@param {Array<String>} names Array of variable names
///@param {Id.Instance} inst The instance ID of the variable's owner
///@desc Selector for multiple instance variables
function InstanceVecSelector(names, inst) : GMTwerkSelector() constructor {
	self.names = names;
	dim = array_length(names);
	self.inst = inst;
	
	///@func exists()
	///@self InstanceVecSelector
	///@return {Bool}
	///@desc Return whether the target exists
	static exists = function() {
		for (var i = dim-1; i >= 0; --i) {
			if (!variable_instance_exists(inst, names[i])) return false;
		}
		return true;
	};
	
	///@func get()
	///@self InstanceVecSelector
	///@return {Array<Any>}
	///@desc Return the target's value
	static get = function() {
		var v = array_create(dim);
		for (var i = dim-1; i >= 0; --i) {
			v[i] = variable_instance_get(inst, names[i]);
		}
		return v;
	};
	
	///@func set(val)
	///@self InstanceVecSelector
	///@param {Array} val The values to set to
	///@return {Struct.InstanceVecSelector}
	///@desc Set the target's value and return self
	static set = function(val) {
		for (var i = dim-1; i >= 0; --i) {
			variable_instance_set(inst, names[i], val[i]);
		}
		///Feather disable GM1045
		return self;
		///Feather enable GM1045
	};
}

///@func InstanceVec(names, [inst])
///@param {Array<String>} names The variables' names
///@param {Id.Instance} [inst] (Optional) The instance ID of the variable's owner (default: current instance ID)
///@return {Struct.InstanceVecSelector}
///@pure
///@desc Return a InstanceVecSelector targeting the named instance variables
function InstanceVec(names, inst=id) {
	gml_pragma("forceinline");
	return new InstanceVecSelector(names, inst);
}

///@class StructVarSelector(name, strc)
///@param {string} name The targeted struct key
///@param {struct} strc The target struct
///@desc Selector for a value in a struct
function StructVarSelector(name, strc) constructor {
	self.name = name;
	self.strc = strc;
	
	///@func exists()
	///@self StructVarSelector
	///@return {Bool}
	///@desc Return whether the target exists
	static exists = function() {
		return is_struct(strc) && variable_struct_exists(strc, name);
	};
	
	///@func get()
	///@self StructVarSelector
	///@return {Any}
	///@desc Return the target's value
	static get = function() {
		return variable_struct_get(strc, name);
	};
	
	///@func set(val)
	///@self StructVarSelector
	///@param {Any} val The value to set to
	///@return {Struct.StructVarSelector}
	///@desc Set the target's value and return self
	static set = function(val) {
		variable_struct_set(strc, name, val);
		///Feather disable GM1045
		return self;
		///Feather enable GM1045
	};
}

///@func StructVar(name, strc)
///@param {string} name The targeted struct key
///@param {struct} strc The target struct
///@return {Struct.StructVarSelector}
///@pure
///@desc Return an StructVarSelector targeting the named struct variable
function StructVar(name, strc) {
	gml_pragma("forceinline");
	return new StructVarSelector(name, strc);
}

///@class StructVecSelector(name, strc)
///@param {Array<String>} names The targeted struct keys
///@param {struct} strc The target struct
///@desc Selector for several values in a struct
function StructVecSelector(names, strc) constructor {
	self.names = names;
	dim = array_length(names);
	self.strc = strc;
	
	///@func exists()
	///@self StructVecSelector
	///@return {Bool}
	///@desc Return whether the target exists
	static exists = function() {
		if (!is_struct(strc)) return false;
		for (var i = dim-1; i >= 0; --i) {
			if (!variable_struct_exists(strc, names[i])) return false;
		}
		return true;
	};
	
	///@func get()
	///@self StructVecSelector
	///@return {Array<Any>}
	///@desc Return the target's value
	static get = function() {
		var v = array_create(dim);
		for (var i = dim-1; i >= 0; --i) {
			v[i] = variable_struct_get(strc, names[i]);
		}
		return v;
	};
	
	///@func set(val)
	///@self StructVecSelector
	///@param {Array} val The values to set to
	///@return {Struct.StructVecSelector}
	///@desc Set the target's value and return self
	static set = function(val) {
		for (var i = dim-1; i >= 0; --i) {
			variable_struct_set(strc, names[i], val[i]);
		}
		///Feather disable GM1045
		return self;
		///Feather enable GM1045
	};
}

///@func StructVec(names, strc)
///@param {Array<String>} names The targeted struct keys
///@param {struct} strc The target struct
///@return {Struct.StructVecSelector}
///@pure
///@desc Return an StructVecSelector targeting the named struct variables
function StructVec(names, strc) {
	gml_pragma("forceinline");
	return new StructVecSelector(names, strc);
}

///@class ArrayVarSelector(index, array)
///@param {Real} index The targeted position in the array
///@param {array} array The targeted array
///@desc Selector for a value in an array
function ArrayVarSelector(index, array) constructor {
	self.index = index;
	self.array = array;
	
	///@func exists()
	///@self ArrayVarSelector
	///@return {Bool}
	///@desc Return whether the target exists
	static exists = function() {
		return is_array(array) && array_length(array) > index;
	};
	
	///@func get()
	///@self ArrayVarSelector
	///@return {Any}
	///@desc Return the target's value
	static get = function() {
		return array[index];
	};
	
	///@func set()
	///@self ArrayVarSelector
	///@param {Any} val The value to set to
	///@return {Struct.ArrayVarSelector}
	///@desc Set the target's value and return self
	static set = function(val) {
		array[@index] = val;
		///Feather disable GM1045
		return self;
		///Feather enable GM1045
	};
}

///@func ArrayVar(index, array)
///@param {Real} index The targeted position in the array
///@param {array} array The targeted array
///@return {Struct.ArrayVarSelector}
///@pure
///@desc Return an ArrayVarSelector targeting the position in the given array
function ArrayVar(index, array) {
	gml_pragma("forceinline");
	return new ArrayVarSelector(index, array);
}

///@class DataUnitSelector(data)
///@param {Any} data The starting data value
///@desc Selector for a placeholder value
function DataUnitSelector(data) : GMTwerkSelector() constructor {
	self.data = data;
	
	///@func exists()
	///@self DataUnitSelector
	///@return {Bool}
	///@desc Return whether the target exists
	static exists = function() {
		return true;
	};
	
	///@func get()
	///@self DataUnitSelector
	///@return {Any}
	///@desc Return the target's value
	static get = function() {
		return data;
	};
	
	///@func set(val)
	///@self DataUnitSelector
	///@param {Any} val The value to set to
	///@return {Struct.DataUnitSelector}
	///@desc Set the target's value and return self
	static set = function(val) {
		data = val;
		///Feather disable GM1045
		return self;
		///Feather enable GM1045
	};
}

///@func DataUnit(data)
///@param data The starting data value
///@return {Struct.DataUnitSelector}
///@pure
///@desc Return a DataUnitSelector for a placeholder value
function DataUnit(data) {
	gml_pragma("forceinline");
	return new DataUnitSelector(data);
}
