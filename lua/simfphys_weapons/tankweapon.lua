util.AddNetworkString( "simfphys_register_tank" )
util.AddNetworkString( "simfphys_tank_do_effect" )

local tiger_susdata = {}
for i = 1,8 do
	tiger_susdata[i] = { 
		attachment = "vehicle_suspension_l_"..i,
		poseparameter = "suspension_left_"..i,
	}
	
	local ir = i + 8
	tiger_susdata[ir] = { 
		attachment = "vehicle_suspension_r_"..i,
		poseparameter = "suspension_right_"..i,
	}
end

local function mg_fire(ply,vehicle,shootOrigin,shootDirection)

	vehicle:EmitSound("tiger_fire_mg")
	
	local effectdata = EffectData()
		effectdata:SetOrigin( shootOrigin )
		effectdata:SetAngles( shootDirection:Angle() )
		effectdata:SetScale( 1.5 )
	util.Effect( "MuzzleEffect", effectdata, true, true )
	
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
	vehicle:EmitSound("tiger_fire")
	vehicle:EmitSound("tiger_reload")
	
	net.Start( "simfphys_tank_do_effect" )
		net.WriteEntity( vehicle )
		net.WriteString( "Muzzle" )
	net.Broadcast()
	
	vehicle:GetPhysicsObject():ApplyForceOffset( -shootDirection * 200000, shootOrigin ) 
	
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= shootDirection
		bullet.Spread 		= Vector(0,0,0)
		bullet.Tracer		= 0
		bullet.TracerName	= "simfphys_tracer"
		bullet.Force		= 6000
		bullet.Damage		= 3000
		bullet.HullSize		= 8
		bullet.Attacker 	= ply
		bullet.Callback = function(att, tr, dmginfo)
			
			net.Start( "simfphys_tank_do_effect" )
				net.WriteEntity( vehicle )
				net.WriteString( "Explosion" )
				net.WriteVector( tr.HitPos )
			net.Broadcast()
			
			util.BlastDamage( vehicle, ply, tr.HitPos,400,250)
			
			util.Decal("scorch", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal)
			
			if tr.Entity ~= Entity(0) then
				if simfphys.IsCar( tr.Entity ) then
					local effectdata = EffectData()
						effectdata:SetOrigin( tr.HitPos + shootDirection * tr.Entity:BoundingRadius() )
						effectdata:SetNormal( shootDirection * 10 )
					util.Effect( "manhacksparks", effectdata, true, true )
				
					sound.Play( Sound( "doors/vent_open"..math.random(1,3)..".wav" ), tr.HitPos, 140)
				end
			end
		end
		
	vehicle:FireBullets( bullet )
end

function simfphys.weapon:ValidClasses()
	
	local classes = {
		"sim_fphys_tank"
	}
	
	return classes
end

function simfphys.weapon:Initialize( vehicle )
	net.Start( "simfphys_register_tank" )
		net.WriteEntity( vehicle )
	net.Broadcast()
	
	local baseInertia =  Vector(5607,18617.2,19193.8)
	vehicle:GetPhysicsObject():SetInertia( baseInertia * 2.5 ) 
	
	simfphys.RegisterCrosshair( vehicle.DriverSeat, { Attachment = "muzzle_machinegun" } )
	
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end

	simfphys.RegisterCrosshair( vehicle.pSeat[1] , { Direction = Vector(0,0,1) } )
	simfphys.RegisterCamera( vehicle.pSeat[1], Vector(0,0,40), Vector(0,0,40) )
end

function simfphys.weapon:ControlTurret( vehicle, deltapos )
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end
	
	local pod = vehicle.pSeat[1]
	
	if not IsValid( pod ) then return end
	
	local ply = pod:GetDriver()
	
	if not IsValid( ply ) then return end
	
	self:AimCannon( ply, vehicle, pod )
	
	local ID = vehicle:LookupAttachment( "muzzle" )
	local Attachment = vehicle:GetAttachment( ID )
	
	local shootOrigin = Attachment.Pos + deltapos * engine.TickInterval()
	
	local fire = ply:KeyDown( IN_ATTACK )

	if fire then
		self:PrimaryAttack( vehicle, ply, shootOrigin, Attachment )
	end
end

function simfphys.weapon:ControlMachinegun( vehicle, deltapos )

	local pod = vehicle.DriverSeat
	
	if not IsValid( pod ) then return end
	
	local ply = pod:GetDriver()
	
	if not IsValid( ply ) then return end
	
	self:AimMachinegun( ply, vehicle, pod )
	
	local ID = vehicle:LookupAttachment( "muzzle_machinegun" )
	local Attachment = vehicle:GetAttachment( ID )

	local shootOrigin = Attachment.Pos + deltapos * engine.TickInterval()
	
	local fire = ply:KeyDown( IN_ATTACK )

	if fire then
		self:SecondaryAttack( vehicle, ply, shootOrigin, Attachment )
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

