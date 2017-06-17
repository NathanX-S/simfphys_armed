local sherman_susdata = {}
for i = 1,6 do
	sherman_susdata[i] = { 
		attachment = "vehicle_suspension_l_"..i,
		poseparameter = "suspension_left_"..i,
	}
	
	local ir = i + 6
	sherman_susdata[ir] = { 
		attachment = "vehicle_suspension_r_"..i,
		poseparameter = "suspension_right_"..i,
	}
end

local function hmg_fire(ply,vehicle,shootOrigin,shootDirection)

	vehicle:EmitSound("sherman_fire_mg")
	
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin + shootDirection * 50
		bullet.Dir 			= shootDirection
		bullet.Spread 		= Vector(0,0,0)
		bullet.Tracer		= 0
		bullet.TracerName	= "simfphys_tracer"
		bullet.Force		= 12
		bullet.Damage		= 9
		bullet.HullSize		= 3
		bullet.Attacker 	= ply
		bullet.IgnoreEntity = vehicle.Wheels[2]
		
		bullet.Callback = function(att, tr, dmginfo)
			if tr.Entity ~= Entity(0) then
				if simfphys.IsCar( tr.Entity ) then
					local effectdata = EffectData()
						effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
						effectdata:SetNormal( tr.HitNormal )
					util.Effect( "stunstickimpact", effectdata, true, true )
				
					sound.Play( Sound( "weapons/fx/rics/ric"..math.random(1,5)..".wav" ), tr.HitPos, 60)
				end
			end
		end
		
	vehicle:FireBullets( bullet )
end

local function mg_fire(ply,vehicle,shootOrigin,shootDirection)

	vehicle:EmitSound("tiger_fire_mg")
	
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin + shootDirection * 50
		bullet.Dir 			= shootDirection
		bullet.Spread 		= Vector(0,0,0)
		bullet.Tracer		= 2
		bullet.TracerName	= "simfphys_tracer"
		bullet.Force		= 12
		bullet.Damage		= 30
		bullet.HullSize		= 5
		bullet.Attacker 	= ply
		bullet.IgnoreEntity = vehicle.Wheels[2]
		
		bullet.Callback = function(att, tr, dmginfo)
			if tr.Entity ~= Entity(0) then
				if simfphys.IsCar( tr.Entity ) then
					local effectdata = EffectData()
						effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
						effectdata:SetNormal( tr.HitNormal )
					util.Effect( "stunstickimpact", effectdata, true, true )
				
					sound.Play( Sound( "weapons/fx/rics/ric"..math.random(1,5)..".wav" ), tr.HitPos, 60)
				end
			end
		end
		
	vehicle:FireBullets( bullet )
end

local function cannon_fire(ply,vehicle,shootOrigin,shootDirection)
	vehicle:EmitSound("sherman_fire")
	vehicle:EmitSound("sherman_reload")
	
	net.Start( "simfphys_tank_do_effect" )
		net.WriteEntity( vehicle )
		net.WriteString( "Muzzle2" )
	net.Broadcast()
	
	vehicle:GetPhysicsObject():ApplyForceOffset( -shootDirection * 300000, shootOrigin ) 
	
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= shootDirection
		bullet.Spread 		= Vector(0,0,0)
		bullet.Tracer		= 0
		bullet.TracerName	= "simfphys_tracer"
		bullet.Force		= 6000
		bullet.Damage		= 1000
		bullet.HullSize		= 8
		bullet.Attacker 		= ply
		bullet.IgnoreEntity  	= vehicle
		bullet.Callback = function(att, tr, dmginfo)
			
			net.Start( "simfphys_tank_do_effect" )
				net.WriteEntity( vehicle )
				net.WriteString( "Explosion_small" )
				net.WriteVector( tr.HitPos )
			net.Broadcast()
			
			util.BlastDamage( vehicle, ply, tr.HitPos,200,50)
			
			util.Decal("scorch", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal)
			
			if tr.Entity ~= Entity(0) then
				if simfphys.IsCar( tr.Entity ) then
					local effectdata = EffectData()
						effectdata:SetOrigin( tr.HitPos + shootDirection * tr.Entity:BoundingRadius() )
						effectdata:SetNormal( shootDirection * 10 )
					util.Effect( "manhacksparks", effectdata, true, true )
					
					local effectdata = EffectData()
						effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
						effectdata:SetNormal( tr.HitNormal )
					util.Effect( "manhacksparks", effectdata, true, true )
				
					sound.Play( Sound( "doors/vent_open"..math.random(1,3)..".wav" ), tr.HitPos, 140)
				else
					sound.Play( Sound( "ambient/explosions/explode_1.wav" ), tr.HitPos + tr.HitNormal, 75, 200, 1 )
				end
			else
				sound.Play( Sound( "ambient/explosions/explode_1.wav" ), tr.HitPos + tr.HitNormal, 75, 200, 1 )
			end
		end
		
	vehicle:FireBullets( bullet )
