/// @desc 

//var _gui_w = display_get_gui_width();
//var _gui_h = display_get_gui_height();



#region trans mode action


///reload display
if prog_sys_get_progress(transmode_shell_reload_prog) != 0
	{
	surface_set_target(global.Weapon_surface);
	draw_sprite_ext(spr_shell12,0,reload_shell_x,reload_shell_y,1,1,reload_angle,-1,1);
	surface_reset_target();
	}
#endregion