
creator = noone

dmg = 0

sk = 0

hits = 0

attacked_list = ds_list_create()

main = function()
{
	
}

hit = function()
{
	if(!instance_exists(creator)) instance_destroy()
	
	var _l = ds_list_create(), _c = instance_place_list(x, y, pa_entity, _l, false)
	
	for(var i = 0; i < ds_list_size(_l); i++)
	{
		var _h = false
		
		for(var j = 0; j < ds_list_size(attacked_list); j++)
		{
			if(attacked_list[| j] != _l[| i]) continue
			
			_h = true
			
			break
		}
		
		if(_h || _l[| i].object_index == creator.object_index) continue
		
		_l[| i].apply_dmg(dmg, sk)
		
		ds_list_add(attacked_list, _l[| i])
		
		hits--
	}
	
	
	if(hits <= 0) instance_destroy()
}

