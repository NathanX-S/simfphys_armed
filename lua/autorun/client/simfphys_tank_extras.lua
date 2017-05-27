local next_think = 0
local next_find = 0
local tigers = {}

local function TigersGetAll()
	local tiger_tanks = {}
	
	for i, ent in pairs( ents.FindByClass( "gmod_sent_vehicle_fphysics_base" ) ) do
		local class = ent:GetSpawn_List()
		
		if class == "sim_fphys_tank" then
			table.insert(tiger_tanks, ent)
		end
	end
	
	return tiger_tanks 
end

local function UpdateScrollTexture( ent )
	local id = ent:EntIndex()

	if not ent.wheel_left_mat then
		ent.wheel_left_mat = CreateMaterial("trackmat_"..id.."_left", "VertexLitGeneric", { ["$basetexture"] = "models/blu/track", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end

	if not ent.wheel_right_mat then
		ent.wheel_right_mat = CreateMaterial("trackmat_"..id.."_right", "VertexLitGeneric", { ["$basetexture"] = "models/blu/track", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end

	ent.wheel_left_mat:SetVector("$translate", Vector(0,-ent:GetPoseParameter( "spin_wheels_left" ) * 256 / 100,0) )
	ent.wheel_right_mat:SetVector("$translate", Vector(0,-ent:GetPoseParameter( "spin_wheels_right" ) * 256 / 100,0) )

	ent:SetSubMaterial( 1, "!trackmat_"..id.."_left" ) 
	ent:SetSubMaterial( 2, "!trackmat_"..id.."_right" )
end

local function UpdateTracks()
	if not tigers then return end
	
	for index, ent in pairs( tigers ) do
		if IsValid( ent ) then
			UpdateScrollTexture( ent )
		else
			tigers[index] = nil
		end
	end
end

net.Receive( "simfphys_register_tank", function( length )
	local tank = net.ReadEntity()
	
	if not IsValid( tank ) then return end
	
	table.insert(tigers, tank)
end)

net.Receive( "simfphys_tank_do_effect", function( length )
	local tank = net.ReadEntity()
	local effect = net.ReadString()
	
	if effect == "Muzzle" then
		local effectdata = EffectData()
			effectdata:SetEntity( tank )
		util.Effect( "simfphys_tiger_muzzle", effectdata )
		
	elseif effect == "Explosion" then
		local effectdata = EffectData()
			effectdata:SetOrigin( net.ReadVector() )
		util.Effect( "simfphys_explosion", effectdata )
	end
end)

hook.Add( "Think", "simfphys_getalltigers", function()
	local curtime = CurTime()
	
	if curtime > next_find then
		next_find = curtime + 60
		
		tigers = TigersGetAll()
	end
	
	if curtime > next_think then
		next_think = curtime + 0.02
		
		UpdateTracks()
	end
end )
