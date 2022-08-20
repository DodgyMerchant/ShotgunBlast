/// @desc 



event_inherited();






var _trans_action_active; //if transition mode is active | if the player can perform mode specific actions

#region lever


if keyboard_check(vk_shift)
	prog_sys_interact(lever_prog,1);//add

//fully pressing the lever removes the trans first notch to let it fall down automatically
//fully pressed
if prog_sys_watch_trigger(lever_prog) == 0
	{
	//remove notch
	prog_sys_remove_from_list(trans_prog,PROG_GRID_INDEX.notch_list,1);
	}
//if trans notch list not 2
else if prog_sys_list_size(trans_prog,PROG_GRID_INDEX.notch_list)!=2 and prog_sys_get_t(lever_prog) != 1 //if not fully pushed
	{
	prog_sys_add_to_list(trans_prog,PROG_GRID_INDEX.notch_list,prog_sys_get_max(trans_prog));//aadd notch back
	}

//display
if instance_exists(obj_seq_lever)
	Func_weapon_lever_xscale( lerp(lever_size_rest,lever_size_push,prog_sys_get_t(lever_prog)) );


#endregion
#region breach


if keyboard_check(vk_enter)
	{
	prog_sys_interact(trans_prog,trans_progress,keyboard_check_pressed(vk_enter));//add
	
	Func_weapon_movement_hold(seq_weap_boa_move_close,3,keyboard_check(vk_enter));
	/*
	var _prog = prog_sys_get_progress(trans_prog);
	var _t = prog_sys_get_t(trans_prog);
	var _ti = Func_t_invert(prog_sys_get_t(trans_prog));
	show_debug_message("enter - prog: "+string(_prog)+"| t: "+string(_t)+"| ti: "+string(_ti))
	//*/
	}

//display
if instance_exists(obj_seq_boa_front)  //if is WIP
	{
	obj_seq_boa_front.func_seq_front_set_t(Func_t_invert(prog_sys_get_t(trans_prog)));
	}

if prog_sys_watch_trigger(trans_prog) == 0
	{
	//shock from open
	Func_weapon_movement_create(seq_weap_boa_move_open,2,true);
	}

#endregion

//get action mode active
_trans_action_active = (prog_sys_get_t(trans_prog) != 1 and !prog_sys_get_active(trans_prog));


#region trans mode actions


if _trans_action_active
	{
	//prog below notch | notch for reload progress
	if prog_sys_get_progress(transmode_shell_reload_prog) < prog_sys_get_list_value(transmode_shell_reload_prog,PROG_GRID_INDEX.notch_list,0)
		{
		//down to get shell
		if keyboard_check(vk_down)
			prog_sys_interact(transmode_shell_reload_prog,1,0);
		
		//update positions
		func_reload_shell_value_update_rest();
		}
	//if progress is at or exceeds first notch	and	 trans mode max
	else if prog_sys_is_min(trans_prog)
		{//reload shell
		
		//update positions
		func_reload_set_shell_values();
		func_reload_shell_value_update_dest();
		
		if reload_chamber_index != -1 //if there is a chamber to reload
			if keyboard_check(vk_up)
				{
				//move shell further
				prog_sys_interact(transmode_shell_reload_prog,1,keyboard_check_pressed(vk_up));
				}
		}
	
	//if max //shell in chamber
	if prog_sys_is_max(transmode_shell_reload_prog)
		{
		if keyboard_check(vk_up) //press in
			Func_weapon_movement_hold(seq_weap_boa_move_reload,5,true);
		else //let go of key
			func_reload_success();
		}
	
	
	
	}
else//if trans action mode diabled
	{
	//shell fall down
	Func_reload_cancelled();
	}

#endregion


#region test
/*
if keyboard_check(vk_space)
	prog_sys_interact(test_prog,1,keyboard_check_pressed(vk_space));


front_rot = lerp(prog_sys_get_progress(test_prog)/100,front_rot_min,front_rot_max);
//*/



/*
//sequence
if keyboard_check_pressed(vk_space)
	{
	//layer_sequence_
	//weapon_sequence
	
	
	//Func_sequence_start_beginning(weapon_sequence);
	
	//set chamber random
	chamber_grid[# WEAPON_CHAMBER_INDEX.status, 0] = irandom_range(WEAPON_CHAMBER_TYPE.loaded,WEAPON_CHAMBER_TYPE.empty);
	chamber_grid[# WEAPON_CHAMBER_INDEX.status, 1] = irandom_range(WEAPON_CHAMBER_TYPE.loaded,WEAPON_CHAMBER_TYPE.empty);
	//chamber_grid[# WEAPON_CHAMBER_INDEX.status, 0] = WEAPON_CHAMBER_TYPE.used;
	//chamber_grid[# WEAPON_CHAMBER_INDEX.status, 1] = WEAPON_CHAMBER_TYPE.empty;
	
	show_debug_message("chamber: "+string(chamber_grid[# WEAPON_CHAMBER_INDEX.status, 0])+"|"+string(chamber_grid[# WEAPON_CHAMBER_INDEX.status, 1]))
	
	layer_sequence_destroy(weapon_sequence);
	weapon_sequence = layer_sequence_create(global.Weapon_seq_layer,weap_disp_x,weap_disp_y,seq_weap_boa_open);
	
	
	part_particles_clear(global.ps);
	
	}
//*/





#endregion