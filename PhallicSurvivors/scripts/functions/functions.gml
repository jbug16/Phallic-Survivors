
#region Controller

enum gpType
{
	a,		//Xbox
	b,		//Playstation
	c,		//Nintendo
	tam,
}

enum controller
{
	keyboard,
	gamepad,
	tam
}

global.controller = controller.keyboard

global.gamepad = {
	
	index	: noone,
	type	: noone,
}

//Gamepad Deadzone
#macro GPDZ .2

#macro GP_ANYB	(gamepad_button_check(global.gamepad.index, gp_face1) || gamepad_button_check(global.gamepad.index, gp_face2) || gamepad_button_check(global.gamepad.index, gp_face3) || gamepad_button_check(global.gamepad.index, gp_face4) || gamepad_button_check(global.gamepad.index, gp_shoulderl) || gamepad_button_check(global.gamepad.index, gp_shoulderlb) || gamepad_button_check(global.gamepad.index, gp_shoulderr) || gamepad_button_check(global.gamepad.index, gp_shoulderrb) || gamepad_button_check(global.gamepad.index, gp_select) || gamepad_button_check(global.gamepad.index, gp_start) || gamepad_button_check(global.gamepad.index, gp_stickl) || gamepad_button_check(global.gamepad.index, gp_stickr) || gamepad_button_check(global.gamepad.index, gp_padu) || gamepad_button_check(global.gamepad.index, gp_padd) || gamepad_button_check(global.gamepad.index, gp_padl) || gamepad_button_check(global.gamepad.index, gp_padr) || gamepad_button_check(global.gamepad.index, gp_padr) || abs(gamepad_axis_value(global.gamepad.index, gp_axislh)) > GPDZ || abs(gamepad_axis_value(global.gamepad.index, gp_axislv)) > GPDZ || abs(gamepad_axis_value(global.gamepad.index, gp_axisrh)) > GPDZ || abs(gamepad_axis_value(global.gamepad.index, gp_axisrv)) > GPDZ || gamepad_button_check_pressed(global.gamepad.index, gp_face1) || gamepad_button_check_pressed(global.gamepad.index, gp_face2) || gamepad_button_check_pressed(global.gamepad.index, gp_face3) || gamepad_button_check_pressed(global.gamepad.index, gp_face4) || gamepad_button_check_pressed(global.gamepad.index, gp_shoulderl) || gamepad_button_check_pressed(global.gamepad.index, gp_shoulderlb) || gamepad_button_check_pressed(global.gamepad.index, gp_shoulderr) || gamepad_button_check_pressed(global.gamepad.index, gp_shoulderrb) || gamepad_button_check_pressed(global.gamepad.index, gp_select) || gamepad_button_check_pressed(global.gamepad.index, gp_start) || gamepad_button_check_pressed(global.gamepad.index, gp_stickl) || gamepad_button_check_pressed(global.gamepad.index, gp_stickr) || gamepad_button_check_pressed(global.gamepad.index, gp_padu) || gamepad_button_check_pressed(global.gamepad.index, gp_padd) || gamepad_button_check_pressed(global.gamepad.index, gp_padl) || gamepad_button_check_pressed(global.gamepad.index, gp_padr) || gamepad_button_check_pressed(global.gamepad.index, gp_padr) || gamepad_button_check_released(global.gamepad.index, gp_face1) || gamepad_button_check_released(global.gamepad.index, gp_face2) || gamepad_button_check_released(global.gamepad.index, gp_face3) || gamepad_button_check_released(global.gamepad.index, gp_face4) || gamepad_button_check_released(global.gamepad.index, gp_shoulderl) || gamepad_button_check_released(global.gamepad.index, gp_shoulderlb) || gamepad_button_check_released(global.gamepad.index, gp_shoulderr) || gamepad_button_check_released(global.gamepad.index, gp_shoulderrb) || gamepad_button_check_released(global.gamepad.index, gp_select) || gamepad_button_check_released(global.gamepad.index, gp_start) || gamepad_button_check_released(global.gamepad.index, gp_stickl) || gamepad_button_check_released(global.gamepad.index, gp_stickr) || gamepad_button_check_released(global.gamepad.index, gp_padu) || gamepad_button_check_released(global.gamepad.index, gp_padd) || gamepad_button_check_released(global.gamepad.index, gp_padl) || gamepad_button_check_released(global.gamepad.index, gp_padr) || gamepad_button_check_released(global.gamepad.index, gp_padr))
#macro M_ANYB	(mouse_check_button(mb_any) || mouse_check_button_pressed(mb_any) || mouse_check_button_released(mb_any) || mouse_wheel_down() || mouse_wheel_up())
#macro KBM_ANYB	(keyboard_check(vk_anykey) || keyboard_check_pressed(vk_anykey) || keyboard_check_released(vk_anykey) || M_ANYB)
#macro ANYB		(KBM_ANYB || GP_ANYB)

#endregion

#region Config

#region Settings

//Device Icons
#macro DVIC 4

//The index of the option of an setting in the settings menu
global.config = {
	
	show_dmg: 0,
	
	//Auto aim
	auto_aim: 1,
	
	//Language
	lang: 0,
}

//The kind of button to show in UI: Keyboard and Mouse, PlayStation, Xbox, Nintendo
global.buttons_kind = 0

//Determines which device the icons shown are from: Keyboard and Mouse || Gamepad
global.buttons_dev = 0

#endregion

#region Functions

///@func Fset_language()
///@desc Change the language
///@param {string} value value of the language in string
function Fset_language(_v)
{
	var _index = Flang_index(_v)
	
	if(global.config.lang == _index) exit
	
	global.config.lang = _index
	
	Fload_csv_translation()
}

