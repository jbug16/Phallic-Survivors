
//Camera
Tcam = {
	
	target : noone, 
	
	//base
	xx: 0,
	yy: 0,
	vel : .1,
	
	//data
	cam: view_camera[0],
	width : camera_get_view_width(view_camera[0]),
	height: camera_get_view_height(view_camera[0]),
	
	//Screenshake
	ss_int : 0,
	
	//methods
	main: function()
	{
		//setting target
		if(target == noone)
		{
			target = instance_exists(ob_player) ? ob_player : noone
			
			if(instance_exists(target))
			{
				xx = target.x
				yy = target.y
				
				camera_set_view_pos(cam, xx - width /2, yy - height/2)
			}
			
			return
		}
		
		try
		{
			//position
			xx = lerp(xx, target.x, vel)
			yy = lerp(yy, target.y, vel)
			
			xx = clamp(xx, width / 2, room_width - width / 2)
			yy = clamp(yy, height / 2, room_height - height / 2)
			
			var _cx = xx
			var _cy = yy
			
			if(ss_int > 0)
			{
				_cx += ss_int * random_range(-1, 1)
				_cy += ss_int * random_range(-1, 1)
				
				if(ss_int > 0.4) ss_int *= .9
				else ss_int = 0
			}
			
			//camera
			camera_set_view_pos(cam, _cx - width / 2, _cy - height / 2)
		}
		catch(_err)
		{ 
			show_debug_message(string("CAM-error: \n{0}", _err))
			target = noone; 
		}
	}	
}

#region Game operations

Tgame = {
	
	transition: {
		
		act: false,
	
		open: false,
		desa: false,
		
		alpha: 0,
		alinc: .02,
		
		can: false,
		
		///@param time 0: fade-in and fade-out | 1: fade-out | 2: fade-in
		set: function(_t = 0)
		{
			/*
				_t = 0 make a fade-in and fade-out
				_t = 1 make a fade-out
				_t = 2 make a fade-in
			*/
			
			switch(_t)
			{
				case 0:
				{
					alpha	= 0
					open	= true
					desa	= false
					can		= false
					
					break
				}
				case 1:
				{
					alpha	= 1
					open	= false
					desa	= true
					can		= false
					
					break
				}
				case 2:
				{
					alpha	= 0
					open	= true
					desa	= false
					can		= true
					
					break
				}
			}
			
			act = true
			
			global.in_transition = true
		},
		
		#region Transition effect
		
		main: function()
		{
			if(!act) exit
			
			//Operation
			if(desa)
			{
				if(alpha > 0)
				{
					alpha = clamp(alpha - alinc, 0, 1)
				}
				else { desa = false; open = false; act = false; can = false }
			}
			else if(open)
			{
				if(alpha < 1)
				{
					alpha = clamp(alpha + alinc, 0, 1)
				}
				else
				{
					if(can)
					{
						alpha = 0
						desa = false
						act = false
						can = false
					}
					else desa = true
					
					open = false
					
					global.in_transition = false
				}
			}
				
			//Black screen
			Frec(0, 0, global.game.width, global.game.height, c_black, alpha)
		},
				
		#endregion
	},
	
	cursor: function()
	{
		if(global.controller != controller.keyboard) exit
		
		if(!global.in_menu)
		{
			if(!global.config.auto_aim) draw_sprite_ext(sp_aim, 0, global.cx, global.cy, 1, 1, 0, c_white, 1)
		}
		else draw_sprite_ext(sp_cursor, 0, global.cx, global.cy, 1, 1, 0, c_white, 1)
	},
}

