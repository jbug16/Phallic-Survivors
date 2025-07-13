
event_inherited()

creator = noone

spd_max = 8
spd = 1

velh = 0
velv = 0

hits = 1

dmg = 0

dir = 0

//Main code
main = function()
{
	if(x < 0 || x > room_width || y < 0 || y > room_height) instance_destroy()
	
	if(global.pause) exit
	
	velh = lengthdir_x(spd, dir)
	velv = lengthdir_y(spd, dir)
	
	x += velh
	y += velv
}

//Drawing code
draw = function()
{
	image_alpha = lerp(image_alpha, 1, .1)
	
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}