#endregion

#endregion

#region Translation & localization

#region Variables

#macro LANGS_FOLDER	"langs\\"
#macro LANGS_DIR	working_directory+LANGS_FOLDER
#macro FILE_NAME	"*.csv"

///@func Fget_included_files([directory], [*string])
///@description Retorns a list of the wanted included files, you can specify the suffix || prefix
function Fget_included_files(_d = working_directory, _s = "*")
{
	//Creating list and wanted files
	var _fs = []
	var _fn = file_find_first(string(_d + _s), fa_none)
	
	//Adding the files into the list while still have files
	while(_fn != "")
	{
		//Adding files into the list
		array_push(_fs, _fn)
		
		//Going to the next file
		_fn = file_find_next()
	}
	
	file_find_close()
	
	return _fs
}

#endregion

#region Loading languages and texts

function Fload_languages()
{
	global.langs = {
	
			ids		: [],
			names	: [],
			prts	: [],
	}
	
	var _files = Fget_included_files(LANGS_DIR, FILE_NAME)
	
	for(var i = 0; i < array_length(_files); i++)
	{
		var _grid = load_csv(LANGS_FOLDER + _files[i])
	
		//Language ID
		array_push(global.langs.ids, string_copy(_files[i], 1, 4))
	
		//Language name
		array_push(global.langs.names, _grid[# 1, 0])
	
		//Language property
		array_push(global.langs.prts, _grid[# 1, ds_grid_height(_grid)-1])
	}
}
Fload_languages()

function Fload_csv_translation()
{
	global.game_texts = {}
	
	var _files = Fget_included_files(LANGS_DIR, FILE_NAME)
	
	if(array_length(_files) <= 0) exit
	
	global.lan_file = LANGS_FOLDER + _files[global.config.lang]
	
	var _grid = load_csv(global.lan_file)
	var _w = ds_grid_width(_grid)
	var _h = ds_grid_height(_grid)

	for(var i = 0; i < _h; i++)
	{
	    var _texts = []

	    for(var j = 1; j < _w; j++)
		{
	        _texts[j-1] = string_replace_all(_grid[# j, i], "[n]", "\n") 
	    }
	
	    global.game_texts[$ _grid[# 0, i]] = _texts
	}

	ds_grid_destroy(_grid)
	
	with(ob_game) Tmenus.satt()
}
Fload_csv_translation()

#endregion

#region Functions

///@func Fgametext(key, [val0], [val1]...)
function Fgametext(_key)
{
    var _arr = []
	
    for(var i = 1; i < argument_count; i++)
	{
        _arr[i-1] = argument[i]
    }
	
    var _keymap = global.game_texts[$ _key]

    if(is_array(_keymap))
	{
		return string_ext(_keymap[0], _arr)
    }
	else
	{
        return $"?{_key}?"
    }
}

///@func Fgametext_ext(key, arg_array)
function Fgametext_ext(_key, _array)
{
	var _keymap = global.game_texts[$ _key]

	if(is_array(_keymap))
	{
		return string_ext(_keymap[0], _array)
	}
	else
	{
	    return $"?{_key}?"
	}
}

///@func Fgametext_amount(key, number, [val0], [val1]...)
function Fgametext_amount(_k, _n)
{
	var _arr = []
	
    for(var i = 2; i < argument_count; i++)
	{
		array_push(_arr, argument[i])
    }
	
	var _var = ["one", "two", "few", "many", "other"]
	
	return Fgametext_ext(string("{0}_{1}", _k, _var[Ffind_num_variation(_n)]), _arr)
}

///@func Ffind_num_variation(number)
function Ffind_num_variation(_n)
{
	/*
		0 - "one" translation
		1 - "two" translation
		2 - "few" translation
		3 - "many" translation
		4 - "other" translation
	*/
	
	#region Finding values from Language Plural Rules
	
	var dec = string_delete(string(string_format(frac(_n), 0, 3)), 1, 2)
	for(var i = string_length(dec); i > 0; i--)
	{
		var _cchar_ant	= string_char_at(dec, i-1)
		var _cchar		= string_char_at(dec, i)
		var _cchar_prox	= string_char_at(dec, i+1)
		
		if(_cchar != "0") continue
		if((_cchar_ant != "0" && _cchar <= "0" && _cchar_prox <= "0") || (_cchar_ant <= "0" && _cchar <= "0" && _cchar_prox <= "0"))
		{
			dec = string_delete(dec, i, 1)
		}
	}
	
	//Integer value of _n
	var _i = floor(_n)
	
	//Number of fractional digits visible in _n
	var _v = frac(_n) > 0 ? string_length(frac(_n))-2 : 0
	
	//Number of fractional digits visible in _n, without leading zeros
	var _w	= string_length(dec)
	
	//Fractional digits visible in _n, with leading zeros, expressed as an integer
	var _f	= string_delete(string_format(frac(_n), 0, 3), 1, 2)
	
	//Fractional digits visible in _n, without leading zeros, expressed as an integer
	var _t	= dec
	
	#endregion
	
	switch(Slang_string(global.config.lang))
	{
		case "enUS":
		{
			return _n == 1 ? 0 : 3
			
			break
		}
		case "ptBR":
		{
			return _n == 1 ? 0 : 3
			
			break
		}
	}
}

///@func Flang_index(language_id)
///@desc Returns the language index value from a language string value | e.g.: get "enUS" return 0.
function Flang_index(_id)
{
	for(var i = 0; i < array_length(global.langs.ids); i++)
	{
		if(global.langs.ids[i] != _id) continue
		
		return i
	}
}

///@func Flang_string(language_index)
///@desc Returns the language string value from a language index value. | e.g.: get 0 return "enUS".
function Flang_string(_index)
{
	return global.langs.ids[_index]
}

#endregion

#endregion

#region Systems

#region Binds system

enum bdType
{
	hold,
	pressed,
	released,
	tam
}

enum gameBinds
{
	walkUp,
	walkDown,
	walkLeft,
	walkRight,
	shoot,
	tam
}

enum uiBinds
{
	select,
	cancel,
	tam
}

//Inputs array
global.inputs = {
	
	game : [
				[[ord("W"),		noone],		[gp_axislv,		-1]],
				[[ord("S"),		noone],		[gp_axislv,		1]],
				[[ord("A"),		noone],		[gp_axislh,		-1]],
				[[ord("D"),		noone],		[gp_axislh,		1]],
				[[mb_left,		noone],		[gp_shoulderr,	noone]],
	],
	
	ui : [
				[[mb_left,		noone],		[gp_face1,		noone]],		
				[[vk_escape,	noone],		[gp_face2,		noone]],	
	],
	
	backup : { game : [], ui : [] },
}

#region Backuping inputs

for(var i = 0; i < array_length(global.inputs.game); i++)
{
	var _k = global.inputs.game[i]
	
	array_push(global.inputs.backup.game, [[_k[0][0], _k[0][1]], [_k[1][0], _k[1][1]]])
}

for(var i = 0; i < array_length(global.inputs.ui); i++)
{
	var _k = global.inputs.ui[i]
	
	array_push(global.inputs.backup.ui, [[_k[0][0], _k[0][1]], [_k[1][0], _k[1][1]]])
}

#endregion

///@func Sgamepad_button()
///@desc Returns the actual pressioned gamepad button as [gp_input, gp_dir]
function Sgamepad_button()
{
	/*
		gp_face1				- 32769 INIT
		gp_stickl				- 32779
		gp_stickr				- 32780
		gp_axislh				- 32785 AXIS L H
		gp_axislv				- 32786 AXIS L V
		gp_axisrh				- 32787 AXIS R H
		gp_axisrv				- 32788 AXIS R V
		gp_extra6				- 32810 END
	*/
	
	for(var i = gp_face1; i < gp_extra6+1; i++)
	{
		if(!(gamepad_button_check(global.gamepad.index, i) || (i >= gp_axislh && i <= gp_axisrv && abs(gamepad_axis_value(global.gamepad.index, i)) > GPDZ))) continue
		
		return [i, sign(gamepad_axis_value(global.gamepad.index, i))]
	}
	
	return [0, 0]
}

///@func Sconvert_input()
///@desc Returns the wanted input as [kb_input, kb_dir] or [gp_input, gp_dir]
function Sconvert_input()
{
	switch(global.controller)
	{
		case controller.keyboard:
		{
			if(mouse_wheel_down() || mouse_wheel_up()) return ["mw", mouse_wheel_down() - mouse_wheel_up()]
			else if(keyboard_key > 0 || mouse_button > 0)
			{
				var _c = ord(keyboard_lastchar)
				return [keyboard_key > 0 ? (_c != 0 && _c != 13 && _c != 9 && _c < 37 && _c > 40 ? _c : keyboard_key) : mouse_button, noone]
			}
			
			break
		}
		case controller.gamepad:
		{
			var _gp = Sgamepad_button()
			
			if(_gp[0] > 0) return [_gp[0], _gp[1]]
			
			break
		}
	}
	
	return [0, 0]
}

///@func Fbind()
///@desc Returns a button_check of a bind
///@param {Array} bind	The array that represents a input, [[kb_input, kb_dir], [gp_input, gp_dir]]
///@param {Real} type	0 = Hold | 1 = Pressed | 2 = Released (Default: 0)
///@param {Real} bool	Defines if gamepad analogs will return boolean value or real (Default: true)
function Fbind(_in, _t = 0, _b = true)
{
	/*
		Foca na array de index igual ao controller usado no momento
		Backspace - 8
		Scape - 27
		Space - 32
	*/
	
	var _i = _in[global.controller]
	
	switch(global.controller)
	{
		case controller.keyboard:
		{
			if(_i[0] == "mw")				//Input is a mouse wheel bind
			{
				return _i[1] == 1 ? mouse_wheel_down() : mouse_wheel_up()
			}
			else if(_i[0] <= mb_side2)		//Input is a normal mouse bind
			{
				switch(_t)
				{
					case 0: return mouse_check_button(_i[0])
					case 1: return mouse_check_button_pressed(_i[0])
					case 2: return mouse_check_button_released(_i[0])
				}
			}
			else							//Input is a keyboard bind
			{
				switch(_t)
				{
					case 0: return keyboard_check(_i[0])
					case 1: return keyboard_check_pressed(_i[0])
					case 2: return keyboard_check_released(_i[0])
				}
			}
			
			break
		}
		case controller.gamepad:
		{
			if(_i[0] >= gp_axislh && _i[0] <= gp_axisrv)
			{
				if(_b) return _i[1] ? gamepad_axis_value(global.gamepad.index, _i[0]) > GPDZ : gamepad_axis_value(global.gamepad.index, _i[0]) < -GPDZ
				else 
				{
					var _v = gamepad_axis_value(global.gamepad.index, _i[0])
					
					if(_i[1]) return _v * (_v > GPDZ)
					else return abs(_v) * (_v < -GPDZ)
				}
			}
			else
			{
				switch(_t)
				{
					case 0: return gamepad_button_check(global.gamepad.index, _i[0]); break
					case 1: return gamepad_button_check_pressed(global.gamepad.index, _i[0]); break
					case 2: return gamepad_button_check_released(global.gamepad.index, _i[0]); break
				}
			}
			
			break
		}
	}
	
	return false
}

#endregion

#endregion

#region UI

//Roundness
#macro R 40

//Icon background color
#macro IBC make_color_rgb(66, 66, 66)

//Tier color
global.tc = [
				[ #000000, #2F2F2F],
				[ #000816, #353A41],
				[ #0E001E, #362E3F],
				[ #170001, #382829],
]

//Alpha increase
#macro ALINC .05

//Alpha min
#macro ALMIN .8

//Border gap
#macro BGA 25

//Second border gap
#macro BGS 16

#endregion

#region Player

enum statsList
{
	vigor,
	recovery,
	lifeSteal,
	damage,
	//meleeDamage,
	rangedDamage,
	elementalDamage,
	attackSpeed,
	attackCooldown,
	criticChance,
	criticDamage,
	trapDamage,
	range,
	armor,
	dodge,
	speed,
	luck,
	pickupRange,
	harvest,
	tam
}

global.stats_names = [
	
	"stats_pv",
	"stats_recovery",
	"stats_ls",
	"stats_dmg",
	//"stats_mdmg",
	"stats_rdmg",
	"stats_edmg",
	"stats_as",
	"stats_ac",
	"stats_cc",
	"stats_cdmg",
	"stats_tdmg",
	"stats_range",
	"stats_armor",
	"stats_dodge",
	"stats_speed",
	"stats_luck",
	"stats_pr",
	"stats_harvest",
]

global.player = {
	
	//Stats
	stats: array_create(statsList.tam, 0),
	
	//Level
	level: 0,
	
	//level to up
	ltu: 0,
	
	//Ammo
	ammo: 40,
	
	//Crystals (gold)
	crystals: 0,
	
	set_status: function()
	{
		//XP to level up
		xp = 100 + 50 * level
		
		//Health points
		hp = stats[statsList.vigor]
		
		//HP recovery
		recovery = max(1/(.2 * sign(stats[statsList.recovery]) + .09 * max(stats[statsList.recovery]-1, 0)), 0)
		
		//Life steal
		life_steal = min(.01 * stats[statsList.lifeSteal], 1)
		
		//Damage
		dmg = 1 + .01 * stats[statsList.damage]
		
		//Melee damage
		//melee = stats[statsList.meleeDamage]
		
		//Ranged damage
		ranged = stats[statsList.rangedDamage]
		
		//Elemental damage
		element = stats[statsList.elementalDamage]
		
		//Shoot cooldown
		shoot_time = 1 - .01 * stats[statsList.attackSpeed]
		
		//Attack cooldown
		cooldown = 1 - .01 * stats[statsList.attackCooldown]
		
		//Critic chance
		crit_cha = .01 * stats[statsList.criticChance]
		
		//Critic dmg
		crit_dmg = 2 + .01 * stats[statsList.criticDamage]
		
		//Trap damage
		trap = stats[statsList.trapDamage]
		
		//Atack range
		range = 600 + 3 * stats[statsList.range]
		
		//Armor
		armor = min(Fstat_root(0, 10, stats[statsList.armor], .2), 100)
		
		//Dodge
		dodge = .01 * stats[statsList.dodge]
		
		//Move speed
		move_spd = 1 + .01 * stats[statsList.speed]
		
		//Luck
		luck = 1 + .01 * stats[statsList.luck]
		
		//Pickup range
		pickup = 60 + 4 * stats[statsList.pickupRange]
		
		//harvest
		harvest = stats[statsList.harvest]
		
		with(ob_player)
		{
			show_debug_message(spd_max);
			chlamydia_applied = false;
			update_status();
		}
	},
}
global.player.stats[statsList.vigor] = 20
global.player.set_status()

#endregion

#region Enemies

global.enemies = {
	
	enemy: function(_hp, _dmg) constructor
	{
		hp	= _hp
		dmg = _dmg
	},
	
	setup: function()
	{
		test = new enemy(10, 3)
	}
}
global.enemies.setup()

#endregion

#region Items

enum tier
{
	I,
	II,
	III,
	IV,
	tam
}

global.tiers = ["I", "II", "III", "IV"]

enum itemsList
{
	halfPrice,
	immBf,
	spdLAcc,
	safe,
	tam
}

enum shopItem
{
	condom,
	tightWad,
	chasityBelt,
	titaniumLoop,
	tam
}

enum itemsInfo
{
	name,
	desc,
	tam
}

global.item_grid = ds_grid_create(itemsList.tam, itemsInfo.tam)

///@func Fitem(ID, name, desc)
function Fitem(_i, _n, _d)
{
	global.item_grid[# _i, itemsInfo.name] = _n
	global.item_grid[# _i, itemsInfo.desc] = _d
}

#endregion

#region Consumables

enum consuList
{
	water,
	coffe,
	lemonade,
	beer,
	tam
}

global.consu = [

	[.25,	.33,	.5,		1],
	[1,		.4,		.1,		.06],
]

function Fconsu_heal(_i)
{
	return global.consu[0][_i]
}

function Fconsu_rate(_i)
{
	return global.consu[1][_i]
}

#endregion

#region Debuffs

enum std {
    gonorrhea,
    hiv,
    herpes,
    chlamydia
}

function pick_random_std() 
{
    var all_stds = [std.chlamydia, std.gonorrhea, std.herpes, std.hiv];
    var available = [];

    for (var i = 0; i < array_length(all_stds); i++) 
    {
        if (!array_contains(current_stds, all_stds[i])) 
        {
            array_push(available, all_stds[i]);
        }
    }

    if (array_length(available) > 0) {
        var index = irandom(array_length(available) - 1);
        var chosen = available[index];
        show_debug_message("Chosen STD: " + string(chosen));
        return chosen;
    }
    else {
        show_debug_message("No STDs available");
        return -1;
    }
}

function apply_std(_type)
{
	with (ob_player)
	{
		if (!array_contains(current_stds, _type)) 
		{
	        array_push(current_stds, _type);

	        switch (_type) 
			{
	            case std.gonorrhea:
	                show_debug_message("Gonorrhea");
	                break;
	            case std.hiv:
	                show_debug_message("HIV");
					global.player.stats[statsList.recovery] = 0;
					global.player.set_status();
					ob_game.stats.satt = true;
	                break;
	            case std.herpes:
	                show_debug_message("Herpes");
					herpes_timer = irandom_range(5 * FR, 10 * FR);
	                break;
	            case std.chlamydia:
	                show_debug_message("Chlamydia");
	                break;
	        }
	    }
	}
}

#endregion

#region Upgrades

enum ugInfo
{
	stats,
	tam
}

#macro UGQTD (statsList.tam * tier.tam)

global.ug_grid = ds_grid_create(UGQTD, ugInfo.tam)

///@func Fupgrade(ID, stats, tier)
function Fupgrade(_i, _s, _t)
{
	global.ug_grid[# _i * tier.tam + _t, ugInfo.stats]	= _s
}

function Fug_info(_id, _in)
{
	return global.ug_grid[# _id, _in]
}

function Fug_tier(_id)
{
	return _id % tier.tam
}

function Fug_base(_id)
{
	return _id div tier.tam
}

function Fug_stats(_id)
{
	return global.stats_names[Fug_base(_id)]
}

function Fug_color(_id)
{
	return global.tc[Fug_tier(_id)]
}

#endregion

#region Shop

function buy_condom()
{
	with (ob_player)
	{
		condom_on = true;
	}
}

#endregion

#region Game

#macro FR 60

//global.delta_factor = 1

//#macro DELTA global.delta_factor

global.in_menu = true
global.in_transition = false

global.wave = -1
global.rest = false

global.lost = false

global.pause = false

///@func Fss(intensity)
function Fss(_i)
{
	with(ob_game) Tcam.ss_int = _i
}

///@func Fshow_v(value, [type], [stats], [length], [dir])
///@desc t: 0 (default) = dmg, 1 = critic, 2 = player, 3 = heal, 4 = money, 5 = stats
function Fshow_v(_v, _t, _s, _b = irandom_range(70, 80), _d = irandom_range(0, 359))
{
	with(instance_create_depth(x + lengthdir_x(_b, _d), y + lengthdir_y(_b, _d), depth, ob_counter))
	{
		v = _v
		type = _t
		stats = _s
	}
}

///@func Fspawn_consu(type)
function Fspawn_consu(_t)
{
	with(instance_create_depth(x, y, depth+1, ob_consu)) setup(_t)
}

function Fini()
{
	randomize()
	
	global.game = {
	
		width: room_width,
		height: room_height,
	}
	
	display_set_gui_size(global.game.width, global.game.height)
	
	instance_create_depth(0, 0, 0, ob_game)
	
	window_set_fullscreen(false)
	window_enable_borderless_fullscreen(false)
	
	#region Items
	
	//Fitem(itemsList.halfPrice,	"item_name_000", "item_desc_000")
	//Fitem(itemsList.immBf,		"item_name_001", "item_desc_001")
	//Fitem(itemsList.spdLAcc,	"item_name_002", "item_desc_002")	
	//Fitem(itemsList.safe, "safe_name", "safe_desc")
	
	// Cockrings
	Fitem(shopItem.tightWad, "Tight Wad", "Cuts the price of condoms in half.");
	Fitem(shopItem.chasityBelt, "Chasity Belt", "Grants immunity to “boner freeze” random status effect.");
	Fitem(shopItem.titaniumLoop, "Titanium Loop", "Increases maximum health by 20% but reduces movement speed by 10%.");
	Fitem(shopItem.condom, "Condom", "Protects against STDs (single-use).");
	
	#endregion
	
	#region Upgrades
	
	Fupgrade(statsList.vigor, 3, tier.I)
	Fupgrade(statsList.vigor, 6, tier.II)
	Fupgrade(statsList.vigor, 8, tier.III)
	Fupgrade(statsList.vigor, 12, tier.IV)
	
	Fupgrade(statsList.recovery, 2, tier.I)
	Fupgrade(statsList.recovery, 3, tier.II)
	Fupgrade(statsList.recovery, 4, tier.III)
	Fupgrade(statsList.recovery, 5, tier.IV)
	
	Fupgrade(statsList.lifeSteal, 1, tier.I)
	Fupgrade(statsList.lifeSteal, 2, tier.II)
	Fupgrade(statsList.lifeSteal, 3, tier.III)
	Fupgrade(statsList.lifeSteal, 4, tier.IV)
	
	Fupgrade(statsList.damage, 5, tier.I)
	Fupgrade(statsList.damage, 8, tier.II)
	Fupgrade(statsList.damage, 12, tier.III)
	Fupgrade(statsList.damage, 16, tier.IV)
	
	Fupgrade(statsList.rangedDamage, 1, tier.I)
	Fupgrade(statsList.rangedDamage, 2, tier.II)
	Fupgrade(statsList.rangedDamage, 3, tier.III)
	Fupgrade(statsList.rangedDamage, 4, tier.IV)
	
	Fupgrade(statsList.elementalDamage, 1, tier.I)
	Fupgrade(statsList.elementalDamage, 2, tier.II)
	Fupgrade(statsList.elementalDamage, 3, tier.III)
	Fupgrade(statsList.elementalDamage, 4, tier.IV)
	
	Fupgrade(statsList.attackSpeed, 5, tier.I)
	Fupgrade(statsList.attackSpeed, 10, tier.II)
	Fupgrade(statsList.attackSpeed, 15, tier.III)
	Fupgrade(statsList.attackSpeed, 20, tier.IV)
	
	Fupgrade(statsList.attackCooldown, 2, tier.I)
	Fupgrade(statsList.attackCooldown, 4, tier.II)
	Fupgrade(statsList.attackCooldown, 6, tier.III)
	Fupgrade(statsList.attackCooldown, 8, tier.IV)
	
	Fupgrade(statsList.criticChance, 3, tier.I)
	Fupgrade(statsList.criticChance, 5, tier.II)
	Fupgrade(statsList.criticChance, 7, tier.III)
	Fupgrade(statsList.criticChance, 9, tier.IV)
	
	Fupgrade(statsList.criticDamage, 2, tier.I)
	Fupgrade(statsList.criticDamage, 4, tier.II)
	Fupgrade(statsList.criticDamage, 6, tier.III)
	Fupgrade(statsList.criticDamage, 8, tier.IV)
	
	Fupgrade(statsList.trapDamage, 2, tier.I)
	Fupgrade(statsList.trapDamage, 3, tier.II)
	Fupgrade(statsList.trapDamage, 4, tier.III)
	Fupgrade(statsList.trapDamage, 5, tier.IV)
	
	Fupgrade(statsList.range, 15, tier.I)
	Fupgrade(statsList.range, 30, tier.II)
	Fupgrade(statsList.range, 45, tier.III)
	Fupgrade(statsList.range, 60, tier.IV)
	
	Fupgrade(statsList.armor, 1, tier.I)
	Fupgrade(statsList.armor, 2, tier.II)
	Fupgrade(statsList.armor, 3, tier.III)
	Fupgrade(statsList.armor, 4, tier.IV)
	
	Fupgrade(statsList.dodge, 3, tier.I)
	Fupgrade(statsList.dodge, 6, tier.II)
	Fupgrade(statsList.dodge, 9, tier.III)
	Fupgrade(statsList.dodge, 12, tier.IV)
	
	Fupgrade(statsList.speed, 3, tier.I)
	Fupgrade(statsList.speed, 6, tier.II)
	Fupgrade(statsList.speed, 9, tier.III)
	Fupgrade(statsList.speed, 12, tier.IV)
	
	Fupgrade(statsList.luck, 5, tier.I)
	Fupgrade(statsList.luck, 10, tier.II)
	Fupgrade(statsList.luck, 15, tier.III)
	Fupgrade(statsList.luck, 20, tier.IV)
	
	Fupgrade(statsList.pickupRange, 12, tier.I)
	Fupgrade(statsList.pickupRange, 24, tier.II)
	Fupgrade(statsList.pickupRange, 36, tier.III)
	Fupgrade(statsList.pickupRange, 48, tier.IV)
	
	Fupgrade(statsList.harvest, 5, tier.I)
	Fupgrade(statsList.harvest, 8, tier.II)
	Fupgrade(statsList.harvest, 10, tier.III)
	Fupgrade(statsList.harvest, 12, tier.IV)
	
	#endregion
	
	room_goto(rm_menu)
}

///@func Fgame_state(pause)
function Fgame_state(_p)
{
	if(global.pause == _p) exit
	
	global.pause = _p
	
	with(pa_mupa) image_speed = !global.pause
}

#endregion

#region Fonts

#region Creating fonts

//var _rmap = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~∎ÇçÑñÁáÀàÂâÃãÄäÉéÈèÊêËëÍíÌìÎîÏïÓóÒòÔôÕõÖöÚúÙùÛûÜü«»¡¿°№"

//global.f_regular		= font_add_sprite_ext(sp_f_regular,		 _rmap, true, 1)

#endregion

enum fontsInfo
{
	index,
	sep,
	tam,
}

enum fontsList
{
	regular,
	big,
	tam
}

enum fontsType
{
	normal,
	bold,
	tam
}

global.fonts = {
	
	index	: [[f_regular, f_regular_bold], [f_big, f_big_bold]],
	sep		: [34, 55],
}

///@func Ffont()
///@param {Real} font	The font to get the info
///@param {Real} [type]	The type of the font
function Ffont(_f, _t = fontsType.normal)
{
	return global.fonts.index[_f][_t]
}

///@func Ffont_spacing()
///@param {Real} font	The font to get the info
function Ffont_spacing(_f)
{
	return global.fonts.sep[_f]
}

#endregion

#region Draws

///@func Fdraw([font], [halign], [valign], [color], [alpha])
function Fdraw(_f = Ffont(fontsList.regular), _h = -1, _v = -1, _c = -1, _a = 1)
{
	//mod
	draw_set_font(_f);
	draw_set_halign(_h);
	draw_set_valign(_v);
	draw_set_color(_c);
	draw_set_alpha(_a);
}

#region Help bar

///@func Fdraw_help_bar()
///@description Draw a bar with bind instructions
///@param {Array}			array					Sprites and texts list. e.g. [txt, [[kb_spr, kb_sub], [gp_spr, gp_sub]]]
///@param {Real}			align					0 = Horizontal bar | 1 = Vertical bar
///@param {Real}			justify					0 = No adjust | 1 = Centered | 2 = Right
///@param {Real}			x						Bar X
///@param {Real}			y						Bar Y
///@param {Real}			[icon_sep]				Sep between sprite and text
///@param {Real}			[index_sep]				Sep between a bind and another
///@param {Constant.Color}	[text_color]			Text color
///@param {Constant.Color}	[sprite_color]			Sprite color
///@param {Real}			[alpha]					Bar alpha
function Fdraw_help_bar(_a, _al, _jf, _x, _y, _ss = 3, _bs = 6, _tc = c_white, _sc = c_white, _alp = 1)
{
	var _b = 0
	var _w = 1 //No 0 here to avoid DIV/0
	
	var _lh = draw_get_halign()
	var _lv = draw_get_valign()
	
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	
	//Finding width
	for(var i = 0; i < array_length(_a); i++)
	{
		var hp = _a[i], icon = Finput_icon(hp[1])
		
		_w += _al == 0 ? sprite_get_width(icon[0]) + _ss + string_width(Fgametext(hp[0])) + (i < array_length(_a)-1 ? _bs : -1) : max(sprite_get_height(icon[0]), string_height(hp[0])) + (i < array_length(_a)-1 ? _bs : -1)
	}
	
	_w = _jf == 1 ? _w div 2 : _w
	
	//Drawing
	for(var i = 0; i < array_length(_a); i++)
	{
		var xx = _x - (_jf ? _w : 0) + (_al ? 0 : _b)
		var yy = _y - (_jf && _al? _w : 0) + (_al ? _b : 0)
					
		var hp		= _a[i],
			icon	= Finput_icon(hp[1])
		
		//Icon
		draw_sprite_ext(icon[0], icon[1], xx, yy, 1, 1, 0, _sc, _alp)
					
		//Text
		Ftext(xx + sprite_get_width(icon[0]) + _ss, yy - 2, Fgametext(hp[0]), _tc, _alp)
		
		//Fixin buffer to the next index
		_b += _al == 0 ? sprite_get_width(icon[0]) + _ss + string_width(Fgametext(hp[0])) + _bs : max(sprite_get_height(icon[0]), string_height(hp[0])) + _bs
	}
	
	draw_set_halign(_lh)
	draw_set_valign(_lv)
}

#endregion

///@func Fdraw_attr(x, y, width, string, value, sprite_index, subimage, text_color, line_color, alpha)
function Fdraw_attr(_x, _y, _w, _st, _v, _sp, _sb, _tc, _lc, _a)
{
	var _m = .2
	
	draw_sprite(_sp, _sb, _x, _y)
	
	draw_set_halign(fa_right)
	
	Ftext(_x + _w + 1, _y + 2, _v, merge_color(BC, _tc, _m), _a)
	
	draw_set_halign(fa_left)
	
	if(string_width(_st) > 0) Ftext(_x + sprite_get_width(_sp) + 3, _y + 2, _st, merge_color(BC, _tc, _m), _a)
	
	Fline(_x, _y + sprite_get_width(_sp) + 1, _x + _w, _y + sprite_get_width(_sp) + 1,, _lc, _a)
}

///@func Frec(x, y, width, height, [color], [alpha], [outline])
function Frec(_x, _y, _w, _h, _c = c_white, _a = 1, _o = false)
{
	var _l = draw_get_alpha()
	
	draw_set_alpha(_a)
	
	draw_rectangle_color(_x, _y, _x + _w-1, _y + _h-1, _c, _c, _c, _c, _o)
	
	draw_set_alpha(_l)
}

///@func Froundrec(x, y, width, height, rad, [color], [alpha], [outline])
function Froundrec(_x, _y, _w, _h, _r, _c = c_white, _a = 1, _o = false)
{
	var _l = draw_get_alpha()
	
	draw_set_alpha(_a)
	
	draw_roundrect_color_ext(_x, _y, _x + _w, _y + _h, _r, _r, _c, _c, _o)
	
	draw_set_alpha(_l)
}

///@func Fline(x1, y1, [x1+]_x2, [y1+]y2, [width], [color], [alpha])
function Fline(_x1, _y1, _x2, _y2, _w = 1, _c = c_white, _a = 1)
{
	var _l = draw_get_alpha()
	
	draw_set_alpha(_a)
	
	draw_line_width_color(_x1-1, _y1, _x2-1, _y2, _w, _c, _c)
	
	draw_set_alpha(_l)
}

///@func Ftext(x, y, string, [color], [alpha], [sep], [width], [xscale], [yscale], [angle])
function Ftext(_x, _y, _st, _c = c_white, _al = 1, _sp = 0, _w = string_width(_st), _xs = 1, _ys = 1, _an = 0)
{
	draw_text_ext_transformed_color(_x, _y-3, _st, _sp, _w, _xs, _ys, _an, _c, _c, _c, _c, _al)
}

///@func Ftext_outline(x, y, string, [outline_width], [color], [outline_color], [alpha], [sep], [width], [xscale], [yscale], [angle])
function Ftext_outline(_x, _y, _st, _ow = 4, _c = c_white, _oc = c_black, _al = 1, _sp = 0, _w = string_width(_st), _xs = 1, _ys = 1, _an = 0)
{
	for(var i = 1; i < _ow + 1; i++)
	{
		draw_text_ext_transformed_color(_x - i, _y, _st, _sp, _w, _xs, _ys, _an, _oc, _oc, _oc, _oc, _al)
		draw_text_ext_transformed_color(_x + i, _y, _st, _sp, _w, _xs, _ys, _an, _oc, _oc, _oc, _oc, _al)
		draw_text_ext_transformed_color(_x, _y - i, _st, _sp, _w, _xs, _ys, _an, _oc, _oc, _oc, _oc, _al)
		draw_text_ext_transformed_color(_x, _y + i, _st, _sp, _w, _xs, _ys, _an, _oc, _oc, _oc, _oc, _al)
	}
	
	draw_text_ext_transformed_color(_x, _y, _st, _sp, _w, _xs, _ys, _an, _c, _c, _c, _c, _al)
}

#endregion

#region Utilities 

function Fget_saves_qtd()
{
	return 0
}

///@func Fclock_format([time])
function Fclock_format(_t)
{
	var s = floor(_t)
	s %= 60
	var m = floor(_t/60)
	m %= 60
	var h = floor((_t/60)/60)
	
	var sb = s < 10 ? "0" : ""
	var mb = m < 10 ? "0" : ""
	var hb = h < 10 ? "0" : ""
	
	return string("{0}{1}:{2}{3}:{4}{5}", hb, h, mb, m, sb, s)
}

///@func Fsprite_duration(sprite_index, [subimage_offset])
function Fsprite_duration(_s, _o = 0)
{
	return round((sprite_get_number(_s) - _o) * fps / sprite_get_speed(_s))
}

function Fcentralize_window()
{
	window_set_position(display_get_width() / 2 - window_get_width() / 2, display_get_height() / 2 - window_get_height() / 2)
}

///@func Fremove_unsi_spaces(string)
function Fremove_unsi_spaces(_str)
{
	#region Removing unsightly spaces in the middle
		
	for(var i = 1; i < string_length(_str); i++)
	{
		if(string_char_at(_str, i) != " ") continue
			
		if(string_char_at(_str, i+1) == " ") _str = string_delete(_str, i, 1)
	}
		
	#endregion
		
	#region Removing unsightly spaces in the start
		
	for(var i = 1; i < string_length(_str); i++)
	{
		if(string_char_at(_str, i) != " ") break
						
		_str = string_delete(_str, i, 1)
	}
		
	#endregion
		
	#region Removing unsightly spaces in the end
		
	for(var i = string_length(_str); i > 0; i--)
	{
		if(string_char_at(_str, i) != " ") break
						
		_str = string_delete(_str, i, 1)
	}
		
	#endregion
	
	return _str
}

///@func Fstat_root(base, scale, points, exponent)
function Fstat_root(_b, _s, _p, _e)
{
	//exponent < 1 grants diminishing returns, > 1 would be accelerated
    return _b + _s * power(abs(_p), _e)
}

///@func Fweight_random(list)
function Fweight_random(_l)
{
	var _w = 0
	
	for(var i = 0; i < array_length(_l); i++)
	{
		_w += _l[i]
	}
	
	_w = max(_w, 1)

	for(var i = 0; i < array_length(_l); i++)
	{
		_l[i] /= _w
	}
	
	var _r = random(1.0)
	var _t = 0
	var _a = 0

	for(var i = 0; i < array_length(_l); i++)
	{
		_a += _l[i]
		
		if(_r <= _a) { _t = i; break}
	}
	
	return _t
}

#endregion

#region Constructors

global.Cstats = function() constructor
{
	surf = noone
	satt = true
	
	alpha = 1
	
	sw = 402
	sh = global.game.height
	sx = global.game.width - sw - BGA
	sy = 0
	
	center = true
	
	main = function(_a)
	{
		#region	Visual
		
		if(!surface_exists(surf))
		{
			surf = surface_create(sw, sh)
			satt = true
		}
		else
		{
			var _alp = alpha * _a
			Fdraw(Ffont(fontsList.regular),,,, _alp)
			draw_surface(surf, sx, sy)
			Fdraw()
			
			if(satt)
			{
				surface_set_target(surf)
				draw_clear_alpha(c_black, 0)
				
				var _h = Ffont_spacing(fontsList.regular) * statsList.tam-6 + 206
				var _y = center ? sh div 2 - _h div 2 : 25
				
				Froundrec(0, _y, sw, _h, R, c_black, .7)
				
				var _y1 = _y + 154
				
				draw_set_font(Ffont(fontsList.big))
				var _t = Fgametext("term_stats")
				Ftext(sw div 2 - string_width(_t) div 2, _y + 14, _t)
				
				draw_set_font(Ffont(fontsList.regular))
				
				var _t = $"{Fgametext("stats_level")} {global.player.level}"
				Ftext(sw div 2 - string_width(_t) div 2, _y + 120, _t)
				
				var _l = [
					
					global.player.hp,
					global.player.recovery,
					global.player.life_steal,
					global.player.dmg,
					//global.player.melee,
					global.player.ranged,
					global.player.element,
					global.player.shoot_time,
					global.player.cooldown,
					global.player.crit_cha,
					global.player.crit_dmg,
					global.player.trap,
					global.player.range,
					global.player.armor,
					global.player.dodge,
					global.player.move_spd,
					global.player.luck,
					global.player.pickup,
					global.player.harvest,
				]
				
				for(var i = 0; i < statsList.tam; i++)
				{
					draw_set_halign(fa_left)
					
					Ftext(BGS, _y1 + (Ffont_spacing(fontsList.regular) * i), Fgametext(global.stats_names[i]))
					
					draw_set_halign(fa_right)
					
					Ftext(sw - BGS, _y1 + (Ffont_spacing(fontsList.regular) * i), $"{global.player.stats[i]} ({_l[i]})")
					//Ftext(sw - BGS, _y1 + (Ffont_spacing(fontsList.regular) * i), $"{global.player.stats[i]}")
				}
				
				surface_reset_target()
				satt = false
			}
			
			Fdraw()
		}
		
		#endregion
	}
}

#endregion

/// @param _to Target intensity (0.0–1.0)
/// @param _speed Lerp speed (e.g., 0.02 for slow, 0.1 for fast)
function fade_drunk(_to, _speed)
{
    global.drunk_target = clamp(_to, 0, 1);
    global.drunk_fade_speed = _speed;
}