end

function simfphys.weapon:ValidClasses()
	
	local classes = {
		"sim_fphys_tank2"
	}
	
	return classes
end

function simfphys.weapon:Initialize( vehicle )
	net.Start( "simfphys_register_tank" )
		net.WriteEntity( vehicle )
		net.WriteString( "sherman" )
	net.Broadcast()
	
	simfphys.RegisterCrosshair( vehicle:GetDriverSeat(), { Direction = Vector(0,0,1),Attachment = "turret_cannon", Type = 2 } )
	simfphys.RegisterCamera( vehicle:GetDriverSeat(), Vector(20,60,65), Vector(20,60,65), true )
	
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end

	simfphys.RegisterCrosshair( vehicle.pSeat[1] , { Attachment = "machinegun", Type = 1 } )
	simfphys.RegisterCamera( vehicle.pSeat[1], Vector(0,-40,5), Vector(0,-40,50), true )
	
	
	timer.Simple( 1, function()
		if not IsValid( vehicle ) then return end
		if not vehicle.VehicleData["filter"] then print("[simfphys Armed Vehicle Pack] ERROR:TRACE FILTER IS INVALID. PLEASE UPDATE SIMFPHYS BASE") return end
		
		vehicle.WheelOnGround = function( ent )
			ent.FrontWheelPowered = ent:GetPowerDistribution() ~= 1
			ent.RearWheelPowered = ent:GetPowerDistribution() ~= -1
			
			for i = 1, table.Count( ent.Wheels ) do
				local Wheel = ent.Wheels[i]		
				if IsValid( Wheel ) then
					local dmgMul = Wheel:GetDamaged() and 0.5 or 1
					local surfacemul = simfphys.TractionData[Wheel:GetSurfaceMaterial():lower()]
					
					ent.VehicleData[ "SurfaceMul_" .. i ] = (surfacemul and math.max(surfacemul,0.001) or 1) * dmgMul
					
					local WheelPos = ent:LogicWheelPos( i )
					
					local WheelRadius = WheelPos.IsFrontWheel and ent.FrontWheelRadius or ent.RearWheelRadius
					local startpos = Wheel:GetPos()
					local dir = -ent.Up
					local len = WheelRadius + math.Clamp(-ent.Vel.z / 50,2.5,6)
					local HullSize = Vector(WheelRadius,WheelRadius,0)
					local tr = util.TraceHull( {
						start = startpos,
						endpos = startpos + dir * len,
						maxs = HullSize,
						mins = -HullSize,
						filter = ent.VehicleData["filter"]
					} )
					
					local onground = self:IsOnGround( vehicle ) and 1 or 0
					Wheel:SetOnGround( onground )
					ent.VehicleData[ "onGround_" .. i ] = onground
					
					if tr.Hit then
						Wheel:SetSpeed( Wheel.FX )
						Wheel:SetSkidSound( Wheel.skid )
						Wheel:SetSurfaceMaterial( util.GetSurfacePropName( tr.SurfaceProps ) )
					end
				end
			end
			
			local FrontOnGround = math.max(ent.VehicleData[ "onGround_1" ],ent.VehicleData[ "onGround_2" ])
			local RearOnGround = math.max(ent.VehicleData[ "onGround_3" ],ent.VehicleData[ "onGround_4" ])
			
			ent.DriveWheelsOnGround = math.max(ent.FrontWheelPowered and FrontOnGround or 0,ent.RearWheelPowered and RearOnGround or 0)
		end
	end)
