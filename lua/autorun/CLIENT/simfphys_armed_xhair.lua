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
		filter = {vehicle}
	} )

	local hitpos = trace.HitPos
	
	local scr = hitpos:ToScreen()
	
	if scr.visible then
		--[[
		local X = scr.x
		local Y = scr.y
		
		surface.SetDrawColor( 50, 200, 50, 200 )
		
		local Scale = pod:GetThirdPersonMode() and 0.35 or 0.75
		
		local scrW = ScrW() / 2
		local Z = scrW * Scale
		
		local rOuter = scrW * 0.03 * Scale
		local rInner = scrW * 0.005 * Scale
		
		DrawCircle( X, Y, rOuter )
		DrawCircle( X, Y, rInner )
		
		surface.DrawLine( X + rOuter, Y, X + rOuter * 2, Y )
		surface.DrawLine( X - rOuter, Y, X - rOuter * 2, Y )
		surface.DrawLine( X, Y + rOuter, X, Y + rOuter * 2 )
		surface.DrawLine( X, Y - rOuter, X, Y - rOuter * 2)
		
		surface.DrawLine( X + Z * 0.2, Y, X + Z * 0.5, Y)
		surface.DrawLine( X - Z * 0.2, Y, X - Z * 0.5, Y)
		
		surface.DrawLine( X + Z * 0.3, Y - Z * 0.35, X + Z * 0.6, Y - Z * 0.35 )
		surface.DrawLine( X + Z * 0.6, Y - Z * 0.35, X + Z * 0.7, Y - Z * 0.25 )
		surface.DrawLine( X - Z * 0.3, Y - Z * 0.35, X - Z * 0.6, Y - Z * 0.35 )
		surface.DrawLine( X - Z * 0.6, Y - Z * 0.35, X - Z * 0.7, Y - Z * 0.25 )
		
		surface.DrawLine( X + Z * 0.3, Y + Z * 0.35, X + Z * 0.6, Y + Z * 0.35 )
		surface.DrawLine( X + Z * 0.6, Y + Z * 0.35, X + Z * 0.7, Y + Z * 0.25 )
		surface.DrawLine( X - Z * 0.3, Y + Z * 0.35, X - Z * 0.6, Y + Z * 0.35 )
		surface.DrawLine( X - Z * 0.6, Y + Z * 0.35, X - Z * 0.7, Y + Z * 0.25 )
		]]--
		surface.SetMaterial( xhair )
		surface.SetDrawColor( 255, 235, 0, 255 ) 
		surface.DrawTexturedRect( scr.x - 17,scr.y - 17, 34, 34)
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
