/// @desc 

randomize();

global.game_speed = game_get_speed(gamespeed_fps);

global.Weapon_seq_layer = layer_get_id("Weapon_sequence");
global.Particle_layer = layer_get_id("Particles");

global.Weapon_surface_w = display_get_gui_width();//300
global.Weapon_surface_h = display_get_gui_height();
global.Weapon_surface = surface_create(global.Weapon_surface_w,global.Weapon_surface_h);



#region camera
instance_create_layer(0, 0, layer, Camera);

// Camera Size
Camera.Width = 640;					// The width of our view
Camera.Height = 360;				// The height of our view

// Set a default angle
Camera.Angle = 45;					// Set the angle
Camera.aTo = Camera.Angle;			// The 'interpolation' value must be set or the angle will just lerp to 0

// Set Camera pitch stuff
Camera.PitchRangePosition = 25;		// A lower starting point for our pitch range (default is 45)
Camera.Pitch = 22.5;				// Set the pitch
Camera.pTo = Camera.Pitch;			// The 'interpolation' value must be set or the pitch will just lerp to 45
Camera.PitchRange = 20;				// Set the pitch range


#endregion
#region Particle system

//Generated for GMS2 in Geon FX v1.3.2
//Put this code in Create event

//BOAopengas Particle System
global.ps = part_system_create();
//part_system_depth(global.ps, -1);
part_system_layer(global.ps,global.Particle_layer);

Particles(global.ps);


#endregion
#region Gun & Part to surface draw

//*


//bind scripts  calls the obj fgunctions
var _func = function()
	{
	obj_DrawToSurface_Begin.my_function()
	}
layer_script_begin(	"DrawToSurface_Begin",	_func);
var _func = function()
	{
	obj_DrawToSurface_End.my_function()
	}
layer_script_end(	"DrawToSurface_End",	_func);

//*/


#endregion


#region debug



//give weapon
var _part_list = ds_list_create()
ds_list_add(_part_list,WEAP_BOA_Parts.Stock_Full,WEAP_BOA_Parts.Front_Long);

Func_weapon_player_equip(WEAPON_TYPE.BreakOverUnder,_part_list);
ds_list_destroy(_part_list);




#endregion