
event_inherited()

type = "enemy"

life = false

state = "free"

stime = [0, 0]

dmg = 1
hit = noone
htimer = [0, 1.4 * FR]
htimer[0] = htimer[1]

apply_dmg = function(_d, _s)
{
	life = true
	
	take_dmg(_d, _s)
	
	Fshow_v(_d, 0)
	
	//Life steal
	with(ob_player)
	{
		if(info.stats[statsList.lifeSteal] > 0)
		{
			if(lstimer[0] <= 0 && random(1) <= info.life_steal)
			{
				hp = min(hp+1, hp_max)
		
				lstimer[0] = lstimer[1]
			}
		}
	}
	
	if(hp <= 0)
	{
		with(ob_player) 
		{
			//ammo = clamp(round(ammo + max((1 * (other.hp_max*.6)), ammo_max / 2.5)), 0, ammo_max)
			xp += round(other.hp_max*.8) + irandom(5)
		}
		
		repeat(min(round(hp_max/2), 50))
		{
			var _r = 70
			
			with(instance_create_depth(x + irandom_range(_r, -_r), y + irandom_range(_r, -_r), depth+1, ob_coin)) 
			{
				dir = point_direction(other.x, other.y, x, y)
				coin = round(other.hp_max * .7)
			}
		}
		
		if(random(1) <= .1)
		{
			var _l = global.consu[1]
			
			for(var i = 0; i < array_length(_l); i++)
			{
				_l[i] *= global.player.luck
			}
			
			//Fspawn_consu(Fweight_random(_l))
			Fspawn_consu(consuList.beer);
		}
		
		instance_destroy()
	}
}

main = function()
{
	
}

life_bar = function()
{
	if(hpl != hp)
	{
		hpl = clamp(lerp(hpl, hp, .1), 0, hp_max)
	}
	
	var _w = 110, _h = 10, _r = 10
	var _x = x - _w div 2
	var _y = y - sprite_height div 2 - _h - 10
	
	Froundrec(_x, _y, _w, _h, _r, c_dkgray)
	
	Froundrec(_x, _y, _w * (hpl/hp_max), _h, _r, c_orange)
	
	Froundrec(_x, _y, _w * (hp/hp_max), _h, _r, c_red)
}
