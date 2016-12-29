local light_table = {
	L_HeadLampPos = Vector(20.15,133,21),
	L_HeadLampAng = Angle(15,90,0),
	R_HeadLampPos = Vector(-54.51,133,21),
	R_HeadLampAng = Angle(15,90,0),
	
	L_RearLampPos = Vector(-62.74,-161,27),
	L_RearLampAng = Angle(40,-90,0),
	R_RearLampPos = Vector(28.33,-161,27),
	R_RearLampAng = Angle(40,-90,0),
	
	Headlight_sprites = { 
		Vector(29.15,133,21),
		Vector(-63.66,133,21),
	},
	Headlamp_sprites = { 
		Vector(20.15,133,21),
		Vector(-54.51,133,21),
	},
	Rearlight_sprites = {
		Vector(-62.74,-161,27),
		Vector(28.33,-161,27)
	},
	Brakelight_sprites = {
		Vector(-62.74,-161,27),
		Vector(28.33,-161,27)
	}
}
list.Set( "simfphys_lights", "conapc_armed", light_table)

local V = {
	Name = "HL2 APC",
	Model = "models/apc/apc.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Armed Vehicles",
	SpawnOffset = Vector(0,0,60),

	Members = {
		Mass = 4800,
		
		LightsTable = "conapc_armed",
		
		FrontWheelRadius = 32,
		RearWheelRadius = 32,
		
		SeatOffset = Vector(375,-13,-58),
		SeatPitch = 0,
		
		CustomMassCenter = Vector(0,0,-12),
		
		PassengerSeats = {
		},
		
		Attachments = {
			{
				model = "models/hunter/plates/plate075x105.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				pos = Vector(0.04-18,57.5-15,16.74),
				ang = Angle(90,-90,0),
				nosolid = true
			},
			{
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				pos = Vector(-25.08-18,91.34-15,29.46),
				ang = Angle(4.2,-109.19,68.43),
				nosolid = true
			},
			{
				pos = Vector(-24.63-18,77.76-15,8.65),
				ang = Angle(24.05,-12.81,-1.87),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(24.63-18,77.76-15,8.65),
				ang = Angle(24.05,-167.19,1.87),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-30.17-18,61.36-15,32.79),
				ang = Angle(-1.21,-92.38,-130.2),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(30.17-18,61.36-15,32.79),
				ang = Angle(-1.21,-87.62,130.2),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,72.92-15,40.54),
				ang = Angle(0,-180,0.79),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(25.08-18,91.34-15,29.46),
				ang = Angle(4.2,-70.81,-68.43),
				model = "models/hunter/plates/plate025x05.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-29.63-18,79.02-15,19.28),
				ang = Angle(90,-18,0),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(29.63-18,79.02-15,19.28),
				ang = Angle(90,-162,0),
				model = "models/hunter/plates/plate05x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,75.33-15,5.91),
				ang = Angle(0,0,0),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,98.02-15,35.74),
				ang = Angle(63,90,0),
				model = "models/hunter/plates/plate025x025.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			},
			{
				pos = Vector(-18,100.55-15,7.41),
				ang = Angle(90,-90,0),
				model = "models/hunter/plates/plate1x1.mdl",
				material = "lights/white",
				color = Color(0,0,0,255),
				nosolid = true
			}
		},
		
		Weapons = true,
		LimitView = true,
		--[[
		Weapons = {
			{
				weaponname = "simfphys_apcturret",
				pos = Vector(5,-35,0),
				ang = Angle(0,0,0),
				follow_eyeangles = false,
				attachment = "muzzle",
			}
		},
		]]--
		
		FrontHeight = 22,
		FrontConstant = 50000,
		FrontDamping = 4000,
		FrontRelativeDamping = 4000,
		
		RearHeight = 22,
		RearConstant = 50000,
		RearDamping = 4000,
		RearRelativeDamping = 4000,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 140,
		Efficiency = 1.25,
		GripOffset = -14,
		BrakePower = 120,
		
		IdleRPM = 750,
		LimitRPM = 5500,
		PeakTorque = 180,
		PowerbandStart = 1000,
		PowerbandEnd = 4500,
		Turbocharged = false,
		Supercharged = false,
		
		PowerBias = 0,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "simulated_vehicles/misc/Nanjing_loop.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/misc/m50.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 58,
		Sound_MidFadeOutRate = 0.476,
		
		Sound_High = "simulated_vehicles/misc/v8high2.wav",
		Sound_HighPitch = 1,
		Sound_HighVolume = 0.75,
		Sound_HighFadeInRPMpercent = 58,
		Sound_HighFadeInRate = 0.19,
		
		Sound_Throttle = "",
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		DifferentialGear = 0.27,
		Gears = {-0.09,0,0.09,0.18,0.28,0.35}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_conscriptapc_armed", V )

