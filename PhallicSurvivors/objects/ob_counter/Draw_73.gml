
if(timer[0] > 0) timer[0]--
else instance_destroy()

y -= .5

Fdraw(Ffont(fontsList.big, fontsType.bold), fa_center, fa_top)

var _s = [noone, 0, 1, c_white]
var _b = [0, 0]

var _t = ""

switch(type)
{
	case 1:	//Critic
	{
		c = c_yellow
		
		break
	}
	case 2:	//Player hitted
	{
		c = c_red
		
		break
	}
	case 3:	//Heal
	{
		c = c_lime
		
		break
	}
	case 4: //Money
	{
		_s = [sp_coin, 0, 1, c_white]
		
		break
	}
	case 5: //Stats
	{
		_t = $"{Fgametext(global.stats_names[stats])}: "
		//_s = [sp_stats, stats, 1, c_white]
		
		break
	}
}

var _a = timer[0]/timer[1]
var _tt = $"{_t}{v}"
if(_s[0] != noone) draw_sprite_ext(_s[0], _s[1], x + _b[0] - sprite_get_width(_s[0]) - string_width(_tt) div 2, y + _b[1] + 25, _s[2], _s[2], 0, _s[3], _a)
Ftext(x + _b[0], y + _b[1], _tt, c, _a)

Fdraw()
