/// @desc 

Func_draw_set_font(fn_debug);
Func_draw_set_halign(fa_left);
Func_draw_set_color(c_orange);
var _gui_w = display_get_gui_width();
var _y = 20;


#region left
//*
_y = func_debug_txt(0,_y,
"debug_scroll "+string(global.Debug_scroll),
"inst num sp: "+string(instance_number(obj_seq_tracker_parent)),
"inst num sm: "+string(instance_number(obj_seq_movement)),
);

//*/
/*//weapon
var _obj = obj_weapon_parent;
with(_obj)
_y = func_debug_txt(0,_y,
"lever_size "+string(lever_size)
);

//*/
#endregion
#region right
Func_draw_set_halign(fa_right);

//*
var _y = 0;
with (obj_weapon_parent)
	_y = prog_sys_debug_draw(_y,200,20);

//*/

#endregion


