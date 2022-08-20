/// @desc 
/*
gets created through  Func_weapon_shell_eject_create()


*/

time = global.game_speed / 1;
time_count = 0;
image_angle = 0;
rot_val = random_range(10,15);
spd_max = 7;//7
spd_min = 2;//2
dir_start = 0;

grav_mult_channel = animcurve_get_channel(ac_shell, "grav_mult_to_speed");
rot_mult_channel = animcurve_get_channel(ac_shell, "rot_mult_to_speed");
spd_mult_channel = animcurve_get_channel(ac_shell, "speed_mult");



//animcurve_get_channel_index()



//var _val = animcurve_channel_evaluate(_channel, sin(current_time/1000));
//image_alpha = _val;





