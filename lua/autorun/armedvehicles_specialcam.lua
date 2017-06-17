local function simfphyslerpView( ply, view )
	
	ply.simfphys_smooth_in = ply.simfphys_smooth_in or 1
	ply.simfphys_smooth_out = ply.simfphys_smooth_out or 1
	
	if ply:InVehicle() then
		if ply.simfphys_smooth_in < 0.999 then
			ply.simfphys_smooth_in = ply.simfphys_smooth_in + (1 - ply.simfphys_smooth_in) * FrameTime() * 5
			
			view.origin = LerpVector(ply.simfphys_smooth_in, ply.simfphys_eyepos_in, view.origin )
			view.angles = LerpAngle(ply.simfphys_smooth_in, ply.simfphys_eyeang_in, view.angles )
		end
		
		local vehicle = ply:GetVehicle()
		if IsValid(vehicle) then
			ply.simfphys_eyeang_out = view.angles
			ply.simfphys_eyepos_out = view.origin
		end
	else
		if ply.simfphys_smooth_out < 0.999 then
			ply.simfphys_smooth_out = ply.simfphys_smooth_out + (1 - ply.simfphys_smooth_out) * FrameTime() * 5
			
			view.origin = LerpVector(ply.simfphys_smooth_out, ply.simfphys_eyepos_out, ply:GetShootPos() )
			view.angles = LerpAngle(ply.simfphys_smooth_out, ply.simfphys_eyeang_out, ply:EyeAngles() )
		end
		
		ply.simfphys_eyeang_in = view.angles
		ply.simfphys_eyepos_in = view.origin
	end
	
	ply.shootpos = view.origin
	ply.shootang = view.angles
	
	return view
end

hook.Add( "CalcView", "simfphys_gunner_view", function( ply, pos, ang )
	if not IsValid( ply ) or not ply:Alive() or not ply:InVehicle() or ply:GetViewEntity() ~= ply then return end
	
	local Vehicle = ply:GetVehicle()
	
	if not IsValid( Vehicle ) then return end
	if not Vehicle:GetNWBool( "simfphys_SpecialCam" ) then return end
	
	local view = {
		origin = pos,
		drawviewer = false,
	}
	
	if Vehicle:GetNWBool( "SpecialCam_LocalAngles" ) then
		view.angles = ply:EyeAngles()
	else
		view.angles = Vehicle:LocalToWorldAngles( ply:EyeAngles() )
	end
	
	if Vehicle.GetThirdPersonMode == nil or ply:GetViewEntity() ~= ply then
		return
	end
	
	ply.simfphys_smooth_out = 0
	
	local offset = Vehicle:GetNWVector( "SpecialCam_Thirdperson" )
	
	if not Vehicle:GetThirdPersonMode() then
		local offset = Vehicle:GetNWVector( "SpecialCam_Firstperson" )
		
		view.origin = view.origin + Vehicle:GetForward() * offset.x + Vehicle:GetRight() * offset.y + Vehicle:GetUp() * offset.z
		
		return simfphyslerpView( ply, view )
	end
	
	view.origin = view.origin + Vehicle:GetForward() * offset.x + Vehicle:GetRight() * offset.y + Vehicle:GetUp() * offset.z
	
	local mn, mx = Vehicle:GetRenderBounds()
	local radius = ( mn - mx ):Length()
	local radius = radius + radius * Vehicle:GetCameraDistance()

	local TargetOrigin = view.origin + ( view.angles:Forward() * -radius )
	local WallOffset = 4

	local tr = util.TraceHull( {
		start = view.origin,
		endpos = TargetOrigin,
		filter = function( e )
			local c = e:GetClass()
			local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" )
			return collide
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )

	view.origin = tr.HitPos
	view.drawviewer = true

	if tr.Hit and not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end
	
	return simfphyslerpView( ply, view )
end )