Tgame.main = function()
{
	with(Tgame)
	{
		//Cursor X and Y pos
		global.cx = device_mouse_x_to_gui(0)
		global.cy = device_mouse_y_to_gui(0)
		
		if(keyboard_check_pressed(ord("R"))) Fgame_state(!global.pause)
		if(keyboard_check_pressed(ord("Z"))) ob_player.apply_dmg(ob_player.hp_max * .3)
		if(keyboard_check_pressed(ord("C"))) with (ob_player) apply_std(std.chlamydia);
		if(keyboard_check_pressed(ord("G"))) with (ob_player) apply_std(std.gonorrhea);
		if(keyboard_check_pressed(ord("H"))) with (ob_player) apply_std(std.herpes);
		if(keyboard_check_pressed(ord("I"))) with (ob_player) apply_std(std.hiv);
		if(keyboard_check_pressed(ord("1")))
		{
			global.player.stats[statsList.recovery]++
			global.player.set_status()
			other.stats.satt = true
		}
		if(keyboard_check_pressed(ord("2")))
		{
			global.player.stats[statsList.lifeSteal]++
			global.player.set_status()
			other.stats.satt = true
		}
		
		if(global.lost)
		{
			if(!transition.open) transition.set(2)
			
			if(transition.alpha >= 1)
			{
				room_goto(rm_menu)
				other.Tmenus.ini.open = true
				other.Tmenus.ini.desa = false
				global.in_menu = true
				global.lost = false
				other.Twave.init = true
				other.Twave.index = -1
				other.Twave.time = [0, 0]
				other.Twave.rtime[0] = 0
				global.player.stats = array_create(statsList.tam, 0)
				global.player.set_status()
			}
		}
	}
}

#endregion

#region Wave

Twave = {
	
	//Init control
	init: true,
	
	//Wave tick
	tick: 5,
	
	//Wave timer
	wave_t: [20, 25, 30, 40, 45, 50, 55, 60],
	
	//Actual wave time and total time
	time: [0, 0],
	
	//Rest time
	rtime: [0, 2 * FR],
	
	create_enemy: function()
	{
		with(instance_create_layer(0, 0, "insts", ob_enemy_spawn))
		{
			do { x = irandom_range(160, 2336); y = irandom_range(160, 1856) }
			until distance_to_object(ob_player) > 100
			
			enemy = ob_en_test
		}
	},
	
	create_consu: function()
	{
		with(instance_create_layer(0, 0, "insts", ob_consu_spawn))
		{
			do { x = irandom_range(160, 2336); y = irandom_range(160, 1856) }
			until distance_to_object(ob_player) > 100
			
			consu = ob_consu
		}
	},
}

Twave.main = function()
{
	with(Twave)
	{
		if(room != rm_000 || global.pause) exit;
		
		//Starting wave
		if(init)
		{
			if(rtime[0] == rtime[1])
			{
				with(ob_player)
				{
					hp = hp_max
					ammo = ammo_max
					
					var _v = 1
					
					global.player.stats[statsList.harvest] += _v
					global.player.set_status()
					
					Fshow_v(_v, 5, statsList.harvest, 80, 270)
					
					xp += info.harvest
					info.crystals += info.harvest
					
					Fshow_v(info.harvest, 4,, 80, 90)
					
					// Condom resets after each wave
					condom_on = false;
					
					// Apply pending STDs
					if (array_length(pending_stds) > 0)
					{
						for (var i = 0; i < array_length(pending_stds); i++)
						{
							apply_std(pending_stds[i]);
						}
						pending_stds = []; // clear after applying
					}
				}
			}
			
			instance_destroy(pa_enemy)
			
			with(pa_item) go = true
			
			if(rtime[0] > 0) rtime[0]--
			else
			{
				if(global.rest)
				{
					if(global.player.ltu <= 0) global.rest = false
					else
					{
						if(other.Tmenus.lu.open != true) 
						{
							other.Tmenus.lu.open = true
							other.Tmenus.lu.desa = false
							
							other.Tmenus.lu.satt = true
							other.Tmenus.lu.stats.satt = true
							
							global.pause = true
							global.in_menu = true
						}
					}
				}
				else
				{
					global.wave++
				
					time[1] = wave_t[min(global.wave, array_length(wave_t)-1)] * FR
					time[0] = time[1]
				
					repeat(3 + (time[1] div FR) * .1) create_enemy()
				
					init = false
					
					// Contract STD
					with (ob_player)
					{
						if (!condom_on)
						{
							var _std = pick_random_std();
							if (_std != -1)
							{
								array_push(pending_stds, _std);
								show_debug_message("Contracted STD, will take effect next wave: " + string(_std));
							}
						}
					}
				}
			}
		}
		else
		{
			var _t = (time[1] div FR)
		
			//Spawning enemies
			if(time[0] > 0 && time[0] % (tick * FR) == 0) repeat(2 + (_t * .3 - _t * .1)) create_enemy()
			
			//Spawning items
			if (time[0] > 0 && time[0] % (tick * FR) == 0)
			{
				if (random(1) < 0.4) // 40% chance to spawn during this tick
				{
				    create_consu();
				}
			}

			// Give player boner
			if (!global.boner_immune)
			{
				if (time[0] > 0 && time[0] % (tick * FR) == 0)
				{
					with (ob_player)
					{
						if ((random(1) < 0.02) and can_move != false) // 10% chance per wave (5 ticks per wave, 2% per tick)
						{
							sprite_index = sp_player_freeze;
							can_move = false;
							freeze_clicks_left = 10;
						}
					}
				}
			}
		
			//Counting down time
			if(time[0] > 0) time[0]--
			else
			{
				rtime[0] = rtime[1]
				init = true
				global.rest = true
			}
		}
	}
}

