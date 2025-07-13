
event_inherited()

hp_max = round(4 + (global.wave * .3))
hp = hp_max

dmg = round(hp_max/1.6)

spd_max = 3.4

stime = [0, 0]

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
	
	velh = lengthdir_x(spd, dir)
	velv = lengthdir_y(spd, dir)
	
	collision()
}