if (!armedAPCSTable) then -- lets make sure we dont ruin all the spawned vehicles when reloading this luafile
	armedAPCSTable = {}
end

hook.Add("PlayerSpawnedVehicle","simfphys_armedvehicles", function( ply, vehicle )
	if (vehicle:GetModel( ) == "models/apc/apc.mdl") then
		timer.Simple( 0.2, function()
			if (!IsValid(vehicle)) then return end
			if (vehicle:GetClass() == "gmod_sent_vehicle_fphysics_base" and vehicle.Weapons == true) then
				table.insert(armedAPCSTable, vehicle)
			end
		end)
	end
end)

local function HandleAPCWeapons( vehicle )
	local curtime = CurTime()
	local pod = vehicle:GetDriverSeat()
	local ply = pod:GetDriver()
	
	if (!IsValid(ply)) then return end

	local tr = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
		filter = {vehicle}
	} )
	local Aimpos = tr.HitPos
	
	local ID = vehicle:LookupAttachment( "muzzle" )
	local Attachment = vehicle:GetAttachment( ID )
	
	vehicle.wOldPos = vehicle.wOldPos or Vector(0,0,0)
	local deltapos = vehicle:GetPos() - vehicle.wOldPos
	vehicle.wOldPos = vehicle:GetPos()
	
	local a_forward = Attachment.Ang:Forward()
	local a_right = Attachment.Ang:Right()
	local a_up = Attachment.Ang:Up()
	
	local shootOrigin = Attachment.Pos + a_forward * 50 + a_right * 0 + a_up * 7 + deltapos * engine.TickInterval() 
	
	local Aimang = (Aimpos - shootOrigin):Angle()
	
	local Angles = vehicle:WorldToLocalAngles( Aimang - Angle(0,90,0) )
	Angles:Normalize() 
	Angles.y = (Angles.y / 180) * 120
	
	vehicle.sm_pp_yaw = vehicle.sm_pp_yaw and (vehicle.sm_pp_yaw + (Angles.y - vehicle.sm_pp_yaw) * 0.1) or 0
	vehicle:SetPoseParameter("vehicle_weapon_yaw", vehicle.sm_pp_yaw )
	--vehicle:SetPoseParameter("vehicle_weapon_pitch", Angles.p )
	
	local fire = ply:KeyDown( IN_ATTACK )
	
	if (!fire) then return end
	
	vehicle.NextShoot = vehicle.NextShoot or 0
	if ( vehicle.NextShoot > curtime ) then return end
	
	vehicle.NextShoot = curtime + 0.4
	
	vehicle:EmitSound("simulated_vehicles/weapons/apc_fire"..math.Round(math.random(1,4),0)..".wav")
	
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= Aimang:Forward()
		bullet.Spread 		= Vector(0.03,0.03,0)
		bullet.Tracer		= 0
		bullet.Force		= 10
		bullet.Damage		= 80
		bullet.HullSize		= 20
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetOrigin( tr.HitPos )
				util.Effect( "helicoptermegabomb", effectdata, true, true )
				
			util.BlastDamage( vehicle, ply, tr.HitPos, 150,80 )
			
			util.Decal("scorch", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal)
			
			sound.Play( Sound( "ambient/explosions/explode_1.wav" ), tr.HitPos, 75, 200, 1 )
		end
		bullet.Attacker 	= ply
	vehicle:FireBullets( bullet )
	
	if (vehicle.swapMuzzle) then
		vehicle.swapMuzzle = false
	else
		vehicle.swapMuzzle = true
	end
	local s_Pos = vehicle.swapMuzzle and -2 or 2
	
	local effectdata = EffectData()
		effectdata:SetOrigin( shootOrigin + a_up * s_Pos )
		effectdata:SetAngles( Attachment.Ang )
		effectdata:SetScale( 1.5 )
		util.Effect( "MuzzleEffect", effectdata, true, true )
		
	vehicle:GetPhysicsObject():ApplyForceOffset( -Aimang:Forward() * 120000, shootOrigin ) 
end

hook.Add("Think", "simfphys_weaponhandler", function()
	if (armedAPCSTable) then
		for k, v in pairs(armedAPCSTable) do
			if (IsValid(v)) then
				HandleAPCWeapons( v )
			else
				armedAPCSTable[k] = nil
			end
		end
	end
end)