end

function simfphys.weapon:Think( vehicle )
	if not IsValid( vehicle ) or not vehicle:IsInitialized() then return end
	
	vehicle.wOldPos = vehicle.wOldPos or Vector(0,0,0)
	local deltapos = vehicle:GetPos() - vehicle.wOldPos
	vehicle.wOldPos = vehicle:GetPos()
	
	local handbrake = vehicle:GetHandBrakeEnabled()
	
	self:UpdateSuspension( vehicle )
	self:DoWheelSpin( vehicle )
	self:ControlTurret( vehicle, deltapos )
	self:ControlMachinegun( vehicle, deltapos )
	self:ControlTrackSounds( vehicle, handbrake )
	self:ModPhysics( vehicle, handbrake )
end

function simfphys.weapon:AimMachinegun( ply, vehicle, pod )	
	if not IsValid( pod ) then return end

	local Aimang = pod:WorldToLocalAngles( ply:EyeAngles() )
	
	local Angles = vehicle:WorldToLocalAngles( Aimang )
	Angles:Normalize()
	
	local TargetPitch = Angles.p
	local TargetYaw = Angles.y
	
	vehicle:SetPoseParameter("machinegun_yaw", TargetYaw )
	vehicle:SetPoseParameter("machinegun_pitch", TargetPitch )
end

function simfphys.weapon:ControlMachinegun( vehicle, deltapos )

	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end
	
	local pod = vehicle.pSeat[1]
	
	if not IsValid( pod ) then return end
	
	local ply = pod:GetDriver()
	
	if not IsValid( ply ) then return end
	
	self:AimMachinegun( ply, vehicle, pod )
	
	local ID = vehicle:LookupAttachment( "machinegun" )
	local Attachment = vehicle:GetAttachment( ID )

	local shootOrigin = Attachment.Pos + deltapos * engine.TickInterval()
	
	local fire = ply:KeyDown( IN_ATTACK )

	if fire then
		self:Attack( vehicle, ply, shootOrigin, Attachment, ID )
	end
end

function simfphys.weapon:ControlTurret( vehicle, deltapos )
	local pod = vehicle:GetDriverSeat()
	
	if not IsValid( pod ) then return end
	
	local ply = pod:GetDriver()
	
	if not IsValid( ply ) then return end
	
	local ID = vehicle:LookupAttachment( "turret_cannon" )
	local Attachment = vehicle:GetAttachment( ID )
	
	self:AimCannon( ply, vehicle, pod, Attachment )
	
	local shootOrigin = Attachment.Pos + deltapos * engine.TickInterval()
	
	local fire = ply:KeyDown( IN_ATTACK )
	local fire2 = ply:KeyDown( IN_ATTACK2 )

	if fire then
		self:PrimaryAttack( vehicle, ply, shootOrigin, Attachment )
	end
	
	if fire2 then
		self:SecondaryAttack( vehicle, ply, shootOrigin )
	end
end

function simfphys.weapon:PrimaryAttack( vehicle, ply, shootOrigin, Attachment )
	if not self:CanPrimaryAttack( vehicle ) then return end
	
	local shootDirection = Attachment.Ang:Up()
	
	cannon_fire( ply, vehicle, shootOrigin + shootDirection * 80, shootDirection )
	
	self:SetNextPrimaryFire( vehicle, CurTime() + 3.5 )
