
event_inherited()

//Info
coin = 1

wp = function()
{
	global.player.crystals += coin
	
	instance_destroy()
}

image_xscale = random_range(.6, .8)
image_yscale = image_xscale

draw = function()
{
	draw_sprite_ext(sp_coin, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
}