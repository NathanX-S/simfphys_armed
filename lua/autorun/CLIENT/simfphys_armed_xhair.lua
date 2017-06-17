CreateClientConVar( "cl_simfphys_crosshair", "1", true, false )

local show_crosshair = false
cvars.AddChangeCallback( "cl_simfphys_crosshair", function( convar, oldValue, newValue ) show_crosshair = tonumber( newValue )~=0 end)
show_crosshair = GetConVar( "cl_simfphys_crosshair" ):GetBool()

local xhair = Material( "sprites/hud/v_crosshair1" )

local function DrawCircle( X, Y, radius )
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360 - segmentdist, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end

local function traceAndDrawCrosshair( startpos, endpos, vehicle, pod )
	local trace = util.TraceLine( {
		start = startpos,
		endpos = endpos,
		filter = function( e )
			local class = not e:GetClass():StartWith( "gmod_sent_vehicle_fphysics_wheel" )
			local collide = class and e ~= vehicle
			
			return collide
		end
	} )

	local hitpos = trace.HitPos
	
	local scr = hitpos:ToScreen()
	
	if scr.visible then
		local Type = pod:GetNWInt( "CrosshairType", 0 )
	
		surface.SetDrawColor( 240, 200, 0, 255 ) 
	
		if Type == 0 then
			surface.SetMaterial( xhair )
			surface.DrawTexturedRect( scr.x - 17,scr.y - 17, 34, 34)
			
		elseif Type == 1 then
			local X = scr.x
			local Y = scr.y
			
			local Scale = 0.75
			
			local scrW = ScrW() / 2
			local scrH = ScrH() / 2
			local Z = scrW * Scale
			
			local rOuter = scrW * 0.03 * Scale
			local rInner = scrW * 0.005 * Scale
			
			DrawCircle( X, Y, rOuter )
			DrawCircle( X, Y, rInner )
			
			surface.DrawLine( X + rOuter, Y, X + rOuter * 2, Y )
			surface.DrawLine( X - rOuter, Y, X - rOuter * 2, Y )
			surface.DrawLine( X, Y + rOuter, X, Y + rOuter * 2 )
			surface.DrawLine( X, Y - rOuter, X, Y - rOuter * 2)

			surface.SetDrawColor( 240, 200, 0, 20 ) 
			
			local Yaw = vehicle:GetPoseParameter( "turret_yaw" ) * 360 - 90
			
			local dX = math.cos( math.rad( -Yaw ) )
			local dY = math.sin( math.rad( -Yaw ) )
			local len = scrH * 0.04
			
			DrawCircle( scrW, scrH * 1.85, len )
			surface.DrawLine( scrW + dX * len, scrH * 1.85 + dY * len, scrW + dX * len * 3, scrH * 1.85 + dY * len * 3 )
			
			surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW - len * 1.25, scrH * 1.85 + len * 2 )
			surface.DrawLine( scrW + len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
			surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 - len * 2 )
			surface.DrawLine( scrW - len * 1.25, scrH * 1.85 + len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
			
		elseif Type == 2 then
			local X = scr.x
			local Y = scr.y
			
			local Scale = 0.75
			
			local scrW = ScrW() / 2
			local scrH = ScrH() / 2
			local Z = scrW * Scale
			
			local rOuter = scrW * 0.03 * Scale
			local rInner = scrW * 0.005 * Scale
			
			DrawCircle( X, Y, rOuter )
			DrawCircle( X, Y, rInner )
			
			surface.DrawLine( X + rOuter, Y, X + rOuter * 2, Y )
			surface.DrawLine( X - rOuter, Y, X - rOuter * 2, Y )
			surface.DrawLine( X, Y + rOuter, X, Y + rOuter * 2 )
			surface.DrawLine( X, Y - rOuter, X, Y - rOuter * 2)
			
			--surface.DrawLine( X, Y, X, Y + Z * 0.2)
			
			--surface.DrawLine( X, Y + Z * 0.05, X - Z * 0.015, Y + Z * 0.05)
			--surface.DrawLine( X, Y + Z * 0.1, X - Z * 0.015, Y + Z * 0.1)
			--surface.DrawLine( X, Y + Z * 0.15, X - Z * 0.015, Y + Z * 0.15)
			--surface.DrawLine( X, Y + Z * 0.2, X - Z * 0.015, Y + Z * 0.2)
			
			--surface.DrawLine( X, Y, X - Z * 0.015, Y + Z * 0.02)
			--surface.DrawLine( X, Y, X + Z * 0.015, Y + Z * 0.02)
			
			surface.SetDrawColor( 240, 200, 0, 120 ) 
			
			surface.DrawLine( X + Z * 0.3, Y - Z * 0.35, X + Z * 0.6, Y - Z * 0.35 )
			surface.DrawLine( X + Z * 0.6, Y - Z * 0.35, X + Z * 0.7, Y - Z * 0.25 )
			surface.DrawLine( X - Z * 0.3, Y - Z * 0.35, X - Z * 0.6, Y - Z * 0.35 )
			surface.DrawLine( X - Z * 0.6, Y - Z * 0.35, X - Z * 0.7, Y - Z * 0.25 )
			
			surface.DrawLine( X + Z * 0.3, Y + Z * 0.35, X + Z * 0.6, Y + Z * 0.35 )
			surface.DrawLine( X + Z * 0.6, Y + Z * 0.35, X + Z * 0.7, Y + Z * 0.25 )
			surface.DrawLine( X - Z * 0.3, Y + Z * 0.35, X - Z * 0.6, Y + Z * 0.35 )
			surface.DrawLine( X - Z * 0.6, Y + Z * 0.35, X - Z * 0.7, Y + Z * 0.25 )
			
			
			local Yaw = vehicle:GetPoseParameter( "turret_yaw" ) * 360 - 90
			
			local dX = math.cos( math.rad( -Yaw ) )
			local dY = math.sin( math.rad( -Yaw ) )
			local len = scrH * 0.04
			
			DrawCircle( scrW, scrH * 1.85, len )
			surface.DrawLine( scrW + dX * len, scrH * 1.85 + dY * len, scrW + dX * len * 3, scrH * 1.85 + dY * len * 3 )
			
			surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW - len * 1.25, scrH * 1.85 + len * 2 )
			surface.DrawLine( scrW + len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
			surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 - len * 2 )
			surface.DrawLine( scrW - len * 1.25, scrH * 1.85 + len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
			
		elseif Type == 3 then
			surface.SetMaterial( xhair )
			surface.DrawTexturedRect( scr.x - 17,scr.y - 17, 34, 34)
			
			local scrW = ScrW() / 2
			local scrH = ScrH() / 2
			
			local Yaw = vehicle:GetPoseParameter( "turret_yaw" ) * 360 - 90
			
			local dX = math.cos( math.rad( -Yaw ) )
			local dY = math.sin( math.rad( -Yaw ) )
			local len = scrH * 0.04
			
			DrawCircle( scrW, scrH * 1.85, len )
			surface.DrawLine( scrW + dX * len, scrH * 1.85 + dY * len, scrW + dX * len * 3, scrH * 1.85 + dY * len * 3 )
			
			surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW - len * 1.25, scrH * 1.85 + len * 2 )
			surface.DrawLine( scrW + len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
			surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 - len * 2 )
			surface.DrawLine( scrW - len * 1.25, scrH * 1.85 + len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
		end
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		draw.NoTexture()
	end
end

local function MixDirection( ang, direction )

	local Dir = ang:Forward()
	
	if direction.x == -1 then
		Dir = -ang:Forward()
		
	elseif direction.y == 1 then
		Dir = ang:Right()
		
	elseif direction.y == -1 then
		Dir = -ang:Right()
		
	elseif direction.z == 1 then
		Dir = ang:Up()
		
	elseif direction.z == -1 then
		Dir = -ang:Up()
	end
	
	return Dir
end

hook.Add( "HUDPaint", "simfphys_crosshair", function()
	
	if not show_crosshair then return end
	
	local ply = LocalPlayer()
	local veh = ply:GetVehicle()
	
	if not IsValid( veh ) then return end
	
	local HasCrosshair = veh:GetNWBool( "HasCrosshair" ) 
	
	if not HasCrosshair then return end
	
	local vehicle = veh.vehiclebase
	
	if not IsValid( vehicle ) then return end
	
	if ply:GetViewEntity() ~= ply then return end
	
	local ID = vehicle:LookupAttachment( veh:GetNWString( "Attachment" ) )
	if ID == 0 then return end
	
	local Attachment = vehicle:GetAttachment( ID )
	
	local startpos = Attachment.Pos
	local endpos = startpos + MixDirection( Attachment.Ang, veh:GetNWVector( "Direction" ) ) * 999999
	
	if veh:GetNWBool( "CalcCenterPos" ) then
		local attach_l = vehicle:LookupAttachment( veh:GetNWString( "Start_Left" ) )
		local attach_r = vehicle:LookupAttachment( veh:GetNWString( "Start_Right" ) )
		
		if attach_l > 0 and attach_r > 0 then
			local pos1 = vehicle:GetAttachment( attach_l ).Pos
			local pos2 = vehicle:GetAttachment( attach_r ).Pos
			
			startpos = (pos1 + pos2) / 2
			
			traceAndDrawCrosshair( startpos, endpos, vehicle, veh )
		end
		return
	end
	
	traceAndDrawCrosshair( startpos, endpos, vehicle, veh )
end )
