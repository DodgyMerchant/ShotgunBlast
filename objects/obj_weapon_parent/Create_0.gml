/// @desc 


#region prog system

//initiate prog system
Prog_System();

#endregion
#region general variables
weapon_type = WEAPON_TYPE.nothing;

part_list = ds_list_create();

//standart all weapons should have this



#region general weapon position

weap_disp_x = 70;
weap_disp_y = global.Weapon_surface_h - 50;
weap_disp_rot = 0;


#endregion
#region general chamber

chamber_grid = 0; //gets reates in update

#endregion
#region general firemodes
enum FIREMODE_TYPE
	{
	safe,
	semi,
	burst,
	auto
	}
firemode_list = ds_list_create();
firemode = FIREMODE_TYPE.semi;
#endregion
#region general trigger
trigger_prog=0;	//progression system index
trigger_pull_force = 2;	//trigger pull value per frame of button pressed
trigger_pull_max=0;		//trigger pull maximum, when the bullet is fired	|set in weapon update

trigger_rot_rest = 0;	//resting position									|set in weapon update
trigger_rot_pull = 0;	//max angle											|set in weapon update

#endregion
#region general stats
recoil_control = 1;		//subtracted over time from the recoil to create inaccuracy

shot_recoil = 0;		//the effect of one shot on the accuracy, recoil	| set in weapon update
shot_firerate = 0;		//cooldown of shots in frames						| set in weapon update
shot_firerate_cool = 0;	//cooldown of shots in frames
shot_spread = 0;		//shot spread in angle								| set in weapon update

#endregion
#region general transform mode

trans_progress = 1;	//progress of transitioning between modes




#endregion
#region general reload
reload_type = -1;

reload_shell_x =0;
reload_shell_y =0;
reload_dest_x = 0; //destination position
reload_dest_y = 0;
reload_rest_x = weap_disp_x - 40; //secondary position   end pos of shell get
reload_rest_y = weap_disp_y + 20;

reload_angle = 0;
reload_dest_angle = 0;
reload_rest_angle = 40;

//scripts to be set
func_reload = -1; //sets the data for a reload

//reload
func_reload_shell_value_update_rest = function()	//updates reload display values to rest position | universal
	{
	var _t = prog_sys_get_progress(transmode_shell_reload_prog) / prog_sys_get_list_value(transmode_shell_reload_prog,PROG_GRID_INDEX.notch_list,0);
	var _startposx = -10;
	var _startposy = display_get_gui_height() + 10;
	
	//set values
	reload_shell_x = lerp(_startposx,reload_rest_x,_t);
	reload_shell_y = lerp(_startposy,reload_rest_y,_t);
	reload_angle = reload_rest_angle;
	}
func_reload_shell_value_update_dest = function()	//updates reload display values to destination position | universal
	{
	var _notch_val = prog_sys_get_list_value(transmode_shell_reload_prog,PROG_GRID_INDEX.notch_list,0);
	var _t = (prog_sys_get_progress(transmode_shell_reload_prog) - _notch_val) / (prog_sys_get_max(transmode_shell_reload_prog) - _notch_val);;
	
	//set values
	reload_shell_x = lerp(reload_rest_x,reload_dest_x,_t);
	reload_shell_y = lerp(reload_rest_y,reload_dest_y,_t);
	reload_angle = lerp(reload_rest_angle,reload_dest_angle,_t);
	}

func_reload_reset = function()	//end of reaload reset
	{
	//reset progress
	prog_sys_set_val(transmode_shell_reload_prog,0);
	
	
	
	
	}
func_reload_success = function()
	{
	show_debug_message("Reload Success");
	//use sript
	func_reload()
	
	func_reload_reset();
	}
Func_reload_cancelled = function()
	{
	if !prog_sys_is_min(transmode_shell_reload_prog)
		{
		
		show_debug_message("Reload Cancelled");
		Func_weapon_shell_eject_create(reload_shell_x,reload_shell_y,reload_angle,270,2,2);
		func_reload_reset();
		}
	}



#endregion

#endregion

func_fire = function()
	{
	var _index = Func_weapon_chamber_find(WEAPON_CHAMBER_TYPE.loaded);
	if _index != -1
		{
		show_debug_message("FIRE!");
		
		//set chamber grid to used
		Func_weapon_chamber_set(_index, WEAPON_CHAMBER_TYPE.used);
		
		//set movement
		Func_weapon_movement_create(seq_weap_boa_move_close,0,false);
		}
	
	
	}



#region sequence

weapon_sequence = undefined;

//where the movement position will be displayed offscreen
global.Weapon_seq_movement_pos_x = -200; 
global.Weapon_seq_movement_pos_y = -200;

func_weapon_apply_movement = function()
	{
	var _x = 0;
	var _y = 0;
	var _r = 0;
	
	//get all move instances data
	var _num = instance_number(obj_seq_movement);
	
	if _num > 0
		{
		for(var i=0;i<_num;i++)
			with(instance_find(obj_seq_movement,i))
				{
				_x += x - global.Weapon_seq_movement_pos_x;
				_y += y - global.Weapon_seq_movement_pos_y;
				_r += image_angle;
				}
		//show_debug_message("move pos set: "+string(_x)+"|"+string(_y)+"|"+string(_r));
		//position
		layer_sequence_x(weapon_sequence,weap_disp_x + _x);
		layer_sequence_y(weapon_sequence,weap_disp_y + _y);
		layer_sequence_angle(weapon_sequence,_r);
		}
	}




#endregion

#region test

/*

var _test_list = Func_DH_createfill_list(0,50,75);
test_prog = prog_sys_create(
0,						//_start_val
75,						//_max
_test_list,				//_notch_list
true,					//_notch_catch
true,					//_dir_change
PROG_FALL_TYPE.dirDown,	//_fall_type
1,						//_fall_val
_test_list				//_trigger_list
);


//*/




#endregion