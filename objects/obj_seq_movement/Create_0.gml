/// @desc 

// Inherit the parent event
event_inherited();



//get data
var _name = sequence_instance.sequence.name;
seq_index = asset_get_index(_name);
show_debug_message("obj_seq_movement saved seq_index name: "+_name);

seq_id = Func_sequence_layer_find_element_id(global.Weapon_seq_layer, seq_index);

time_count = 0;

