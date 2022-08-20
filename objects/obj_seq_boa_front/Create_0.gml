/// @desc 

event_inherited();

//create or anchor sequence
Func_weapon_tracker_sequence_anchor(global.Weapon_seq_layer,seq_weap_boa_front); //to sequence_anchor


length = layer_sequence_get_length(sequence_anchor);
layer_sequence_pause(sequence_anchor);


//set alarm	//shell init
alarm[0] = 1;


func_seq_front_set_t = function(_t)
	{
	var _pos = layer_sequence_get_headpos(sequence_anchor);
	var _new = length * _t;
	
	//if progress is made
	if _new != _pos
		{
		//set dir
		layer_sequence_headdir(sequence_anchor,sign(_new - _pos));
		
		//set pos
		layer_sequence_headpos(sequence_anchor,_new);
		
		//if full opened
		if _t == 1
			Func_weapon_shell_eject_all();
		}
	}

