/// @desc 

event_inherited();

number = instance_number(object_index)-1

func_shell_eject = function()
	{
	show_debug_message("EJECT");
	
	Func_weapon_shell_eject_create(x,y,image_angle,(image_angle + 180) mod 360,2,7);
	Func_weapon_shell_eject_particles(image_angle+180);
	
	func_shell_visible(false);
	//instance_destroy();
	}

func_shell_visible = function(_bool)
	{
	
	image_alpha = _bool;
	
	
	
	}