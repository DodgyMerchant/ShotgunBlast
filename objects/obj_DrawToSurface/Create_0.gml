/// @desc 
//begin_or_end = true;


begin_or_end = object_index == obj_DrawToSurface_Begin;

eventGood = function()
	{
	if event_type == ev_draw
		switch (event_number)
			{
			case ev_draw_pre:
			case ev_draw_post:
			case ev_gui:
			case ev_gui_begin:
			case ev_gui_end:
						return false;
			break;
			default:	return true;
			}
	}

if begin_or_end
	{
	my_function = function()
		{
		if eventGood()
			{
			//shader
			var _shd = shader_current();
			obj_DrawToSurface_End.shd = _shd;
			if _shd != -1
				shader_reset();
			
			//surface
			if !surface_exists(global.Weapon_surface)
				{
				surface_care();	//set in parent begin
				show_debug_message("Draw to surface surface doesnt exist");
				}
			
			surface_set_target(global.Weapon_surface);
			//Func_show_event_information("Func Begin");
			}
		}
	}
else
	{
	my_function = function()
		{
		if eventGood()
			{
			//shader
			if shd != -1
				shader_set(shd);
			
			//surface
			if surface_get_target() == global.Weapon_surface
				{
				surface_reset_target();
				//Func_show_event_information("Func End");
				}
			else
				show_debug_message("Draw to surface surface not target???");
			}
		}
	}


