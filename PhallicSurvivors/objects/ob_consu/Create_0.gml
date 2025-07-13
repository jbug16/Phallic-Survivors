
event_inherited()

//Info
type = 0

heal = 1

setup = function(_t)
{
	type = _t
	
	heal = Fconsu_heal(type)
}

wp = function()
{
	with(ob_player)
	{
		ammo = min(ammo + ammo_max * Fconsu_heal(other.type), ammo_max)
		buff.set_eff(other.type)
	}
	
	instance_destroy()
}

image_xscale = random_range(.8, 1)
image_yscale = image_xscale

draw = function()
{
	var _l = [c_aqua, merge_color(c_maroon, c_black, .6), c_yellow, c_orange]
	
	draw_sprite_ext(sp_coin, image_index, x, y, image_xscale, image_yscale, image_angle, _l[type], image_alpha)
}
