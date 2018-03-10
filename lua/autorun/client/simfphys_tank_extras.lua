local next_think = 0
local next_find = 0
local tigers = {}
local shermans = {}
local leopards = {}
local t90s = {}

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

local function LeopardsGetAll()
	local leopard_tanks = {}
	
	for i, ent in pairs( ents.FindByClass( "gmod_sent_vehicle_fphysics_base" ) ) do
		local class = ent:GetSpawn_List()
		
		if class == "sim_fphys_tank3" then
			table.insert(leopard_tanks, ent)
		end
	end
	
	return leopard_tanks 
end

local function T90sGetAll()
	local t90_tanks = {}
	
	for i, ent in pairs( ents.FindByClass( "gmod_sent_vehicle_fphysics_base" ) ) do
		local class = ent:GetSpawn_List()
		
		if class == "sim_fphys_tank4" then
			table.insert(t90_tanks, ent)
		end
	end
	
	return t90_tanks 
end

local function ShermansGetAll()
	local sherman_tanks = {}
	
	for i, ent in pairs( ents.FindByClass( "gmod_sent_vehicle_fphysics_base" ) ) do
		local class = ent:GetSpawn_List()
		
		if class == "sim_fphys_tank2" then
			table.insert(sherman_tanks, ent)
		end
	end
	
	return sherman_tanks
end


local function GetTrackPos( ent, div, smoother )
	local FT =  FrameTime()
	local spin_left = ent.trackspin_l and (-ent.trackspin_l / div) or 0
	local spin_right = ent.trackspin_r and (-ent.trackspin_r / div) or 0
	
	ent.sm_TrackDelta_L = ent.sm_TrackDelta_L and (ent.sm_TrackDelta_L + (spin_left - ent.sm_TrackDelta_L) * smoother) or 0
	ent.sm_TrackDelta_R = ent.sm_TrackDelta_R and (ent.sm_TrackDelta_R + (spin_right- ent.sm_TrackDelta_R) * smoother) or 0

	return {Left = ent.sm_TrackDelta_L,Right = ent.sm_TrackDelta_R}
end

