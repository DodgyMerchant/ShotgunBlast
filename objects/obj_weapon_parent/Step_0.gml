/// @desc 


#region trigger


if mouse_check_button(mb_left)
	prog_sys_interact(trigger_prog,trigger_pull_force);//add

if prog_sys_watch_trigger(trigger_prog)!=-1 and prog_sys_get_active(trigger_prog)
	func_fire();


if instance_exists(obj_seq_trigger)
	Func_weapon_trigger_rot(lerp(trigger_rot_rest,trigger_rot_pull,prog_sys_get_t(trigger_prog)))



#endregion

#region test

















/*	//to check if sequence structure are still incompatable with sequence variable functions
//sequence
if keyboard_check_pressed(vk_space)
	{
	//layer_sequence_
	//weapon_sequence
	
	var _struct = Func_sequence_find_track(layer_sequence_get_sequence(weapon_sequence),seqtracktype_group,"Gun");
	_struct = Func_sequence_track_find_track(_struct,seqtracktype_real,"position");
	
	Func_sequence_track_keyframe_edit(_struct,"value",9999);
	
	
	}
//*/

#endregion





