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

local function GetTrackDelta( ent )
	ent.Old_Delta_L = ent.Old_Delta_L and ent.Old_Delta_L or 0
	ent.Old_Delta_R = ent.Old_Delta_R and ent.Old_Delta_R or 0
	
	ent.Pose_L = ent:GetPoseParameter( "spin_wheels_left" )
	ent.Pose_R = ent:GetPoseParameter( "spin_wheels_right" )
	
	ent.OldPose_L = ent.OldPose_L and ent.OldPose_L or ent.Pose_L
	ent.OldPose_R = ent.OldPose_R and ent.OldPose_R or ent.Pose_R
	
	local Pose_L_Delta = ent.OldPose_L - ent.Pose_L
	local Pose_R_Delta = ent.OldPose_R - ent.Pose_R
	
	if Pose_L_Delta > 0.5 or Pose_L_Delta < -0.5 then
		Pose_L_Delta = ent.Old_Delta_L
	end
	
	if Pose_R_Delta > 0.5 or Pose_R_Delta < -0.5 then
		Pose_R_Delta = ent.Old_Delta_R
	end
	
	ent.OldPose_L = ent.Pose_L
	ent.OldPose_R = ent.Pose_R
	
	ent.Old_Delta_L = Pose_L_Delta
	ent.Old_Delta_R = Pose_R_Delta
	
	return {Left = Pose_L_Delta, Right = Pose_R_Delta}
end

local function GetTrackPos( ent )
	local wheelsLocked = ent:GetHandBrakeEnabled()
	local TrackDelta = GetTrackDelta( ent )
	
	ent.sm_TrackDelta_L = wheelsLocked and 0 or (ent.sm_TrackDelta_L and (ent.sm_TrackDelta_L + (TrackDelta.Left * 3.2 - ent.sm_TrackDelta_L) * 0.5) or 0)
	ent.sm_TrackDelta_R = wheelsLocked and 0 or (ent.sm_TrackDelta_R and (ent.sm_TrackDelta_R + (TrackDelta.Right * 3.2 - ent.sm_TrackDelta_R) * 0.5) or 0)
	
	ent.TrackPos_L = ent.TrackPos_L and (ent.TrackPos_L + ent.sm_TrackDelta_L) or 0
	ent.TrackPos_R = ent.TrackPos_R and (ent.TrackPos_R + ent.sm_TrackDelta_R) or 0
	
	return {Left = ent.TrackPos_L,Right = ent.TrackPos_R}
end

local function UpdateScrollTexture( ent )
	local id = ent:EntIndex()

	if not ent.wheel_left_mat then
		ent.wheel_left_mat = CreateMaterial("trackmat_"..id.."_left", "VertexLitGeneric", { ["$basetexture"] = "models/blu/track", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end

	if not ent.wheel_right_mat then
		ent.wheel_right_mat = CreateMaterial("trackmat_"..id.."_right", "VertexLitGeneric", { ["$basetexture"] = "models/blu/track", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )
	end
	
	local TrackPos = GetTrackPos( ent )
	
	ent.wheel_left_mat:SetVector("$translate", Vector(0,TrackPos.Left,0) )
	ent.wheel_right_mat:SetVector("$translate", Vector(0,TrackPos.Right,0) )

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