#endregion

//Menus struct
Tmenus = {
	
	ini: {},
	pause: {},
	hud: {},
	shop: {},
	lu: {},
	
	satt: noone,
}

#region Hud

with(Tmenus.hud)
{
	hpl = instance_exists(ob_player) ? ob_player.hp : 0
	ammol = instance_exists(ob_player) ? ob_player.ammo : 0
	
	///@func draw_bar(x, y, width, height, color, value_actual, value_max, [value_lerp], [title], [color_lerp])
	draw_bar = function(_x, _y, _w, _h, _c, _va, _vm, _vl, _tl, _cl = c_orange)
	{
		var _b = 5
		var _p = [_x + _b, _y + _b]
		
		var _f = merge_color(c_black, c_white, .2)
		
		var _r = 4
		Froundrec(_p[0]-_b, _p[1]-_b, _w+_b*2, _h+_b*2, _r+_b, c_black)
		Froundrec(_p[0], _p[1], _w, _h, _r, _f)
		if(_vl != undefined) Froundrec(_p[0], _p[1], _w * _vl/_vm, _h, _r, _cl)
		Froundrec(_p[0], _p[1], _w * _va/_vm, _h, _r, _c)
		
		if(_tl != undefined)
		{
			var _la = draw_get_halign()
			
			draw_set_halign(fa_right)
			
			Ftext(_p[0] + _w - 5, _p[1] - 5 + _h div 2 - 7, _tl)
			
			draw_set_halign(_la)
		}
		else
		{
			var _t = $"{round(_va)}/{_vm}"
			
			Ftext(_p[0] + _w div 2, _p[1] - 5 + _h div 2 - 7, _t)
		}
	}
}

Tmenus.hud.main = function()
{
	with(Tmenus.hud)
	{
		if(room != rm_000) exit
		
		draw_set_font(Ffont(fontsList.regular))
		
		var _t = $"{Fgametext("term_wave", global.wave+1)}"

		if(!global.lost) draw_text(global.game.width div 2 - string_width(_t) div 2, 10, _t)
		
		if(other.Twave.time[0] div FR > 0 || global.lost)
		{
			var _t = global.lost ? Fgametext("term_lost") : $"{other.Twave.time[0] div FR}"
		
			draw_set_font(Ffont(fontsList.big))
		
			draw_text(global.game.width div 2 - string_width(_t) div 2, 10 + Ffont_spacing(fontsList.regular), _t)
		}
		
		//Player Hud
		with(ob_player)
		{
			if(other.hpl != hp && !global.pause) other.hpl = lerp(other.hpl, hp, .2)
			if(other.ammol != ammo && !global.pause) other.ammol = lerp(other.ammol, ammo, .2)
			
			var a = global.player.stats
			
			Fdraw(Ffont(fontsList.regular, fontsType.bold), fa_center)
			
			//Bladder
			draw_sprite(sp_bladder_bg, 0, 10, 10)

			var _h = sprite_get_height(sp_bladder) * (1 - other.ammol/ammo_max)
			
			draw_sprite_part_ext(sp_bladder, 0, 0, _h, sprite_get_width(sp_bladder), sprite_get_height(sp_bladder), BGS, BGS + _h, 1, 1, c_yellow, 1)
			
			//Life
			other.draw_bar(22 + sprite_get_width(sp_bladder_bg), 10, 250, 32, c_red, hp, hp_max, other.hpl)
			
			//XP
			other.draw_bar(22 + sprite_get_width(sp_bladder_bg), 60, 250, 32, c_lime, xp, xp_max,, $"LV. {global.player.level}")
			
			var _x = 10, _y = 120
			
			draw_set_halign(fa_left)
			
			draw_sprite_ext(sp_coin, 0, _x + sprite_get_width(sp_coin) div 2, _y + sprite_get_height(sp_coin) div 2, 1, 1, 0, c_white, 1)
			
			Ftext(_x + sprite_get_width(sp_coin) + 10, _y + sprite_get_height(sp_coin) div 2 - 13, global.player.crystals)
			
			//Ftext(10, 10, $"EXP: {xp}/{xp_max}")
			
			//Ftext(10, 10 + (Ffont_spacing(fontsList.regular) * 2), $"Ammo: {ammo}/{ammo_max}")
			//Ftext(10, 10 + (Ffont_spacing(fontsList.regular) * 3), $"Shoot: {shoot_timer[0]}/{shoot_timer[1]}")
			
			Fdraw()
		}
	}
}