end

function simfphys.weapon:Attack( vehicle, ply, shootOrigin, Attachment, ID )
	
	if not self:CanAttack( vehicle ) then return end
	
	local effectdata = EffectData()
		effectdata:SetOrigin( shootOrigin )
		effectdata:SetAngles( Attachment.Ang )
		effectdata:SetEntity( vehicle )
		effectdata:SetAttachment( ID )
		effectdata:SetScale( 4 )
	util.Effect( "CS_MuzzleFlash", effectdata, true, true )
	
	local shootDirection = Attachment.Ang:Forward()
	
	mg_fire( ply, vehicle, shootOrigin + shootDirection * 40, shootDirection )
	
	self:SetNextFire( vehicle, CurTime() + 0.15 )
end

function simfphys.weapon:CanAttack( vehicle )
	vehicle.NextShoot3 = vehicle.NextShoot3 or 0
	return vehicle.NextShoot3 < CurTime()
end

function simfphys.weapon:SetNextFire( vehicle, time )
	vehicle.NextShoot3 = time
end

function simfphys.weapon:AimCannon( ply, vehicle, pod, Attachment )	
	if not IsValid( pod ) then return end

	local Aimang = pod:WorldToLocalAngles( ply:EyeAngles() )
	
	local Angles = vehicle:WorldToLocalAngles( Aimang )
	Angles:Normalize()
	
	vehicle.sm_dir  = vehicle.sm_dir or Vector(0,0,0)
	
	local L_Right = Angle(0,Aimang.y,0):Right()
	local La_Right = Angle(0,Attachment.Ang.y,0):Right()
	local AimRate = 40
	local Yaw_Diff = math.Clamp( math.acos( math.Clamp( L_Right:Dot( La_Right ) ,-1,1) ) * (180 / math.pi) - 90,-AimRate,AimRate )
	
	local TargetPitch = Angles.p
	local TargetYaw = vehicle.sm_dir:Angle().y - Yaw_Diff
	
	vehicle.sm_dir = vehicle.sm_dir + (Angle(0,TargetYaw,0):Forward() - vehicle.sm_dir) * 0.05
	vehicle.sm_pitch = vehicle.sm_pitch and (vehicle.sm_pitch + (TargetPitch - vehicle.sm_pitch) * 0.05) or 0
	
	vehicle:SetPoseParameter("turret_yaw", vehicle.sm_dir:Angle().y )
	vehicle:SetPoseParameter("turret_pitch", vehicle.sm_pitch )
end

function simfphys.weapon:CanPrimaryAttack( vehicle )
	vehicle.NextShoot = vehicle.NextShoot or 0
	return vehicle.NextShoot < CurTime()
end

function simfphys.weapon:SetNextPrimaryFire( vehicle, time )
	vehicle.NextShoot = time
end

function simfphys.weapon:SecondaryAttack( vehicle, ply, shootOrigin )
	
	if not self:CanSecondaryAttack( vehicle ) then return end
	
	local ID = vehicle:LookupAttachment( "turret_machinegun" )
	local Attachment = vehicle:GetAttachment( ID )
	
	local effectdata = EffectData()
		effectdata:SetOrigin( shootOrigin )
		effectdata:SetAngles( Attachment.Ang + Angle(0,90,0) )
		effectdata:SetEntity( vehicle )
		effectdata:SetAttachment( ID )
		effectdata:SetScale( 4 )
	util.Effect( "CS_MuzzleFlash", effectdata, true, true )
	
	hmg_fire( ply, vehicle, shootOrigin, Attachment.Ang:Up() )
	
	self:SetNextSecondaryFire( vehicle, CurTime() + 0.15 )
end