function simfphys.weapon:ControlTrackSounds( vehicle, wheelslocked ) 
	local speed = math.abs( self:GetForwardSpeed( vehicle ) )
	local fastenuf = speed > 20 and not wheelslocked and self:IsOnGround( vehicle )
	
	if fastenuf ~= vehicle.fastenuf then
		vehicle.fastenuf = fastenuf
		
		if fastenuf then
			vehicle.track_snd = CreateSound( vehicle, "simulated_vehicles/tiger/tiger_tracks.wav" )
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
		vehicle.track_snd:ChangePitch( math.Clamp(50 + speed / 5000,150) ) 
		vehicle.track_snd:ChangeVolume( math.min( math.max(speed - 20,0) / 600,1) ) 
	end
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

function simfphys.weapon:PrimaryAttack( vehicle, ply, shootOrigin, Attachment )
	if not self:CanPrimaryAttack( vehicle ) then return end
	
	cannon_fire( ply, vehicle, shootOrigin, Attachment.Ang:Up() )
	
	self:SetNextPrimaryFire( vehicle, CurTime() + 7 )
end

function simfphys.weapon:SecondaryAttack( vehicle, ply, shootOrigin, Attachment )
	
	if not self:CanSecondaryAttack( vehicle ) then return end
	
	mg_fire( ply, vehicle, shootOrigin, Attachment.Ang:Forward() )
	
	self:SetNextSecondaryFire( vehicle, CurTime() + 0.15 )
end

function simfphys.weapon:AimMachinegun( ply, vehicle, pod )	
	if not IsValid( pod ) then return end

	local Aimang = ply:EyeAngles()
	
	local Angles = vehicle:WorldToLocalAngles( Aimang )
	Angles:Normalize()
	
	local TargetPitch = Angles.p + (pod:GetThirdPersonMode() and -16 or 0)
	local TargetYaw = Angles.y
	
	vehicle:SetPoseParameter("machinegun_yaw", -TargetYaw )
	vehicle:SetPoseParameter("machinegun_pitch", TargetPitch )
end

function simfphys.weapon:AimCannon( ply, vehicle, pod )	
	if not IsValid( pod ) then return end

	local Aimang = ply:EyeAngles()
	
	local Angles = vehicle:WorldToLocalAngles( Aimang )
	Angles:Normalize()
	
	local TargetPitch = Angles.p + (pod:GetThirdPersonMode() and -16 or 0)
	local TargetYaw = Angles.y
	
	vehicle.sm_dir = vehicle.sm_dir and (vehicle.sm_dir + (Angle(0,TargetYaw,0):Forward() - vehicle.sm_dir) * 0.05) or Vector(0,0,0)
	vehicle.sm_pitch = vehicle.sm_pitch and (vehicle.sm_pitch + (TargetPitch - vehicle.sm_pitch) * 0.05) or 0
	
	vehicle:SetPoseParameter("turret_yaw", vehicle.sm_dir:Angle().y )
	vehicle:SetPoseParameter("turret_pitch", vehicle.sm_pitch )
end

function simfphys.weapon:CanPrimaryAttack( vehicle )
	vehicle.NextShoot = vehicle.NextShoot or 0
	return vehicle.NextShoot < CurTime()
end

function simfphys.weapon:CanSecondaryAttack( vehicle )
	vehicle.NextShoot2 = vehicle.NextShoot2 or 0
	return vehicle.NextShoot2 < CurTime()
end

function simfphys.weapon:SetNextPrimaryFire( vehicle, time )
	vehicle.NextShoot = time
end

function simfphys.weapon:SetNextSecondaryFire( vehicle, time )
	vehicle.NextShoot2 = time
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
	
	for i, v in pairs( tiger_susdata ) do
		local pos = vehicle:GetAttachment( vehicle:LookupAttachment( tiger_susdata[i].attachment ) ).Pos
		
		local trace = util.TraceHull( {
			start = pos,
			endpos = pos + vehicle:GetUp() * - 100,
			maxs = Vector(15,15,0),
			mins = -Vector(15,15,0),
			filter = vehicle.filterEntities,
		} )
		local Dist = (pos - trace.HitPos):Length() - 41
		
		if trace.Hit then
			vehicle.susOnGround = true
		end
		
		vehicle.oldDist[i] = vehicle.oldDist[i] and (vehicle.oldDist[i] + math.Clamp(Dist - vehicle.oldDist[i],-5,1)) or 0
		
		vehicle:SetPoseParameter(tiger_susdata[i].poseparameter, vehicle.oldDist[i] )
	end
end

function simfphys.weapon:DoWheelSpin( vehicle )
	local spin_r = vehicle.VehicleData[ "spin_4" ] + vehicle.VehicleData[ "spin_6" ]
	local spin_l = vehicle.VehicleData[ "spin_3" ] + vehicle.VehicleData[ "spin_5" ]
	
	vehicle:SetPoseParameter("spin_wheels_right", spin_r)
	vehicle:SetPoseParameter("spin_wheels_left", spin_l )
end