#endregion

//Initial menu
with(Tmenus.ini)
{
	surf = noone
	satt = true
	
	alpha = 0
	alinc = ALINC
	
	open = true
	desa = false
	
	ops = [
		[
			["ini_start"],
			["ini_options"],
			["ini_credits"],
			["ini_quit"],
		],
		[
			["term_back"],
		]
	]
	
	page = 0
	
	action = 0
	
	sel = 0
	
	sl_get_w = function()
	{
		if(sel < 0) return 0
		
		var _l = draw_get_font()
		
		draw_set_font(fnt)
		
		var _w = string_width(Fgametext(ops[page][sel][0])) + BGS * 2
		
		draw_set_font(_l)
		
		return _w
	}
	
	sl_op = function(_o)
	{
		switch(_o)
		{
			case 0: //Resume
			break 
			case 1: //Start
			{
				desa = true
				action = 0
				
				break
			}
			case 2: //Options
			{
				//page = 2
				
				if(surface_exists(surf)) surface_free(surf)
				
				break
			}
			case 3: //Credits
			{
				page = 1
				
				if(surface_exists(surf)) surface_free(surf)
				
				break
			}
			case 4: //Quit
			{
				desa = true
				action = 1
				
				break
			}
			case 5: //Credits
			{
				page = 0
				
				if(surface_exists(surf)) surface_free(surf)
				
				break
			}
		}
	}
	
	sl_accept = function()
	{
		if(sel < 0) exit
		
		switch(page)
		{
			case 0:
				
				switch(sel)
				{
					case 0: sl_op(1); break
					case 1: sl_op(2); break
					case 2: sl_op(3); break
					case 3: sl_op(4); break
				}
				
				break
			case 1:
				
				sl_op(5)
				
				break
		}
	}
	
	fnt = Ffont(fontsList.big)
	
	sl_x = 0
	sl_y = 0
	sl_w = sl_get_w()
	sl_h = 54
	sep = 15
	
	sx = BGA
	sw = global.game.width
	sh = 0
	sy = 0
	
	main = function()
	{
		if(!open) exit
		
		#region Alpha
		
		if(!desa)
		{
			if(alpha < 1)
			{
				alpha = clamp(alpha + alinc, 0, 1)
			}
		}
		else
		{
			if(alpha > 0)
			{
				alpha = clamp(alpha - alinc, 0, 1)
			}
			else
			{
				switch(action)
				{
					case 0: open = false; desa = false; global.in_menu = false; global.pause = false; room_goto(rm_000); break
					case 1: game_end(); break
				}
				
				action = 0
			}
		}
		
		#endregion
		
		#region Visual
		
		if(!surface_exists(surf))
		{
			sh = (sl_h + sep) * array_length(ops[page]) - sep
			
			sy = global.game.height - sh - sx
			
			surf = surface_create(sw, sh)
			satt = true
		}
		else
		{
			Fdraw(Ffont(fontsList.big, fontsType.bold),,,, alpha)
			
			//Title
			var _t = "Phallic Survivors"
			Ftext(global.game.width div 2 - string_width(_t) div 2, 200, _t,, alpha)
			
			if(page == 1)
			{
				draw_set_font(Ffont(fontsList.big))
				draw_set_halign(fa_center)
				Ftext(global.game.width div 2, 300, $"- {Fgametext("cred_director")} -\nJake\n\n- {Fgametext("cred_programmer")} -\nSant'Anna Dev",,, 48)
				draw_set_halign(-1)
			}
			
			Fdraw(fnt,,,, alpha)
			draw_surface(surf, sx, sy)
			Fdraw()
			
			if(satt)
			{
				surface_set_target(surf)
				draw_clear_alpha(c_black, 0)
				
				draw_set_font(fnt)
				
				for(var i = 0; i < array_length(ops[page]); i++)
				{
					var _t = Fgametext(ops[page][i][0])
					var _x = sl_x, _y = sl_y + ((sl_h + sep) * i)
					var _c = sel == i ? [c_black, c_white] : [c_white, c_black]
					
					Froundrec(_x, _y, string_width(_t) + BGS * 2, sl_h, 20, _c[1])
					Ftext(_x + BGS, _y+2, _t, _c[0])
				}
				
				surface_reset_target()
				satt = false
			}
			
			Fdraw()
		}
		
		#endregion
		
		#region Select
		
		if(alpha > ALMIN)
		{
			if(global.cx >= sx + sl_x && global.cx < sx + sl_x + sl_w && global.cy >= sy + sl_y && global.cy <= sy + sl_y + sh && ((global.cy - sy + sl_y) div (sl_h + sep)) == sel)
			sl_wp = sl_get_w()
			
			var _accept = mouse_check_button_pressed(mb_left)
			
			var _x1 = sx + sl_x,
				_y1 = sy + sl_y,
				_x2 = _x1 + sl_w,
				_y2 = _y1 + sh,
				_ind = (global.cy - _y1) div (sl_h + sep),
				_area = global.cx >= _x1 &&
						global.cy >= _y1 &&
						global.cx < _x2 &&
						global.cy < _y2
			
			if(_area)
			{
				if(_ind > -1 && _ind < array_length(ops[page]))
				{
					if(sel != _ind)
					{
						sel = _ind
						satt = true
					}
					
					if(_accept) sl_accept()
				}
			}
		}
		
		#endregion
	}
}

