
enemy = noone

timer = [0, .7 * FR]
timer[0] = timer[1]

create_enemy = function()
{
	instance_create_depth(x, y, depth, enemy)
}

main = function()
{
	if(global.pause) exit
	
	if(!object_exists(enemy)) instance_destroy()
	
	if(timer[0] > 0) timer[0]--
	else 
	{
		create_enemy()
		
		instance_destroy()
	}
}

draw = function()
{
	var _s = timer[0]/timer[1]
	
	draw_sprite_ext(sp_se_warn, 0, x, y, _s, _s, 0, c_red, 1)
}
