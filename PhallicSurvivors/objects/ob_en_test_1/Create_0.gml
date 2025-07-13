
event_inherited()

hp_max = round(4 + (global.wave * .5))
hp = hp_max

dmg = round(hp_max/2)

spd_max = 3.4

stime = [0, 0]

take_dmg = function()
{
	
}

main = function()
{
	if(global.pause) exit
	
	if(instance_exists(ob_player))
	{
		//Going to player
		dir = point_direction(x, y, ob_player.x, ob_player.y)
		
		//Moving
		spd = lerp(spd, spd_max, acel)
	}
	
	//velh = lengthdir_x(spd, dir)
	//velv = lengthdir_y(spd, dir)
	
	collision()
}

draw = function()
{
	xs = lerp(xs, 1, .1)
	ys = lerp(ys, 1, .1)
	image_alpha = lerp(image_alpha, 1, .1)
	
	draw_sprite_ext(sprite_index, image_index, x, y, xs * side, ys, image_angle, image_blend, image_alpha)
}