function simfphys.weapon:CanSecondaryAttack( vehicle )
	vehicle.NextShoot2 = vehicle.NextShoot2 or 0
	return vehicle.NextShoot2 < CurTime()
end

function simfphys.weapon:SetNextSecondaryFire( vehicle, time )
	vehicle.NextShoot2 = time
end

function simfphys.weapon:ControlTrackSounds( vehicle, wheelslocked ) 
	local speed = math.abs( self:GetForwardSpeed( vehicle ) )
	local fastenuf = speed > 20 and not wheelslocked and self:IsOnGround( vehicle )
	
	if fastenuf ~= vehicle.fastenuf then
		vehicle.fastenuf = fastenuf
		
		if fastenuf then
			vehicle.track_snd = CreateSound( vehicle, "simulated_vehicles/sherman/tracks.wav" )
			vehicle.track_snd:PlayEx(0,0)
			vehicle:CallOnRemove( "stopmesounds", function( vehicle )
				if vehicle.track_snd then
					vehicle.track_snd:Stop()
				end
			end)
		else
			if vehicle.track_snd then
				vehicle.track_snd:Stop()
				vehicle.track_snd = nil
			end
		end
	end
	
	if vehicle.track_snd then
		vehicle.track_snd:ChangePitch( math.Clamp(60 + speed / 70,0,150) ) 
		vehicle.track_snd:ChangeVolume( math.min( math.max(speed - 20,0) / 600,1) ) 
	end
end


function simfphys.weapon:GetForwardSpeed( vehicle )
	return vehicle.ForwardSpeed
end

function simfphys.weapon:IsOnGround( vehicle )
	return (vehicle.susOnGround == true)
end

function simfphys.weapon:ModPhysics( vehicle, wheelslocked )
	if wheelslocked and self:IsOnGround( vehicle ) then
		local phys = vehicle:GetPhysicsObject()
		phys:ApplyForceCenter( -vehicle:GetVelocity() * phys:GetMass() * 0.04 )
	end
end

function simfphys.weapon:UpdateSuspension( vehicle )
	if not vehicle.filterEntities then
		vehicle.filterEntities = player.GetAll()
		table.insert(vehicle.filterEntities, vehicle)
		
		for i, wheel in pairs( ents.FindByClass( "gmod_sent_vehicle_fphysics_wheel" ) ) do
			table.insert(vehicle.filterEntities, wheel)
		end
	end
	
	vehicle.oldDist = istable( vehicle.oldDist ) and vehicle.oldDist or {}
	
	vehicle.susOnGround = false
	
	for i, v in pairs( sherman_susdata ) do
		local pos = vehicle:GetAttachment( vehicle:LookupAttachment( sherman_susdata[i].attachment ) ).Pos
		
		local trace = util.TraceHull( {
			start = pos,
			endpos = pos + vehicle:GetUp() * - 100,
			maxs = Vector(15,15,0),
			mins = -Vector(15,15,0),
			filter = vehicle.filterEntities,
		} )
		local Dist = (pos - trace.HitPos):Length() - 30
		
		if trace.Hit then
			vehicle.susOnGround = true
		end
		
		vehicle.oldDist[i] = vehicle.oldDist[i] and (vehicle.oldDist[i] + math.Clamp(Dist - vehicle.oldDist[i],-5,1)) or 0
		
		vehicle:SetPoseParameter(sherman_susdata[i].poseparameter, 12 - vehicle.oldDist[i] )
	end
end

function simfphys.weapon:DoWheelSpin( vehicle )
	local spin_r = vehicle.VehicleData[ "spin_4" ] + vehicle.VehicleData[ "spin_6" ]
	local spin_l = vehicle.VehicleData[ "spin_3" ] + vehicle.VehicleData[ "spin_5" ]
	
	vehicle:SetPoseParameter("spin_wheels_right", spin_r * 1.2)
	vehicle:SetPoseParameter("spin_wheels_left", spin_l  * 1.2)
end
