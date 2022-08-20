
#region weapon type and parts


enum WEAPON_TYPE
	{
	nothing,
	BreakOverUnder = obj_weapon_boa
	}
#region BOA
enum WEAP_BOA_Parts
	{
	Stock_Full	= spr_SG_BreakOverUnder_Back_Full,
	Stock_No	= spr_SG_BreakOverUnder_Back_NoStock,
	Front_Long	= spr_SG_BreakOverUnder_Front_Long,
	Front_Short	= spr_SG_BreakOverUnder_Front_Short,
	Front_Sawed	= spr_SG_BreakOverUnder_Front_Sawed,
	}
enum WEAP_BOA_Part_List_Index
	{
	Back,
	Front
	}
#endregion
enum WEAPON_CHAMBER_TYPE
	{
	empty,
	used,
	loaded
	}
enum WEAPON_CHAMBER_INDEX
	{
	status,
	shell_id
	}
enum WEAPON_RELOAD_TYPE
	{
	direct, //directly into the chamber
	tube,	//turbe mag reload
	mag		//magazine reload
	}

#endregion

//wepon update
function Func_weapon_update()
{
#region info
/*
//GENERAL///
//shooting
trigger_pull_max
shot_recoil
shot_firerate
shot_spread
shot_origin_dist	//barrel length different origins

//input
???


//disp
disp_shot_recoil_curve


///BreakOverUnder///
//data

//disp
spr_back
spr_front
front_offset_x
front_offset_y

front_rot
front_rot_max
front_rot_min





*/
#endregion

#region weapon spicific
var _list,_var,_time,_time_back;
//weapon type
switch(weapon_type)
	{
	#region BOA
	case WEAPON_TYPE.BreakOverUnder:
		
		chamber_grid = Func_weapon_chamber_grid_create(2,WEAPON_CHAMBER_TYPE.used);
		
		trigger_pull_max = 10;
		
		
		shot_recoil = 20;
		shot_firerate_cool = 200;
		shot_spread = 0;
		shot_origin_dist = 0;
		
		#region transform mode	//break open
		//trans mode
		_time = 0.5 * global.game_speed; //time it taskes to close the breack
		_time_back = _time / (0.25 * global.game_speed);
		
		trans_prog = prog_sys_create(
		_time,								//_start_val
		_time,								//_max
		Func_DH_createfill_list(0,_time),	//_notch_list
		true,								//_notch_catch
		false,								//_dir_change
		PROG_FALL_TYPE.down,				//_fall_type
		_time_back,							//_fall_val
		Func_DH_createfill_list(0)		//_trigger_list
		);
		
		#endregion
		#region back
		
		
		
		switch(part_list[| WEAP_BOA_Part_List_Index.Back])
			{
			case WEAP_BOA_Parts.Stock_Full:
				spr_back = spr_SG_BreakOverUnder_Back_Full;
			break;
			case WEAP_BOA_Parts.Stock_No:
				spr_back = spr_SG_BreakOverUnder_Back_NoStock;
			break;
			}
		#endregion
		#region front
		
		switch(part_list[| WEAP_BOA_Part_List_Index.Front])
			{
			case WEAP_BOA_Parts.Front_Long:
				spr_front = spr_SG_BreakOverUnder_Front_Long;
			break;
			case WEAP_BOA_Parts.Front_Short:
				spr_front = spr_SG_BreakOverUnder_Front_Short;
			break;
			case WEAP_BOA_Parts.Front_Sawed:
				spr_front = spr_SG_BreakOverUnder_Front_Sawed;
			break;
			}
		#endregion
		#region lever
		
		lever_size_rest = 1;
		lever_size_push = 0.7;
		
		//trans mode
		_time = 0.3 * global.game_speed;//time lever press talkes
		lever_prog = prog_sys_create(
		0,						//_start_val
		_time,					//_max
		-1,						//_notch_list
		false,					//_notch_catch
		false,					//_dir_change
		PROG_FALL_TYPE.down,	//_fall_type
		_time / 10,				//_fall_val
		Func_DH_createfill_list(_time)//_trigger_list
		);
		
		#endregion
		#region trigger
		
		trigger_rot_rest = 0;
		trigger_rot_pull = -10;
		
		//trigger
		trigger_prog = prog_sys_create(
		0,						//_start_val
		trigger_pull_max,		//_max
		-1,						//_notch_list
		false,					//_notch_catch
		false,					//_dir_change
		PROG_FALL_TYPE.down,	//_fall_type
		1,						//_fall_val
		Func_DH_createfill_list(trigger_pull_max*0.7) //_trigger_list
		);
		#endregion
		#region reload
		
		reload_type = WEAPON_RELOAD_TYPE.direct;
		
		#endregion
		
		
		
	break;
	#endregion
	}
#endregion
#region general
#region reload
//reload shell animation
//transotion mode action shell travel
var _reload_time = 0.5 * global.game_speed; //time to move shell to gun and push in
var _grab_time = 0.3 *global.game_speed; //time to grab shell from pocket
_time = _reload_time + _grab_time;
_list = Func_DH_createfill_list(_grab_time);

transmode_shell_reload_prog = prog_sys_create(
0,						//_start_val
_time,					//_max
_list,					//_notch_list
true,					//_notch_catch
false,					//_dir_change
PROG_FALL_TYPE.down,	//_fall_type
1,						//_fall_val
-1						//_trigger_list
);

func_reload = Func_weapon_update_reload();

#endregion


#endregion


//adapt sprites
Func_weapon_sequence_update()
}

