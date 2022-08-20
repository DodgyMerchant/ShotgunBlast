

function Func_SH_continuous_hygene(_surf,_w,_h)
	{//returns the surface	///NEEDS TO BE RETURNED
	
	//surface exists
	if surface_exists(_surf)
		{
		surface_set_target(_surf);
		draw_clear_alpha(0,0);
		surface_reset_target();
		
		return _surf;
		}
	else//surf got destroyed
		{
		return surface_create(_w,_h);
		}
	}


function Func_gun_draw_surf()	
	{
	if surface_exists(global.Weapon_surface)
		{
		//for fauxton
		
		//streatch to fit
		var _val = min(display_get_gui_width(),display_get_gui_height());
		var _xs = _val / global.Weapon_surface_w;
		var _ys = _val / global.Weapon_surface_h *-1;
		//shader_set(shd_gmdefault);
		draw_surface_ext(global.Weapon_surface, 0, display_get_gui_height(), _xs, _ys, 0, c_white, 1);
		
		}
	else
		{
		show_debug_message("Func_draw_surf surface dont exist");
		}
	}