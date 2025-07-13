
depth = -y

if(!hit)
{
	if(instance_place(x, y, ob_player))
	{
		hit = instance_create_depth(ob_player.x, ob_player.y, depth, pa_hit)
		
		with(hit)
		{
			creator = other.id
			
			sk = 12
			
			dmg = other.dmg
		}
	}
}
else
{
	if(htimer[0]) htimer[0]--
	else
	{
		if(instance_exists(hit)) instance_destroy(hit)
		
		hit = noone
		
		htimer[0] = htimer[1]
	}
}