function Func_weapon_sequence_update()
	{
	
	switch(weapon_type)
		{
		#region BOA
		case WEAPON_TYPE.BreakOverUnder:
			
			Func_weapon_sequence_change_sprite(seq_weap_boa_front,"Front",part_list[| WEAP_BOA_Part_List_Index.Front]);
			Func_weapon_sequence_change_sprite(seq_weap_boa_back,"Back",part_list[| WEAP_BOA_Part_List_Index.Back]);
			
			
		break;
		#endregion
		}
	
	
	}

function Func_weapon_update_reload()	//atm used to create the reload function
	{
	switch(reload_type)
		{
		case WEAPON_RELOAD_TYPE.direct:
			//seuccess function
			return function()
				{
				//reload_chamber_index
				chamber_grid[# WEAPON_CHAMBER_INDEX.status, reload_chamber_index] = WEAPON_CHAMBER_TYPE.loaded;
				chamber_grid[# WEAPON_CHAMBER_INDEX.shell_id, reload_chamber_index].func_shell_visible(true);
				
				}
		break;
		}
	}

function Func_weapon_player_equip(_type,_part_list)
	{
	
	if _type == WEAPON_TYPE.nothing
		return;
	
	//destroy weapon obj
	if instance_exists(obj_weapon_parent)
		with(obj_weapon_parent) {instance_destroy()}
	
	//create new instance
	var _inst = instance_create_layer(0,0,"Systems",_type);
	
	//update weapon
	with (_inst)
		{
		weapon_type = _type;
		ds_list_copy(part_list,_part_list);
		
		Func_weapon_update();
		}
	}

function Func_weapon_drop()
	{
	//weap_type = _type;
	//weap_part_list = _part_list;
	}

//chamber
function Func_weapon_chamber_grid_create(_number,_state) //creaates the data structure used for the gun chamber grid
	{
	var _grid = ds_grid_create(2,_number);
	
	//fill grid
	for(var i=0;i<_number;i++)
		{
		_grid[# WEAPON_CHAMBER_INDEX.status,i] = _state;
		_grid[# WEAPON_CHAMBER_INDEX.shell_id,i] = -1;
		}
	
	return _grid;
	}

function Func_weapon_chamber_find(_type) //finds the first chamber with this type and returns it  or -1
	{
	var _shell_id;
	var _height = ds_grid_height(chamber_grid);
	for(var i = 0;i<_height;i++)
		{
		//if chamber empty
		if chamber_grid[# WEAPON_CHAMBER_INDEX.status, i] == _type
			{
			//return index
			return i;
			}
		}
	
	return -1;
	}

//other
function Func_weapon_shell_eject_create(_x,_y,_angle,_dir,_spd_min,_spd_max)
	{
	with (instance_create_layer(_x,_y,"Particles",obj_shell_eject))
		{
		image_angle = _angle;
		dir_start = _dir;//(image_angle + 180) mod 360;
		spd_max = _spd_max;//7;
		spd_min = _spd_min;//2;
		
		}
	}

//part
function Func_weapon_shell_eject_particles(_dir) //creates particles used fo chamber shell ejection
	{
	/*
	global.pt_BreakOpen_Cylinder
	global.pt_BreakOpen_Traveler
	*/
	
	//edit paarticles
	part_type_direction(global.pt_BreakOpen_Traveler, _dir, _dir, 1, 0);
	
	//create
	part_particles_create(global.ps,x,y,global.pt_BreakOpen_Traveler,1);
	
	}

////////sequences/////////////
function Func_weapon_sequence_change_sprite(_sequence,_part_name,_spr)
	{
	/*
	sequence
	tracks or sub tracks
	keyframe
	channels
	
	spriteIndex
	
	
	only chack praphic type tracks for sprites
	type == seqtracktype_graphic
	*/
	
	
	
	//find part in gun
	
	var _track_struct = Func_sequence_find_track(_sequence, seqtracktype_graphic, _part_name);
	
	Func_sequence_track_all_keyframe_replace_sprites(_track_struct,_spr);
	
	
	
	
	
	}

//trackers general
function Func_weapon_tracker_sequence_anchor(_layer,_sequence_index)
	{
	if layer_has_instance(_layer,_sequence_index)
		{
		var _id = Func_sequence_layer_find_element_id(_layer,_sequence_index);
		show_debug_message("seq tracker anchor found: "+Func_sequence_instance_get_name(_id));
		sequence_anchor = _id;
		}
	else
		sequence_anchor = layer_sequence_create(_layer,x,y,_sequence_index);
	}

//shell
function Func_weapon_shell_init()
	{
	/*
	looks of the shells in the animation should exist
	and logs them in the grid if they do
	
	*/
	
	var _chamber_grid = obj_weapon_parent.chamber_grid;
	var _num = instance_number(obj_seq_shellChamber);
	var _arr = array_create(_num);
	
	show_debug_message("INIT shell num: "+string(_num));
	//fill array
	for (var i=0;i<_num;i++)
		{
		_arr[i] = instance_find(obj_seq_shellChamber,i);
		}
	
	//check instances
	for (var i=0;i<_num;i++)
	with(_arr[i])//go into shell
		{
		
		_chamber_grid[# WEAPON_CHAMBER_INDEX.shell_id,number] = id; //add self to grid | set id shell
		
		//if empty
		if _chamber_grid[# WEAPON_CHAMBER_INDEX.status,number] == WEAPON_CHAMBER_TYPE.empty
			{
			//dont display
			
			func_shell_visible(false);
			}
		}
	
	//destroy arr
	_arr = -1;
	}

function Func_weapon_shell_eject_all()
	{
	show_debug_message("eject?")
	with(obj_weapon_parent)
		{
		var _h = ds_grid_height(chamber_grid);
		for(var i=0;i<_h;i++)
			{
			//if chamber has used shells
			if chamber_grid[# WEAPON_CHAMBER_INDEX.status,i] == WEAPON_CHAMBER_TYPE.used
				{
				Func_weapon_shell_eject(i);
				}
			}
		}
	}

function Func_weapon_shell_eject(_index)
	{
	//call
	chamber_grid[# WEAPON_CHAMBER_INDEX.shell_id,_index].func_shell_eject();
	
	//chamber set empty
	Func_weapon_chamber_set(_index, WEAPON_CHAMBER_TYPE.empty);
	}

function Func_weapon_chamber_set(_index,_status)
	{
	chamber_grid[# WEAPON_CHAMBER_INDEX.status, _index] = _status;
	}

//trigger
function Func_weapon_trigger_rot(_val) //sets the rotation for the trigger instance
	{
	obj_seq_trigger.func_trigger_set_rot(_val);
	}

//lever
function Func_weapon_lever_xscale(_val) //sets the xscale for the lever instance
	{
	obj_seq_lever.func_lever_set_xscale(_val);
	}

//movements
#region info
/*
a system to chain sequence movement animations together

every movement sequence has an obj_seq_movement that is the effective applied position of that movement

adding all the objects offset together will result in a new position for the weapon animtion


*/
#endregion

function Func_weapon_movement_number(_seq_obj_index)
	{
	//go through all isntance and compare indexes
	var _count = 0;
	var _num = instance_number(obj_seq_movement);
	for(var i=0;i<_num;i++)
		with(instance_find(obj_seq_movement,i))
			{
			if seq_index == _seq_obj_index
				_count++;
			}
	
	return _count;
	
	}

function Func_weapon_movement_get_oldest(_seq_obj_index)
	{
	//go through all isntance and compare indexes and time
	var _oldest_val = 0;
	var _oldest_inst = -1;
	var _num = instance_number(obj_seq_movement);
	for(var i=0;i<_num;i++)
		with(instance_find(obj_seq_movement,i))
			{
			if seq_index == _seq_obj_index
			if _oldest_val < time_count
				{
				_oldest_val = time_count;
				_oldest_inst = id;
				}
			}
	
	return _oldest_inst.seq_id;
	}

function Func_weapon_movement_create(_seq_obj_index,_limit,_destroy)
	{
	/*
	_seq_obj_index	= sequence to create
	_limit	= limit the number of qequences of this type to exist. 0 no limit / number the limit
	_destroy = if the sequences that are oldest should be destroyed when there are too many | bool
	*/
	var _spawn = function(_seq_obj_index)
		{
		show_debug_message("move create");
		return layer_sequence_create(global.Weapon_seq_layer,
		global.Weapon_seq_movement_pos_x,
		global.Weapon_seq_movement_pos_y,
		_seq_obj_index);
		}
	
	if _limit =! 0
		{
		var _num = Func_weapon_movement_number(_seq_obj_index);
		//show_debug_message("Number of same movements: "+string(_num));
		if _num >= _limit
			{//more than limit 
			
			var _seq_id = Func_weapon_movement_get_oldest(_seq_obj_index);
			
			
			if _destroy //destroy
			
				{
				show_debug_message("///destroy sequence "+string(_seq_obj_index)+string(Func_sequence_instance_get_name(_seq_id))+"//////////////////////////////////////////////////////////////////");
				//destroy oldest
				layer_sequence_destroy(_seq_id);
				
				//spawn new
				return _spawn(_seq_obj_index);
				}
			else//dont destroy
				{
				show_debug_message("///dont destroy"+string(_seq_obj_index)+string(Func_sequence_instance_get_name(_seq_id)));
				//return oldest sequence
				return _seq_id;
				}
			}
		else
			{
			//spawn below limit
			return _spawn(_seq_obj_index);
			}
		}
	else//spwan no limit
		return _spawn(_seq_obj_index);
	
	}

function Func_weapon_movement_hold(_seq_obj_index,_hold_frame,_hold)
	{
	//creates or return oldest of index
	var _seq_id = Func_weapon_movement_create(_seq_obj_index,1,false);
	
	if _hold
		{
		var _seq_leng = layer_sequence_get_length(_seq_id);
		var _head_pos = layer_sequence_get_headpos(_seq_id)
		
		if _head_pos>=_hold_frame
			{
			var _val = _hold_frame - (_head_pos - _hold_frame) -1 ;
			layer_sequence_headpos(_seq_id, _val);
			
			show_debug_message(string(_val));
			
			}
		}
	}