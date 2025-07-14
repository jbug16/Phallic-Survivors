
event_inherited()

//Basic
type = "player"

hit = noone

update_status = function()
{
	info = global.player
	
	//Size
	sx = 1 + .01 * global.player.level
	sy = sx
	
	//XP
	xp_max = info.xp
	xp = 0
	
	//Life
	hp_max = info.hp
	hp = hp_max
	
	//Recovery time
	retimer = [0, info.recovery * FR]
	retimer[0] = retimer[1]
	
	//Life steal cooldown
	lstimer = [0, .1 * FR]
	lstimer[0] = lstimer[1]
	
	//Damage
	dmg = info.dmg
	
	//Cooldown
	shoot_timer = [0, FR * info.shoot_time]
	shoot_timer[0] = shoot_timer[1]
	
	//Range
	range = info.range

	//Ammo
	ammo_max = info.ammo
	ammo = ammo_max
	
	//Speed
	spd_max = 8 * info.move_spd
}
global.player.set_status()

//Speed
spd = 0

//Axis vel
velh = 0
velv = 0

//Acel
acel = .4

//Directions
aim = 0
dir = 0

//Invencible state
invc = false
itimer = [0, .1 * FR]
itimer[0] = itimer[1]

//Refill time
rtimer = [0, 2 * FR]
rtimer[0] = rtimer[1]

//Hold time
htimer = [0, .2 * FR]

//Hold control
hold = false

//Shoot control
shoot = false

//Accuracy
accuracy = 1

//Drain amount
dn = [1, .5]
drain = dn

//Beer effect
beer_active = false;

//Pick up
pickupl = ds_list_create()

buff = {
	
	dmg: 1,
	
	list: [],
	
	main: function()
	{
		if(array_length(list) <= 0) exit
		
		for(var i = 0; i < array_length(list); i++)
		{
			if(list[i][1] > 0) list[i][1]--
			else
			{
				set_eff(list[i][0], true)
			}
		}
	}
}

buff.set_eff = function(_i, _d)
{
	with(buff)
	{
		if(!_d)
		{
			var _t = 0
			
			switch(_i)
			{
				case consuList.coffe:
					other.drain = _d ? other.dn : [other.dn[0]*2, other.dn[1]*2];
					_t = 25 * FR;
					break;

				case consuList.lemonade:
					dmg = 1.5;
					_t = 15 * FR;
					break;

				case consuList.beer:
					accuracy = 0.5;
					fade_drunk(1, 0.05);
					_t = 10 * FR;
					break;
			}
			
			if(_t != 0) 
			{
				var _a = true
				
				for(var i = 0; i < array_length(list); i++)
				{
					if(list[i][0] != _i) continue
					
					list[i][1] = _t
					
					_a = false
				}
				
				if(_a) array_push(list, [_i, _t])
			}
		}
		else
		{
			switch(_i)
			{
				case consuList.coffe:
					drain = other.dn;
					break;

				case consuList.lemonade:
					dmg = 1;
					break;

				case consuList.beer:
					accuracy = 1;
					fade_drunk(0, 0.05);
					break;
			}
			
			for(var i = 0; i < array_length(list); i++)
			{
				if(list[i][0] != _i) continue
				
				array_delete(list, i, 1)
					
				break
			}
		}
	}
}

//State
state = "idle"

apply_dmg = function(_d, _s)
{
	if(!invc) 
	{
		take_dmg(_d, _s)
		
		if(hp > 0)
		{
			Fshow_v(_d, 2)
			
			invc = true
			
			itimer[0] = itimer[1]
		}
		else global.lost = true
	}
}

main = function()
{
	if(global.pause || hp < 1) exit
	
	var _k = global.inputs.game, 
	_r = Fbind(_k[gameBinds.walkRight]), 
	_l = Fbind(_k[gameBinds.walkLeft]),
	_u = Fbind(_k[gameBinds.walkUp]), 
	_d = Fbind(_k[gameBinds.walkDown]), 
	_s = Fbind(_k[gameBinds.shoot]),
	_sp = Fbind(_k[gameBinds.shoot], 1),
	_sr = Fbind(_k[gameBinds.shoot], 2),
	_move = ((_r > 0 xor _l > 0) || (_u > 0 xor _d > 0)) && !ob_game.Twave.init
	
	//Refill
	if(rtimer[0] > 0) rtimer[0]--
	else
	{
		ammo = min(ammo + 1, ammo_max)
		
		rtimer[0] = rtimer[1]
	}
	
	//Recovery
	if(info.stats[statsList.recovery] > 0)
	{
		if(retimer[0] > 0) retimer[0]--
		else
		{
			hp = min(hp+1, hp_max)
		
			retimer[0] = retimer[1]
		}
	}
	
	//Life steal
	if(info.stats[statsList.lifeSteal] > 0)
	{
		if(lstimer[0] > 0) lstimer[0]--
	}
	
	//Invencible time
	if(invc)
	{
		if(itimer[0] > 0) itimer[0]--
		else invc = false
	}
	
	//level up
	if(xp >= xp_max)
	{
		xp -= xp_max
		
		global.player.level++
		global.player.ltu++
		
		global.player.stats[statsList.vigor]++
		
		global.player.set_status()
	}
	
	buff.main()
	
	switch(state)
	{
		default:
		{
			//Changing directions
			if(_move) dir = point_direction(0, 0, (_r - _l), (_d - _u))
			
			//Moving
			spd = lerp(spd, spd_max * _move, acel)
			
			if(_sp) hold = true
			
			if(hold)
			{
				if(htimer[0] < htimer[1]) htimer[0]++
				if(htimer[0] = htimer[1]) shoot = true
				
				if(_sr) 
				{
					shoot = true
					hold = false
					
					htimer[0] = 0
				}
			}
			
			if(global.config.auto_aim)
			{
				var _n = instance_nearest(x, y, pa_enemy)
				
				if(instance_exists(_n) && point_in_circle(_n.x, _n.y, x, y, range))
				{
					aim = point_direction(x, y, _n.x, _n.y)
					
					shoot = true
				}
				else shoot = false
			}
			else aim = point_direction(x, y, mouse_x, mouse_y)
			
			if(shoot_timer[0] > 0 && htimer[0] < htimer[1]) shoot_timer[0]--
			else
			{
				if(shoot && ammo > 0)
				{
					with(instance_create_depth(x, y, depth-1, ob_shoot))
					{
						creator = other.id
						
						sk = 1.2
						
						spd = 20
						
						dir = other.aim + irandom_range(-90, 90) * (1 - other.accuracy)
						
						x = x + (lengthdir_x(spd, dir) * 2)
						y = y + (lengthdir_y(spd, dir) * 2)
						
						image_index = 1
						image_blend = c_yellow
						
						dmg = round(4 * other.dmg * other.buff.dmg)
					}
				
					shoot_timer[0] = shoot_timer[1]
					
					shoot = false
					
					var _c = drain[htimer[0] >= htimer[1]]
					
					ammo = max(ammo - _c, 0)
				}
			}
			
			break
		}
	}
	
	#region Pickuping items
	
	collision_circle_list(x, y, global.player.pickup, pa_item, false, true, pickupl, false)
	
	for(var i = 0; i < ds_list_size(pickupl); i++)
	{
		with(pickupl[| i]) go = true
		
		ds_list_delete(pickupl, i)
	}
	
	#endregion
	
	velh = lengthdir_x(spd, dir)
	velv = lengthdir_y(spd, dir)
	
	if(velh != 0) side = sign(velh)
	
	collision()
}