//Pause menu
with(Tmenus.pause)
{
	surf = noone
	satt = true
	
	alpha = 0
	alinc = ALINC
	
	open = false
	desa = false
	
	sx = 0
	sy = 0
	sw = global.game.width
	sh = global.game.height
	
	main = function()
	{
		if(!open) exit
		
		#region Alpha
		
		if(!desa)
		{
			if(alpha < 1)
			{
				alpha = clamp(alpha + alinc, 0, 1)
			}
		}
		else
		{
			if(alpha > 0)
			{
				alpha = clamp(alpha - alinc, 0, 1)
			}
			else { open = false; desa = false; global.in_menu = false; global.pause = false }
		}
		
		#endregion
		
		#region Visual
		
		if(!surface_exists(surf))
		{
			surf = surface_create(sw, sh)
			satt = true
		}
		else
		{
			Fdraw(Ffont(fontsList.regular),,,, alpha)
			draw_surface(surf, sx, sy)
			Fdraw()
			
			if(satt)
			{
				surface_set_target(surf)
				draw_clear_alpha(c_black, 0)
				
				surface_reset_target()
				satt = false
			}
			
			Fdraw()
		}
		
		#endregion
	}
}

//Level up menu
with(Tmenus.lu)
{
	surf = noone
	satt = true
	
	alpha = 0
	alinc = ALINC
	
	open = false
	desa = false
	
	stats = new global.Cstats()
	
	sl = {}
	
	with(sl)
	{
		surf = noone
		satt = true
		
		b = 40
		
		sl_w = 351
		sl_h = 188
		sl_x = b
		sl_y = b
		sep = 10
		
		sx = 32 - b
		sy = 407
		sw = 1468 + b*2
		sh = sl_h + b*2
		
		sel = noone
		
		ops = array_create(4, noone)
		
		set_upgrades = function()
		{
		    var _l = []
			
		    for(var i = 0; i < statsList.tam; i++)
		    {
		        array_push(_l, i)
				//show_message($"{i} | {global.ug_grid[# i, ugInfo.stats]}")
		    }
    
		    for(var i = 0; i < array_length(ops); i++)
		    {
		        if(array_length(_l) > 0)
		        {
					var _i = irandom(array_length(_l)-1)
					
					var _c = [
					    1 * global.player.luck,
					    max(min(0.06 * global.wave, 0.6) * global.player.luck, 0),
					    max(min(0.02 * (global.wave-1), 0.25) * global.player.luck, 0),
					    max(min(0.0023 * (global.wave-6), 0.08) * global.player.luck, 0)
					]
					
		            ops[i] = _l[_i] * tier.tam + Fweight_random(_c)
					
					array_delete(_l, _i, 1)
		        }
		    }
			
			satt = true
		}
		set_upgrades()
	}
	
	sl.main = function(_a)
	{
		with(sl)
		{
			var _accept = mouse_check_button_pressed(mb_left)
			
			if(!surface_exists(surf))
			{
				surf = surface_create(sw, sh)
				satt = true
			}
			else
			{
				Fdraw(Ffont(fontsList.regular),,,, _a)
				draw_surface(surf, sx, sy)
				Fdraw()
				
				if(satt)
				{
					surface_set_target(surf)
					draw_clear_alpha(c_black, 0)
					
					for(var i = 0; i < array_length(ops); i++)
					{
						var _x = sl_x + (sl_w + sep) * i
						var _y = sl_y
						
						var _r = Fug_tier(ops[i])
						var _rc = Fug_color(ops[i])
						var _s = Fgametext(Fug_stats(ops[i]))
						var _tx = $"{_s} {global.tiers[_r]}"
						var _v = $"+{Fug_info(ops[i], ugInfo.stats)}"
						
						//Selection
						var _g = 5
						if(sel == i) Froundrec(_x - _g, _y - _g, sl_w + _g*2, sl_h + _g*2, R+_g, _rc[1])
						
						//Box
						Froundrec(_x, _y, sl_w, sl_h, R, _rc[0], .94)
						
						//Icon
						Froundrec(_x + 19, _y + 19, 96, 96, R div 2, IBC, 1)
						
						//Name
						Ftext(_x + 127, _y + 25, _tx, c_white)
						
						//Desc
						Ftext(_x + 19, _y + 132, _v, c_lime)
						Ftext(_x + 19 + string_width(_v), _y + 132, $" {_s}.")
					}
					
					surface_reset_target()
					satt = false
				}
				
				Fdraw()
			}
			
			if(_a > ALMIN)
			{
				var _x1 = sx + sl_x,
					_y1 = sy + sl_y,
					_x2 = _x1 + (sl_w + sep) * array_length(ops),
					_y2 = _y1 + sl_h,
					_in = (global.cx - _x1) div (sl_w + sep),
					_area = global.cx >= _x1 &&
							global.cy >= _y1 &&
							global.cx < _x2 &&
							global.cy < _y2
				
				//Frec(_x1, _y1, _x2 - _x1, _y2 - _y1,, .5)
				
				if(_area)
				{
					if(_in > -1 && _in < array_length(ops))
					{
						if(sel != _in)
						{
							sel = _in
							satt = true
						}
						
						if(_accept)
						{
							global.player.stats[Fug_base(ops[sel])] += global.ug_grid[# ops[sel], ugInfo.stats]
							
							global.player.set_status()
							global.player.ltu = max(global.player.ltu-1, 0)
							
							if(global.player.ltu <= 0) { other.desa = true; global.rest = false; global.pause = false }
							else set_upgrades()
							
							other.stats.satt = true
							other.satt = true
						}
					}
				}
				else
				{
					if(sel != noone)
					{
						sel = noone
						satt = true
					}
				}
			}
		}
	}
	
	sx = 0
	sy = 0
	sw = global.game.width
	sh = global.game.height
	
	main = function()
	{
		if(!open) exit
		
		#region Alpha
		
		if(!desa)
		{
			if(alpha < 1)
			{
				alpha = clamp(alpha + alinc, 0, 1)
			}
		}
		else
		{
			if(alpha > 0)
			{
				alpha = clamp(alpha - alinc, 0, 1)
			}
			else { open = false; desa = false; global.in_menu = false; global.pause = false }
		}
		
		#endregion
		
		#region Visual
		
		if(!surface_exists(surf))
		{
			surf = surface_create(sw, sh)
			satt = true
		}
		else
		{
			Frec(0, 0, global.game.width, global.game.height, c_black, alpha * .6)
			
			Fdraw(Ffont(fontsList.regular),,,, alpha)
			draw_surface(surf, sx, sy)
			Fdraw()
			
			if(satt)
			{
				surface_set_target(surf)
				draw_clear_alpha(c_black, 0)
				
				//Level up
				draw_set_font(Ffont(fontsList.big, fontsType.bold))
				
				var _t = Fgametext("term_lu", global.player.ltu)
				Ftext(sw div 2 - string_width(_t), 332, _t)
				
				
				
				surface_reset_target()
				satt = false
			}
			
			Fdraw()
		}
		
		sl.main(alpha)
		
		stats.main(alpha)
		
		#endregion
	}
}

//Shop menu
with(Tmenus.shop)
{
	surf = noone
	satt = true
	
	alpha = 1
	
	sx = 0
	sy = 0
	sw = 402
	sh = global.game.height
	
	stats = new global.Cstats()
	stats.center = false
	
	open = false
	
	sl = {}
	
	with(sl)
	{
		surf = noone
		satt = true
		
		sx = BGA
		sy = BGA
		sw = 1434
		sh = 614
		
		sl_w = 351
		sl_h = 482
		sl_x = 0
		sl_y = sh - sl_h
		sep = 10
		
		sel = noone
		
		var _s = min(4, shopItem.tam)
		
		ops = array_create(_s, noone)
		
		set_items = function()
		{
			var shop_pool = [
				shopItem.tightWad,
				shopItem.chasityBelt,
				shopItem.titaniumLoop,
				shopItem.condom
			];

			for (var i = 0; i < array_length(ops); i++) {
				ops[i] = choose(shop_pool);
			}

		}
		set_items()
		//ops[3] = 
		
		main = function(_a)
		{
			if(!surface_exists(surf))
			{
				surf = surface_create(sw, sh)
				satt = true
			}
			else
			{
				Fdraw(Ffont(fontsList.regular),,,, _a)
				draw_surface(surf, sx, sy)
				Fdraw()
				
				if(satt)
				{
					surface_set_target(surf)
					draw_clear_alpha(c_black, 0)
					
					surface_reset_target()
					satt = false
				}
				
				Fdraw()
			}
		}
	}
	
	main = function()
	{
		if(!open) exit
		
		if(!surface_exists(surf))
		{
			surf = surface_create(sw, sh)
			satt = true
		}
		else
		{
			Frec(0, 0, global.game.width, global.game.height, c_black, alpha * .6)
			
			Fdraw(Ffont(fontsList.regular),,,, alpha)
			draw_surface(surf, sx, sy)
			Fdraw()
			
			if(satt)
			{
				surface_set_target(surf)
				draw_clear_alpha(c_black, 0)
				
				//Shop
				Ftext(BGA, BGA, $"{Fgametext("term_shop")} - {Fgametext("term_wave", global.wave)}")
					
				surface_reset_target()
				satt = false
			}
			
			Fdraw()
		}
		
		stats.main(alpha)
		
		sl.main(alpha)
	}
}

//Update all
Tmenus.satt = function()
{
	Tmenus.shop.stats.satt = true
}

//Debug stats
stats = new global.Cstats()

Tmenus.main = function()
{
	Tmenus.ini.main()
	
	//stats.main(1)
	
	Tmenus.lu.main()
	
	Tmenus.hud.main()
	
	Tmenus.shop.main()
	
	Tmenus.pause.main()
	
	var _l = keyboard_check_pressed(ord("L"))
	
	if(_l)
	{
		var _i = global.config.lang+1
	
		if(_i > array_length(global.langs.ids)-1) { _i = 0 }
		if(_i < 0) { _i = array_length(global.langs.ids)-1 }
	
		Fset_language(Flang_string(_i))
	}
}
