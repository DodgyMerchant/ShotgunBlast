/// @desc 


if keyboard_check_pressed(vk_escape)
	game_end();




if keyboard_check_pressed(vk_space)
	{
	var i = 0;
	show_debug_message("gui w/h: "+string(display_get_gui_width())+"/"+string(display_get_gui_width()));
	show_debug_message("port w/h: "+string(view_get_wport(i))+"/"+string(view_get_hport(i)));
	show_debug_message("cam w/h: "+string(camera_get_view_width(i))+"/"+string(camera_get_view_height(i)));
	//show_debug_message("gui w/h: "+string(display_get_gui_width())+"/"+string(display_get_gui_width()));
	}