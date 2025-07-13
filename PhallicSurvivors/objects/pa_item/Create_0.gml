
dir = irandom(359)

spd = irandom_range(3, 7)

velh = 0
velv = 0

//Collider object
collider = pa_collider

go = false

wp = function()
{
	instance_destroy()
}

//Collision
collision = function()
{
	var _vh = velh
	var _vv = velv
	
	//horizontal
	if(place_meeting(x + _vh, y, collider))
	{
		while(!place_meeting(x + sign(_vh), y, collider)) x += sign(_vh)
		_vh = 0
		
		velh = 0
	}
	
	x += _vh
	
	//vertical
	if(place_meeting(x, y + _vv, pa_collider))
	{
		while(!place_meeting(x, y + sign(_vv), collider)) y += sign(_vv)
		_vv = 0
		
		velv = 0
	}
	
	y += _vv
}

main = function()
{
	if(!instance_exists(ob_player)) instance_destroy()
	
	if(global.pause) exit
	
	if(!go) 
	{
		if(spd > 0) spd = max(spd*.97, 0)
	}
	else
	{
		dir = point_direction(x, y, ob_player.x, ob_player.y)
		
		spd = lerp(spd, 20, .2)
		
		if(instance_place(x, y, ob_player)) wp()
	}
	
	velh = lengthdir_x(spd, dir)
	velv = lengthdir_y(spd, dir)
	
	collision()
}
