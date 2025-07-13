
//Info
group = "entity"
type = ""

//Collider object
collider = pa_collider

//Life
hp_max = 10
hp = hp_max

//hp lerp
hpl = hp

//Speed
spd_max = 1
spd = 0

//Axis vel
velh = 0
velv = 0

//Acel
acel = .2

//State
state = "idle"

//Size
sx = 1
sy = 1

//Scales
xs = 1
ys = 1

//Side
side = 1

//Direction
dir = 0

//Default damage function for every entity
take_dmg = function(_d, _s)
{
	if(hp > 0)
	{
		hp = clamp(hp - _d, 0, hp_max)
	
		image_alpha = 5
	
		Fss(_s)
	}
}

//"Customizable" damage function
apply_dmg = function(_d, _s)
{
	take_dmg(_d, _s)
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

//Main code
main = function()
{
	if(global.pause) { spd = 0; exit }
	
	collision()
}

//Drawing code
draw = function()
{
	image_alpha = lerp(image_alpha, 1, .2)
	xs = lerp(xs, sx, .2)
	ys = lerp(ys, sy, .2)
	
	shader_set(sh_color)
	
	shader_set_uniform_f(shader_get_uniform(shader_current(), "tt"), image_alpha - 1)
	draw_sprite_ext(sprite_index, image_index, x, y, xs * side, ys, image_angle, image_blend, image_alpha);
	
	shader_reset()
}
