
#region enums
enum PROG_GRID_INDEX
	{
	progress,			//val	| given	| value of progress
	control,			//val	|		| 
	activity,
	maxx,				//val	| given	| 
	notch_list,			//list	| given	| if the value sticks to max
	notch_catch,		//bool	| given	| if the value passing by the notch gets caught, player needs to re input to continue the value
	direction_change,	//bool	| given	| if the direction changes at the end
	directionn,			//enum	|		| PROG_DIRECTION
	fall_type,			//enum	| given	| PROG_FALL_TYPE
	fall_val,			//val	| given	| how much the fall is
	trigger_list,		//list	| given	| list with progressions that trigger an impuls
	Width,
	}
/*
PROG_GRID_INDEX.progress
PROG_GRID_INDEX.control
PROG_GRID_INDEX.activity
PROG_GRID_INDEX.maxx
PROG_GRID_INDEX.notch_list
PROG_GRID_INDEX.notch_catch
PROG_GRID_INDEX.direction_change
PROG_GRID_INDEX.directionn
PROG_GRID_INDEX.fall_type
PROG_GRID_INDEX.fall_val
PROG_GRID_INDEX.trigger_list
PROG_GRID_INDEX.Width
*/
enum PROG_FALL_TYPE//how the value behaves when not interacted this frame
	{
	no,		//no falling
	down,	//falls down
	up,		//falls up
	dirDown,//falls down, against the current direction
	dirUp,	//falls down, against the current direction
	nearest	//falls to the nearest notch
	}
enum PROG_DIRECTION
	{
	up = 1,
	down = -1
	}

#endregion

prog_grid = ds_grid_create(PROG_GRID_INDEX.Width,1);
Func_DHP_grid_set_empty(prog_grid);//mark as empty

#region Struct maybe
/*

PROG_GRID_INDEX.progress,			//val	| given	| value of progress/counter
PROG_GRID_INDEX.control,			//val	|		| control value
PROG_GRID_INDEX.activity,			//bool	|		| boolean if activity happened
PROG_GRID_INDEX.maxx,				//val	| given	| maximum value
PROG_GRID_INDEX.notch_list,			//list	| given	| list of notch values
PROG_GRID_INDEX.notch_catch,		//bool	| given	| if the value passing by the notch gets caught, player needs to re input to continue the value
PROG_GRID_INDEX.direction_change,	//bool	| given	| if the direction changes at the end
PROG_GRID_INDEX.directionn,			//enum	|		| the direction of the progress
PROG_GRID_INDEX.fall_type,			//enum	| given	| the type of fall value application
PROG_GRID_INDEX.fall_val,			//val	| given	| fall value applied each non active frame
PROG_GRID_INDEX.trigger_list,		//list	| given	| list with values that trigger an impuls if progress passes the value


buffer_create(,buffer_fixed,)

buffer_fill()

buffer_write()
buffer_poke()


buffer_seek(buffer, base, offset);	buffer_seek_
buffer_read()
buffer_peek()


buffer_delete()





function prog_entrie() constructor
	{
	
	
	
	
	
	
	}
*/
#endregion


///////////////usables///////////////

