




function Func_sequence_start_beginning(_sequence_element) //starts the sequence from the beginning
	{
	if layer_sequence_is_finished(_sequence_element)
		layer_sequence_play(_sequence_element);
	else
		layer_sequence_headpos(_sequence_element,0);
	}



#region sequence data functions

/*
a sequence obj f.e. seq_example

holds an object ID
to get the sequence struct use  sequence_get(_sequence)



*/


function Func_sequence_find_track(_sequence,_track_type,_track_name) //finds a track by name in a sequence object | returns struct ID of the track
	{
	//convert asset index to struct
	if !is_struct(_sequence)
		_sequence = sequence_get(_sequence);
	
	return Func_seq_arr_find_track(_sequence.tracks, _track_type, _track_name);
	
	}

function Func_sequence_track_find_track(_track_start,_track_type,_track_name) //finds a track by name in a sequence object | returns struct ID of the track
	{
	//convert asset index to struct
	
	return Func_seq_arr_find_track(_track_start.tracks, _track_type, _track_name);
	
	}

function Func_seq_arr_find_track(_track_arr,_track_type,_track_name) //finds a track by name in a track array | returns struct ID of the track
	{
	/*
	_track_arr	= array containing track structs
	_track_type	= type of track f.e. seqtracktype_graphic
	_track_name	= name of the track as a string
	
	
	*/
	
	var _size = array_length(_track_arr);
	var _sub_track_arr,_sub_search;
	
	//go through array
	for (var i = 0; i < _size; ++i)
		{
		with(_track_arr[i])
			{
			if type == _track_type and name == _track_name //if not track type
				{
				//return own id
				return _track_arr[i];
				}
			else
				{
				_sub_track_arr = tracks;
				
				if array_length(_sub_track_arr) > 0
					{
					_sub_search = Func_seq_arr_find_track(_sub_track_arr,_track_type,_track_name);
					
					if _sub_search != -1
						return _sub_search;
					}
				}
			}
		}
	
	//nothing found
	return -1;
	
	}

function Func_sequence_track_all_keyframe_replace_sprites(_track_struct,_spr) //
	{
	/*
	track must be of type  seqtracktype_graphic
	*/
	
	with(_track_struct)//switch to track struct
		{
		
		//keyframe array
		//go through all key frames
		var _key_arr_size = array_length(keyframes);
		for (var i = 0; i < _key_arr_size; ++i)
		with(keyframes[i])//switch to keyframe struct
			{
			//go through all channel structs
			var _keyframe_data_arr_size = array_length(channels);
			for (var ii = 0; ii < _keyframe_data_arr_size; ++ii)
				channels[ii].spriteIndex = _spr;
			}
		}
	
	}

function Func_sequence_track_all_keyframe_set_value(_track_struct,_val) //
	{
	/*
	track must be of type  seqtracktype_graphic
	*/
	
	with(_track_struct)//switch to track struct
		{
		
		//keyframe array
		//go through all key frames
		var _key_arr_size = array_length(keyframes);
		for (var i = 0; i < _key_arr_size; ++i)
		with(keyframes[i])//switch to keyframe struct
			{
			//go through all channel structs
			var _keyframe_data_arr_size = array_length(channels);
			for (var ii = 0; ii < _keyframe_data_arr_size; ++ii)
				{
				show_debug_message("//////VAL: "+string(channels[ii].value));
				channels[ii].value = _val;
				
				show_debug_message(string(channels[ii]));
				}
			}
		}
	
	}

function Func_sequence_instance_get_obj_struct(_seq_element_id) //give sequence element ID  and get sequence object
	{
	return layer_sequence_get_instance(_seq_element_id).sequence;
	}

function Func_sequence_instance_get_name(_seq_element_id) //give sequence element ID instance  and get sequence object name
	{
	return Func_sequence_instance_get_obj_struct(_seq_element_id).name;
	}

function Func_sequence_instance_get_object_index(_seq_element_id) //give sequence element ID instance  and get object index
	{
	return asset_get_index(Func_sequence_instance_get_name(_seq_element_id));
	}

function Func_sequence_layer_find_element_id(_layer,_object_index) //give layer and object index  get  element id
	{
	/*
	finds the first sequence of that index
	
	*/
	var _a = layer_get_all_elements(_layer);
	var _leng = array_length(_a);
	for (var i = 0; i < _leng; i++)
		{
		//if type sequence
		if layer_get_element_type(_a[i]) == layerelementtype_sequence
		//if index is same as searched for
		if Func_sequence_instance_get_object_index(_a[i]) == _object_index
		    {
			return _a[i];
		    }
		}
	
	//cleanup
	_a = -1;
	}

//may delete

function Func_sequence_track_keyframe_edit(_track_struct,_variable_name,_val) //DOESNT WORK   using struct variable function causes duplicate variables
	{
	/*
	track must be of type  seqtracktype_graphic
	*/
	//*
	
	with(_track_struct)//switch to track struct
		{
		
		//keyframe array
		//go through all key frames
		var _key_arr_size = array_length(keyframes);
		show_debug_message("keyframe num: "+string(_key_arr_size));
		for (var i = 0; i < _key_arr_size; ++i)
		with(keyframes[i])//switch to keyframe struct
			{
			//go through all channel structs
			var _keyframe_data_arr_size = array_length(channels);
			show_debug_message("keyframe data num: "+string(_keyframe_data_arr_size));
			for (var ii = 0; ii < _keyframe_data_arr_size; ++ii)
				if variable_struct_exists(channels[ii],_variable_name)
					{
					variable_struct_set(channels[ii],_variable_name,_val);
					//debug
					show_debug_message(string(channels[ii]));
					}
			}
		}
	//*/
	}

function Func_struct_show_vars(_struct)
	{
	
	var _arr = variable_struct_get_names(_struct);
						
	var _length_arr = array_length(_arr)
	if _length_arr > 0
		{
		for(var arr_i=0;arr_i<_length_arr;arr_i++)
			show_debug_message("///arr: "+_arr[arr_i])
		}
	else
		show_debug_message("//no variables")

	
	}

function Func_sequence_element_find_activetrack(_seq_element_id)	//for sequence instances
	{
	
	Func_activeTracks_find_activetrack(layer_sequence_get_instance(_seq_element_id));
	
	
	}

function Func_activeTracks_find_activetrack(_seq_struct)
	{
	//go into instance struct
	with(_seq_struct)
		{
		var _length = array_length(activeTracks)
		show_debug_message("len: "+string(_length));
		if _length > 0
			{
			//go through all activeTracks
			for(var i=0;i<_length;i++)
				{
				Func_activeTracks_find_activetrack(activeTracks[i]);
				}
			}
		else
			{
			//show_debug_message("mat: "+string(matrix));
			scalex = 1.3;
			}
		}
	}


#endregion