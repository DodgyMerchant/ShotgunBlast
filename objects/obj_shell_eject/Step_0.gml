/// @desc 

//count time
if time_count < time
	{
	time_count = min(time_count+1,time);
	}

var _t = time_count / time;
var _spd_mult = animcurve_channel_evaluate(spd_mult_channel,_t);
var _spd = lerp(spd_max,spd_min,_spd_mult);

image_angle += rot_val * animcurve_channel_evaluate(rot_mult_channel,_spd_mult);
var _dir = dir_start - angle_difference(dir_start,270) * animcurve_channel_evaluate(grav_mult_channel,_spd_mult);

//position
x += lengthdir_x(_spd,_dir);
y += lengthdir_y(_spd,_dir);


//check destroy
alarm[0] = global.game_speed * 5;
