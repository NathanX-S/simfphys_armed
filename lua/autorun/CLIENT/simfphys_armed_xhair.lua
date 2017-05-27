CreateClientConVar( "cl_simfphys_crosshair", "1", true, false )

local show_crosshair = false
cvars.AddChangeCallback( "cl_simfphys_crosshair", function( convar, oldValue, newValue ) show_crosshair = tonumber( newValue )~=0 end)
show_crosshair = GetConVar( "cl_simfphys_crosshair" ):GetBool()

local xhair = Material( "sprites/hud/v_crosshair1" )

local function traceAndDrawCrosshair( startpos, endpos, vehicle )
	local trace = util.TraceLine( {
		start = startpos,
		endpos = endpos,
		filter = {vehicle}
	} )

	local hitpos = trace.HitPos
	
	local scr = hitpos:ToScreen()
	
	if scr.visible then
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
			
			traceAndDrawCrosshair( startpos, endpos, vehicle )
		end
		return
	end
	
	traceAndDrawCrosshair( startpos, endpos, vehicle )
end )
