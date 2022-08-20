/// @desc 

// Inherit the parent event
event_inherited();


#region transmode

//reload
reload_chamber_index = -1; //index of the chamber to reload

func_reload_set_shell_values = function()	//set reload display values and chamber index | shotgun specific
	{
	//find index
	reload_chamber_index = Func_weapon_chamber_find(WEAPON_CHAMBER_TYPE.empty);
	
	if reload_chamber_index != -1
		{
		//get instansce and values
		var _inst = chamber_grid[# WEAPON_CHAMBER_INDEX.shell_id, reload_chamber_index];
		
		
		reload_dest_angle = _inst.image_angle;
		reload_dest_x = _inst.x;
		reload_dest_y = _inst.y;
		
		return 1;
		}
	else
		return -1;
	}





#endregion



weapon_sequence = layer_sequence_create(global.Weapon_seq_layer,weap_disp_x,weap_disp_y,seq_weap_boa_back);

