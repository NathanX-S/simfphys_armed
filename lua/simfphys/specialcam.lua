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
	if not Vehicle:GetNWBool( "IsGunnerSeat" ) then return end
	
	if Vehicle:GetNWBool( "IsAPCSeat" ) then
		pos = pos + Vehicle:GetUp() * 25
	elseif Vehicle:GetNWBool( "IsTankSeat" ) then
		pos = pos + Vehicle:GetUp() * 50
	end
	
	local view = {
		origin = pos,
		angles = Vehicle:LocalToWorldAngles( ply:EyeAngles() ),
		drawviewer = false,
	}
	
	if ( Vehicle.GetThirdPersonMode == nil || ply:GetViewEntity() != ply ) then
		return
	end
	
	ply.simfphys_smooth_out = 0
	
	if ( !Vehicle:GetThirdPersonMode() ) then
		view.origin = view.origin + Vehicle:GetUp() * 5 - Vehicle:GetRight() * 9
		return simfphyslerpView( ply, view )
	end
	
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
			return !c:StartWith( "prop_physics" ) &&!c:StartWith( "prop_dynamic" ) && !c:StartWith( "prop_ragdoll" ) && !e:IsVehicle() && !c:StartWith( "gmod_" ) && !c:StartWith( "player" )
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )

	view.origin = tr.HitPos
	view.drawviewer = true

	if ( tr.Hit && !tr.StartSolid) then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end
	
	return simfphyslerpView( ply, view )
end )