local function UpdateTigerScrollTexture( ent )
	local id = ent:EntIndex()

	if not ent.wheel_left_mat then
		ent.wheel_left_mat = CreateMaterial("trackmat_"..id.."_left", "VertexLitGeneric", { ["$basetexture"] = "models/blu/track", ["$alphatest"] = "1", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end

	if not ent.wheel_right_mat then
		ent.wheel_right_mat = CreateMaterial("trackmat_"..id.."_right", "VertexLitGeneric", { ["$basetexture"] = "models/blu/track", ["$alphatest"] = "1", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end
	
	local TrackPos = GetTrackPos( ent, 100, 0.5 )
	
	ent.wheel_left_mat:SetVector("$translate", Vector(0,TrackPos.Left,0) )
	ent.wheel_right_mat:SetVector("$translate", Vector(0,TrackPos.Right,0) )

	ent:SetSubMaterial( 1, "!trackmat_"..id.."_left" ) 
	ent:SetSubMaterial( 2, "!trackmat_"..id.."_right" )
end

local function UpdateShermanScrollTexture( ent )
	local id = ent:EntIndex()

	if not ent.wheel_left_mat then
		ent.wheel_left_mat = CreateMaterial("s_trackmat_"..id.."_left", "VertexLitGeneric", { ["$basetexture"] = "models/blu/track_sherman", ["$alphatest"] = "1", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end

	if not ent.wheel_right_mat then
		ent.wheel_right_mat = CreateMaterial("s_trackmat_"..id.."_right", "VertexLitGeneric", { ["$basetexture"] = "models/blu/track_sherman", ["$alphatest"] = "1", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end
	
	local TrackPos = GetTrackPos( ent, 350, 0.25 )
	
	ent.wheel_left_mat:SetVector("$translate", Vector(0,TrackPos.Left,0) )
	ent.wheel_right_mat:SetVector("$translate", Vector(0,TrackPos.Right,0) )

	ent:SetSubMaterial( 1, "!s_trackmat_"..id.."_left" ) 
	ent:SetSubMaterial( 2, "!s_trackmat_"..id.."_right" )
end

local function UpdateLeopardScrollTexture( ent )
	local id = ent:EntIndex()

	if not ent.wheel_left_mat then
		ent.wheel_left_mat = CreateMaterial("l_trackmat_"..id.."_left", "VertexLitGeneric", { ["$basetexture"] = "models/blu/track_leopard", ["$alphatest"] = "1",  ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end

	if not ent.wheel_right_mat then
		ent.wheel_right_mat = CreateMaterial("l_trackmat_"..id.."_right", "VertexLitGeneric", { ["$basetexture"] = "models/blu/track_leopard", ["$alphatest"] = "1", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end
	
	local TrackPos = GetTrackPos( ent, 90, 0.25 )
	ent.wheel_left_mat:SetVector("$translate", Vector(0,TrackPos.Left,0) )
	ent.wheel_right_mat:SetVector("$translate", Vector(0,TrackPos.Right,0) )

	ent:SetSubMaterial( 4, "!l_trackmat_"..id.."_left" ) 
	ent:SetSubMaterial( 3, "!l_trackmat_"..id.."_right" )
end


local function UpdateT90ScrollTexture( ent )
	local id = ent:EntIndex()

	if not ent.wheel_left_mat then
		ent.wheel_left_mat = CreateMaterial("t90_trackmat_"..id.."_left", "VertexLitGeneric", { ["$basetexture"] = "models/blu/t90ms/t90ms_track_a_c", ["$alphatest"] = "1",  ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end

	if not ent.wheel_right_mat then
		ent.wheel_right_mat = CreateMaterial("t90_trackmat_"..id.."_right", "VertexLitGeneric", { ["$basetexture"] = "models/blu/t90ms/t90ms_track_a_c", ["$alphatest"] = "1", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end
	
	local TrackPos = GetTrackPos( ent, 80, 0.25 )
	ent.wheel_left_mat:SetVector("$translate", Vector(0,TrackPos.Left,0) )
	ent.wheel_right_mat:SetVector("$translate", Vector(0,TrackPos.Right,0) )

	ent:SetSubMaterial( 2, "!t90_trackmat_"..id.."_left" ) 
	ent:SetSubMaterial( 1, "!t90_trackmat_"..id.."_right" )
end

local function UpdateTracks()
	if tigers then
		for index, ent in pairs( tigers ) do
			if IsValid( ent ) then
				UpdateTigerScrollTexture( ent )
			else
				tigers[index] = nil
			end
		end
	end
	
	if shermans then
		for index, ent in pairs( shermans ) do
			if IsValid( ent ) then
				UpdateShermanScrollTexture( ent )
			else
				shermans[index] = nil
			end
		end
	end
	
	if leopards then
		for index, ent in pairs( leopards ) do
			if IsValid( ent ) then
				UpdateLeopardScrollTexture( ent )
			else
				leopards[index] = nil
			end
		end
	end
	
	if t90s then
		for index, ent in pairs( t90s ) do
			if IsValid( ent ) then
				UpdateT90ScrollTexture( ent )
			else
				t90s[index] = nil
			end
		end
	end
end

net.Receive( "simfphys_register_tank", function( length )
	local tank = net.ReadEntity()
	local type = net.ReadString()
	
	if not IsValid( tank ) then return end
	
	if type == "tiger" then
		table.insert(tigers, tank)
		
	elseif type == "sherman" then
		table.insert(shermans, tank)
		
	elseif type == "leopard" then
		table.insert(leopards, tank)
		
	elseif type == "t90ms" then
		table.insert(t90s, tank)
	end
end)

net.Receive( "simfphys_tank_do_effect", function( length )
	local tank = net.ReadEntity()
	if not IsValid( tank ) then return end
	
	local effect = net.ReadString()
	
	if effect == "Muzzle" then
		local effectdata = EffectData()
			effectdata:SetEntity( tank )
		util.Effect( "simfphys_tiger_muzzle", effectdata )
		
	elseif effect == "Muzzle2" then
		local effectdata = EffectData()
			effectdata:SetEntity( tank )
		util.Effect( "simfphys_sherman_muzzle", effectdata )
		
	elseif effect == "Muzzle3" then
		local effectdata = EffectData()
			effectdata:SetEntity( tank )
		util.Effect( "simfphys_leopard_muzzle", effectdata )
		
		
	elseif effect == "Explosion" then
		local effectdata = EffectData()
			effectdata:SetOrigin( net.ReadVector() )
		util.Effect( "simfphys_tankweapon_explosion", effectdata )
		
	elseif effect == "Explosion_small" then
		local effectdata = EffectData()
			effectdata:SetOrigin( net.ReadVector() )
		util.Effect( "simfphys_tankweapon_explosion_small", effectdata )
	end
end)

net.Receive( "simfphys_update_tracks", function( length )
	local tank = net.ReadEntity()
	if not IsValid( tank ) then return end
	
	tank.trackspin_r = net.ReadFloat() 
	tank.trackspin_l = net.ReadFloat() 
	
end)

local NumCycl = 0
hook.Add( "Think", "simfphys_manage_tanks", function()
	local curtime = CurTime()
	
	if curtime > next_find then
		next_find = curtime + 30
		
		NumCycl = NumCycl + 1
		if NumCycl == 1 then
			tigers = TigersGetAll()
			
		elseif NumCycl == 2 then
			shermans = ShermansGetAll()
		
		elseif NumCycl >= 3 then
			leopards = LeopardsGetAll()
			
		elseif NumCycl >= 4 then
			t90s = T90sGetAll()
			NumCycl = 0
		end
	end
	
	if curtime > next_think then
		next_think = curtime + 0.02
		
		UpdateTracks()
	end
end )
