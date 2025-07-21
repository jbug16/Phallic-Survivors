
consu = noone

timer = [0, .7 * FR]
timer[0] = timer[1]

create_consu = function()
{
	var _weights = [];
	for (var i = 0; i < array_length(global.consu[1]); i++)
	{
		array_push(_weights, Fconsu_rate(i));
	}

	var _t = Fweight_random(_weights);
	Fspawn_consu(_t);
	show_debug_message("Spawned consu: " + string(_t));
}

main = function()
{
	if(global.pause) exit
	
	if(!object_exists(consu)) instance_destroy()
	
	if(timer[0] > 0) timer[0]--
	else 
	{
		create_consu()
		
		instance_destroy()
	}
}

draw = function()
{
	var _s = timer[0]/timer[1]
	
	draw_sprite_ext(sp_se_warn, 0, x, y, _s, _s, 0, c_red, 1)
}
