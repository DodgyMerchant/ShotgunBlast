


///particles
#region BOA open gas Particle Types
//BreakOpen_Traveler
global.pt_BreakOpen_Traveler = part_type_create();
part_type_shape(global.pt_BreakOpen_Traveler, pt_shape_pixel);
part_type_orientation(global.pt_BreakOpen_Traveler, 0, 360, 0.30, 0, 0);
part_type_alpha1(global.pt_BreakOpen_Traveler, 0);
part_type_life(global.pt_BreakOpen_Traveler, 15, 15);
part_type_speed(global.pt_BreakOpen_Traveler, 4, 4, 0, 0);
part_type_direction(global.pt_BreakOpen_Traveler, 110, 110, 1, 0);
part_type_gravity(global.pt_BreakOpen_Traveler, 0, 0);

//BreakOpen_Cloud_step
global.pt_BreakOpen_Cloud_step = part_type_create();
part_type_shape(global.pt_BreakOpen_Cloud_step, pt_shape_cloud);
part_type_size(global.pt_BreakOpen_Cloud_step, 1, 2, 0.01, 0);
part_type_scale(global.pt_BreakOpen_Cloud_step, 0.30, 0.30);
part_type_orientation(global.pt_BreakOpen_Cloud_step, 0, 360, 0, 0, 0);
part_type_color3(global.pt_BreakOpen_Cloud_step, 16777215, 16777215, 16777215);
part_type_alpha3(global.pt_BreakOpen_Cloud_step, 0.11, 0.08, 0.06);
part_type_blend(global.pt_BreakOpen_Cloud_step, 0);
part_type_life(global.pt_BreakOpen_Cloud_step, 80, 120);
part_type_speed(global.pt_BreakOpen_Cloud_step, 0.10, 0.20, 0, 0);
part_type_direction(global.pt_BreakOpen_Cloud_step, 198, 344, 0, 0);
part_type_gravity(global.pt_BreakOpen_Cloud_step, 0, 0);

//BreakOpen_Mist
global.pt_BreakOpen_Mist = part_type_create();
part_type_shape(global.pt_BreakOpen_Mist, pt_shape_cloud);
part_type_size(global.pt_BreakOpen_Mist, 1, 2, 0.01, 0);
part_type_scale(global.pt_BreakOpen_Mist, 0.90, 0.90);
part_type_orientation(global.pt_BreakOpen_Mist, 0, 360, 0, 0, 0);
part_type_color3(global.pt_BreakOpen_Mist, 16777215, 16777215, 16777215);
part_type_alpha3(global.pt_BreakOpen_Mist, 0.02, 0.01, 0);
part_type_blend(global.pt_BreakOpen_Mist, 0);
part_type_life(global.pt_BreakOpen_Mist, 300, 600);
part_type_speed(global.pt_BreakOpen_Mist, 0, 0, 0, 0);
part_type_direction(global.pt_BreakOpen_Mist, 0, 360, 0, 0);
part_type_gravity(global.pt_BreakOpen_Mist, 0, 270);

//Linking Particle Types together (Death and Step)
part_type_step(global.pt_BreakOpen_Traveler, 1, global.pt_BreakOpen_Cloud_step);
//Linking Particle Types together (Death and Step)
part_type_death(global.pt_BreakOpen_Cloud_step, -2, global.pt_BreakOpen_Mist);
part_type_step(global.pt_BreakOpen_Cloud_step, -100, global.pt_BreakOpen_Mist);
#endregion

