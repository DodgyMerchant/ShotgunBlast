


function Func_t_invert(_t)
	{
	return _t * -1 + 1;
	}



function Func_show_event_information(_str)
	{
	// \n
	
	show_debug_message(_str+ " //////////////////////////////////////////////");
	show_debug_message("obj index: "+string(object_index)+" = "+object_get_name(object_index));
	show_debug_message("event obj: "+object_get_name(event_object));
	show_debug_message("event name: "+Func_event_get_name(event_number));
	show_debug_message("//////////////////////////////////////////////");
	
	}
function Func_event_get_name(_index)
	{
	switch (_index)
		{
		case ev_step_normal:	return "Step normal";		break;
		case ev_step_begin:	return "Step begin";		break;
		case ev_step_end:		return "Step end";			break;
		case ev_draw_begin:	return "draw begin";		break;
		case ev_draw_end:		return "draw end";			break;
		case ev_draw_pre:		return "draw pre";			break;
		case ev_draw_post:		return "draw post";		break;
		case ev_gui:			return "draw gui normal";	break;
		case ev_gui_begin:		return "draw gui begin";	break;
		case ev_gui_end:		return "draw gui end";		break;
		case ev_draw:			return "draw normal";		break;
		}
	}