//create
prog_sys_create = function(_start_val,_max,_notch_list,_notch_catch,_dir_change,_fall_type,_fall_val,_trigger_list)	//creates an entry in the progress system | returns progress system index
	{
	/*
	_start_val		=	//val	| starting value	!!does get affected bye
	_max			=	//val	| maximum value to add up to
	_notch_list		=	//list	| a list of values representing the notches
	_notch_catch	=	//bool	| if the value passing by the notch gets caught, player needs to re input to continue the value
	_dir_change		=	//bool	| if the direction changes at the end
	_fall_type		=	//enum	| no, down, up, dirDown, dirUp, nearest
	_trigger_list	=	//list	| list with progressions that trigger an impuls // 0 - max
	
	!!! make sure that the notch and trigger list entries ramp up in value from lowest to highest!!!
	all lists can be replaced with -1 if not used
	*/
	
	var _h = Func_DHP_grid_expand_one(prog_grid,false);
	
	prog_grid[# PROG_GRID_INDEX.progress, _h]			=	_start_val;
	prog_grid[# PROG_GRID_INDEX.control, _h]			=	0;
	prog_grid[# PROG_GRID_INDEX.maxx, _h]				=	_max;
	prog_grid[# PROG_GRID_INDEX.notch_list, _h]			=	_notch_list;
	prog_grid[# PROG_GRID_INDEX.notch_catch, _h]		=	_notch_catch;
	prog_grid[# PROG_GRID_INDEX.direction_change, _h]	=	_dir_change;
	prog_grid[# PROG_GRID_INDEX.directionn, _h]			=	PROG_DIRECTION.up;
	prog_grid[# PROG_GRID_INDEX.fall_type, _h]			=	_fall_type
	prog_grid[# PROG_GRID_INDEX.fall_val, _h]			=	_fall_val
	prog_grid[# PROG_GRID_INDEX.trigger_list, _h]		=	_trigger_list;
	
	
	return _h;
	}

//set
prog_sys_set_val = function(_prog_index,_val,_activity)	// sets the progress to a value
	{
	prog_grid[# PROG_GRID_INDEX.progress, _prog_index] = _val;
	
	if _activity
		prog_grid[# PROG_GRID_INDEX.activity,_prog_index] = true;
	}

prog_sys_set_max = function(_prog_index,_activity)	// forces a prog position  for controller trigger
	{
	prog_grid[# PROG_GRID_INDEX.progress, _prog_index] = prog_grid[# PROG_GRID_INDEX.maxx, _prog_index];
	
	if _activity
		prog_grid[# PROG_GRID_INDEX.activity,_prog_index] = true;
	}

prog_sys_interact = function(_prog_index,_val,_opt_input_fresh)	// add a value to progress
	{
	/*
	_prog_index			= height index of the progress grid
	_val				= value to add
	_opt_input_fresh	= optional!		if the input is fresh | only used when the notch catch is enabled
	*/
	var _direction = prog_grid[# PROG_GRID_INDEX.directionn, _prog_index];
	//if _direction_affect
		_val = _val * _direction;	//direction affect value
	var _prog = prog_grid[# PROG_GRID_INDEX.progress, _prog_index];
	var _max = prog_grid[# PROG_GRID_INDEX.maxx, _prog_index];
	var _min = 0;
	
	#region notch catching
	
	if prog_grid[# PROG_GRID_INDEX.notch_catch, _prog_index]
		{
		var _notch = prog_sys_get_notch_nearest(_prog_index,false);
		
		if _notch != -1
		if _prog == _notch and !_opt_input_fresh //if in notch and no fresh input
			{
			return;
			}
		else
			{
			//set min or max
			if _prog < _notch and _notch <= (_prog + _val)
				_max = _notch;
			if (_prog + _val) <= _notch and _notch < _prog
				_min = _notch;
			}
		}
	#endregion
	
	//add value clamped
	_prog = clamp(_prog + _val, _min, _max);
	prog_grid[# PROG_GRID_INDEX.progress, _prog_index] = _prog;
	
	//set activity
	prog_grid[# PROG_GRID_INDEX.activity,_prog_index] = true;
	
	//update direction
	prog_sys_update_direction(_prog_index,_prog,_direction,prog_grid[# PROG_GRID_INDEX.maxx, _prog_index]);
	}

prog_sys_interact_force = function(_prog_index,_t)	// forces a prog position  for controller trigger
	{
	prog_grid[# PROG_GRID_INDEX.progress, _prog_index] = lerp(0,prog_grid[# PROG_GRID_INDEX.maxx, _prog_index],_t);
	
	prog_grid[# PROG_GRID_INDEX.activity,_prog_index] = true;
	
	}

//get
prog_sys_get_progress = function(_prog_index)	//returns the progress
	{
	return prog_grid[# PROG_GRID_INDEX.progress, _prog_index];
	}

prog_sys_get_max = function(_prog_index)	//returns the progress
	{
	return prog_grid[# PROG_GRID_INDEX.maxx, _prog_index];
	}

prog_sys_get_fall_val = function(_prog_index)	//returns the progress
	{
	return prog_grid[# PROG_GRID_INDEX.fall_val, _prog_index];
	}

prog_sys_get_t = function(_prog_index)	//returns the progress as t
	{
	return prog_grid[# PROG_GRID_INDEX.progress, _prog_index] / prog_grid[# PROG_GRID_INDEX.maxx, _prog_index];
	}

prog_sys_get_direction = function(_prog_index)	//returns the direction
	{
	return prog_grid[# PROG_GRID_INDEX.directionn, _prog_index];
	}

prog_sys_get_active = function(_prog_index)	//returns the direction
	{
	return prog_grid[# PROG_GRID_INDEX.activity, _prog_index];
	}

prog_sys_get_notch_nearest = function(_prog_index,_index_or_val) //returns the index or val of the nearest notch
	{
	var _notch_list	= prog_grid[# PROG_GRID_INDEX.notch_list, _prog_index];
	if !prog_sys_list_used(_notch_list)
		return -1;
	var _prog			= prog_grid[# PROG_GRID_INDEX.progress, _prog_index];
	var _notch_size = ds_list_size(_notch_list);
	
	var _val,_closest_val,_dist,_closest;			
	//get the closest notch index
	for(var i=0;i<_notch_size;i++)
		{
		_val = _notch_list[| i];
		_dist = abs(_val - _prog);
		
		if i==0 or _dist < _closest
			{//update
			_closest = _dist;
			_closest_val = _val;
			}
		else
			break;
		}
	
	//return index or value
	if _index_or_val
		return i-1;
	else
		return _closest_val;
	}

prog_sys_watch_trigger = function(_prog_index) // if the progress passed a value in the trigger list  this frame | return index or -1
	{
	return prog_sys_watch_list(_prog_index,PROG_GRID_INDEX.trigger_list);
	}

//is
prog_sys_is_max = function(_prog_index) // return true if the progress is at maximum position
	{
	return prog_grid[# PROG_GRID_INDEX.progress, _prog_index] == prog_grid[# PROG_GRID_INDEX.maxx, _prog_index];
	}

prog_sys_is_min = function(_prog_index) // return true if the progress is at minimum position
	{
	return prog_grid[# PROG_GRID_INDEX.progress, _prog_index] == 0;
	}

//////lists
//get
prog_sys_get_list_value = function(_prog_index,_grid_index_to_list,_list_index)	//gets value from a list
	{
	
	return prog_grid[# _grid_index_to_list,_prog_index][| _list_index];
	
	}
//set
prog_sys_set_list_value = function(_prog_index,_grid_index_to_list,_list_index)	//sets value in a list		WIP
	{
	/*/////////////////////////////////////////////////////////////
	//															///
	// !!!the values in any list have do be in acending order!!!///
	//															///
	*//////////////////////////////////////////////////////////////
	//prog_grid[# _grid_index_to_list,_prog_index][| _list_index];
	
	}

//other
prog_sys_add_to_list = function(_prog_index,_grid_index_to_list,_val)
	{
	ds_list_add(prog_grid[# _grid_index_to_list,_prog_index],_val);
	}

prog_sys_instert_into_list = function(_prog_index,_grid_index_to_list,_pos,_val)
	{
	ds_list_insert(prog_grid[# _grid_index_to_list,_prog_index],_pos,_val)
	}

prog_sys_remove_from_list = function(_prog_index,_grid_index_to_list,_index)
	{
	ds_list_delete(prog_grid[# _grid_index_to_list,_prog_index],_index);
	}

prog_sys_delete_all_in_list = function(_prog_index,_grid_index_to_list)
	{
	ds_list_clear(prog_grid[# _grid_index_to_list,_prog_index])
	}

prog_sys_list_notempty = function(_prog_index,_grid_index_to_list)	//1 = notempty | 0 = empty | -1 = non existant
	{
	var _list = prog_grid[# _grid_index_to_list,_prog_index]
	
	if ds_exists(_list,ds_type_list)
		if ds_list_empty(_list)
			return 0;
		else
			return 1;
	
	return -1;
	}

prog_sys_list_size = function(_prog_index,_grid_index_to_list)	//1 = notempty | 0 = empty | -1 = non existant
	{
	var _list = prog_grid[# _grid_index_to_list,_prog_index]
	
	if ds_exists(_list,ds_type_list)
		return ds_list_size(_list);
	
	return -1;
	}

//other
prog_sys_cleanup = function() //destroys all data structures
	{
	//destroy all held lists
	var _list;
	var _height = ds_grid_height(prog_grid);
	for(var i=0;i<_height;i++)
		{
		_list = prog_grid[# PROG_GRID_INDEX.notch_list, i];
		if ds_exists(_list, ds_type_list)
			ds_list_destroy(_list);
		_list = prog_grid[# PROG_GRID_INDEX.trigger_list, i];
		if ds_exists(_list, ds_type_list)
			ds_list_destroy(_list);
		}
	
	//destroy grid
	ds_grid_destroy(prog_grid);
	}

///////////////not usables///////////////
prog_sys_cycle = function()	//all parts move
	{
	/*
	Recent notable changes:		changed that the falling motion doenst change control to the same value
								active already take the place of distingushing if the value is being moved activly
	*/
	/*
	PROG_GRID_INDEX.progress
	PROG_GRID_INDEX.control
	PROG_GRID_INDEX.maxx
	PROG_GRID_INDEX.notch_list
	PROG_GRID_INDEX.notch_catch
	PROG_GRID_INDEX.direction_change
	PROG_GRID_INDEX.directionn
	PROG_GRID_INDEX.fall_type
	PROG_GRID_INDEX.trigger_list
	PROG_GRID_INDEX.Width
	
	PROG_FALL_TYPE.no
	PROG_FALL_TYPE.down
	PROG_FALL_TYPE.up
	PROG_FALL_TYPE.dirDown
	PROG_FALL_TYPE.dirUp
	PROG_FALL_TYPE.nearest
	*/
	var _prog,/*_control,*/_max,_min,_notch_list,_fall_type,_fall_val,_direction,_fall_dir,_notch_near;
	var _height = ds_grid_height(prog_grid);
	for (var i=0;i<_height;i++)//go through
		{
		//et first val
		_prog				= prog_grid[# PROG_GRID_INDEX.progress,			i];
		//_control			= prog_grid[# PROG_GRID_INDEX.control,			i];
		_fall_type			= prog_grid[# PROG_GRID_INDEX.fall_type,		i];	//PROG_FALL_TYPE
		
		
		
		///////RECENT CHANGE update control/////////////////
		prog_grid[# PROG_GRID_INDEX.control, i]	= _prog;
		////////////////////////////////////////////////////
		
		
		
		_notch_near = prog_sys_get_notch_nearest(i,false);
		
		//if there is fall and not moved		and progress not in a notch
		if _fall_type != PROG_FALL_TYPE.no and !prog_grid[# PROG_GRID_INDEX.activity,i] and _prog != _notch_near
			{
			//do stuff
			_max				= prog_grid[# PROG_GRID_INDEX.maxx,				i];
			_min				= 0;
			_notch_list			= prog_grid[# PROG_GRID_INDEX.notch_list,		i];
			//_notch_catch		= prog_grid[# PROG_GRID_INDEX.notch_catch,		i];
			//_direction_change	= prog_grid[# PROG_GRID_INDEX.direction_change,	i];	
			_direction			= prog_grid[# PROG_GRID_INDEX.directionn,		i];	//PROG_DIRECTION
			_fall_type			= prog_grid[# PROG_GRID_INDEX.fall_type,		i];	//PROG_FALL_TYPE
			_fall_val			= prog_grid[# PROG_GRID_INDEX.fall_val,		i];	//PROG_FALL_TYPE
			
			#region //get effective direction || _fall_dir
			switch(_fall_type)
				{
				#region direction
				case PROG_FALL_TYPE.down :
					_fall_dir = PROG_DIRECTION.down;
				break;
				case PROG_FALL_TYPE.up :
					_fall_dir = PROG_DIRECTION.up;
				break;
				#endregion
				#region relative direction
				case PROG_FALL_TYPE.dirDown:
					if _direction == PROG_DIRECTION.up
						_fall_dir = PROG_DIRECTION.down;
					else
						_fall_dir = PROG_DIRECTION.up;
				break;
				case PROG_FALL_TYPE.dirUp:
					if _direction == PROG_DIRECTION.up
						_fall_dir = PROG_DIRECTION.up;
					else
						_fall_dir = PROG_DIRECTION.down;
				break;
				#endregion
				#region other
				case PROG_FALL_TYPE.nearest: //get direction to nearest notch
					
					//set fall direction into notch direction
					_fall_dir = sign(_notch_near - _prog);
					
				break;
				#endregion
				}
			#endregion
			
			#region notch restrictions
			if _notch_near != -1
			if sign(_notch_near - _prog) == _direction
			if _direction
				_max = _notch_near;
			else
				_min = _notch_near;
			#endregion
			
			//apply fall
			_prog = clamp(_prog + (_fall_val*_fall_dir),_min,_max);
			
			//update direction
			prog_sys_update_direction(i,_prog,_direction,prog_grid[# PROG_GRID_INDEX.maxx,	i]);//must be fresh maxx
			
			//end update
			
			prog_grid[# PROG_GRID_INDEX.progress, i] = _prog;
			}
		
		//end
		//reset activity
		prog_grid[# PROG_GRID_INDEX.activity, i] = false;
		
		
		}
	}

prog_sys_list_used = function(_val)	
	{
	return _val != -1
	}

prog_sys_update_direction = function(_prog_index,_prog,_direction,_max) //updates direction
	{
	
	
	if prog_grid[# PROG_GRID_INDEX.direction_change, _prog_index] //if direction change
		{
		if _direction = PROG_DIRECTION.up//if direction up
			{
			if _prog == _max //if prog at the top
				prog_grid[# PROG_GRID_INDEX.directionn, _prog_index] = PROG_DIRECTION.down;//change direction to down
			}
		else if _prog == 0 //if not up (then it must be down) prog at the bottom?
			prog_grid[# PROG_GRID_INDEX.directionn, _prog_index] = PROG_DIRECTION.up;//change direction to up
		}
	}

prog_sys_watch_list = function(_prog_index,_grid_index_to_list) // if the progress passed a value in the given list this frame | return index or -1
	{
	/*
	returns the index out of the given list of values that the progress has passed or is equal to
	or -1 if nothing
	*/
	
	var _con = prog_grid[# PROG_GRID_INDEX.control, _prog_index];
	var _prog = prog_grid[# PROG_GRID_INDEX.progress, _prog_index];
	var _type = _con < _prog; //get value direction || NOT DIRECTIONN
	var _list = prog_grid[# _grid_index_to_list, _prog_index];
	
	//end early
	if _con == _prog
		return -1;
	
	var _val;
	var _size = ds_list_size(_list);
	for (var i=0;i<_size;i++)
		{
		//get val
		_val = _list[| i];
		
		//if val between control and progress
		switch(_type)
			{
			case true:
				if _con<_val and _val<=_prog	//if 
					{
					return i;
					}
			break;
			case false:
				if _prog<=_val and _val<_con	//if 
					{
					return i;
					}
			break;
			}
		}
	
	return -1;
	}




///////////////debug visualization///////////////////////
prog_sys_debug_draw = function(_y,_w,_h)
	{
	var _gui_w = display_get_gui_width();
	var _gui_h = display_get_gui_height();
	
	var _y1 = _y;
	var _sep = 3;
	var _x1 = _gui_w - _w;
	var _x2 = _gui_w - 2;
	
	
	var _y2, _max, _x;
	var _height = ds_grid_height(prog_grid);
	for (var i=0;i<_height;i++)
		{
		Func_draw_set_color(c_orange);
		_y2 = _y1 + _h;
		
		//get
		_max = prog_grid[# PROG_GRID_INDEX.maxx,i];
		
		
		//back 
		draw_line(_x1,_y1,_x2,_y1);
		//0
		draw_line(_x1,_y1,_x1,_y2);
		draw_text(_x1,_y1,"0");
		//max
		draw_line(_x2,_y1,_x2,_y2);
		draw_text(_x2,_y1,string(_max));
		//progress
		_x = lerp(_x1,_x2,prog_sys_get_t(i));
		draw_line(_x,_y1,_x,_y2);
		
		//draw lists
		var _draw_list = function(x1,x2,y1,y2,_max,_list)
			{
			if _list == -1
				return;
			var _x;
			var _size = ds_list_size(_list);
			for (var i=0;i<_size;i++)
				{
				_x = lerp(x1,x2,_list[| i] / _max);
				draw_line(_x,y1,_x,y2);
				}
			}
		
		Func_draw_set_color(c_blue);
		_draw_list(_x1,_x2,_y1,_y2-5,_max,prog_grid[# PROG_GRID_INDEX.notch_list,i]);
		Func_draw_set_color(c_red);
		_draw_list(_x1,_x2,_y1,_y2,_max,prog_grid[# PROG_GRID_INDEX.trigger_list,i]);
		
		//update next
		_y1 = _y2 + _sep;
		}
	
	}

/*	due to the index in the ds_grid being used a references  delting a entry isnt an option ATM
prog_sys_delete = function(_prog_index)//all parts move
	{
	
	
	
	
	
	
	}
*/
