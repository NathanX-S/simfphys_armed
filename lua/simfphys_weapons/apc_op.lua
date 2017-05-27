sound.Add( {
	name = "op_apc_fire",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 85,
	pitch = { 90, 110 },
	sound = "simulated_vehicles/weapons/apc_fire.ogg"
} )


function simfphys.weapon:ValidClasses()
	
	local classes = {
		"sim_fphys_conscriptapc_armed"
	}
	
	return classes
end

function simfphys.weapon:Initialize( vehicle )
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end
	
	local pod = vehicle.pSeat[1]
	
	if not IsValid( pod ) then return end
	
	pod:SetNWBool( "IsGunnerSeat", true )
	pod:SetNWBool( "IsAPCSeat", true )
end

function simfphys.weapon:Think( vehicle )
	if not istable( vehicle.PassengerSeats ) or not istable( vehicle.pSeat ) then return end
	
	local pod = vehicle.pSeat[1]
	
	if not IsValid( pod ) then return end
	
	local ply = pod:GetDriver()
	
	local curtime = CurTime()
	
	if not IsValid(ply) then return end

	ply:CrosshairEnable()
	
	local tr = util.TraceLine( {
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 10000,
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
	
	local Angles = vehicle:WorldToLocalAngles( Aimang ) - Angle(0,90,0)
	Angles:Normalize()
	
	vehicle:SetPoseParameter("vehicle_weapon_yaw", (pod:WorldToLocalAngles( ply:EyeAngles() - Angle(0,90,0) ).y / 180) * 121 )
	--vehicle.sm_dir = vehicle.sm_dir and (vehicle.sm_dir + (-Angles:Forward() - vehicle.sm_dir) * 0.1) or Vector(0,0,0)
	--vehicle:SetPoseParameter("vehicle_weapon_yaw", ((vehicle.sm_dir:Angle().y - 180) / 180) * 119.8 )
	--vehicle:SetPoseParameter("vehicle_weapon_pitch", Angles.p )
	
	local fire = ply:KeyDown( IN_ATTACK )
	
	if not fire then return end
	
	vehicle.NextShoot = vehicle.NextShoot or 0
	if vehicle.NextShoot > curtime then return end
	
	vehicle.NextShoot = curtime + 0.2
	
	vehicle:EmitSound("op_apc_fire")
	
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= Aimang:Forward()
		bullet.Spread 		= Vector(0.03,0.03,0)
		bullet.Tracer		= 0
		bullet.Force		= 50
		bullet.Damage		= 50
		bullet.HullSize		= 20
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetOrigin( tr.HitPos )
				util.Effect( "helicoptermegabomb", effectdata, true, true )
				
			util.BlastDamage( vehicle, ply, tr.HitPos,50,150)
			
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
	local s_Pos = vehicle.swapMuzzle and -2 or 3
	
	local effectdata = EffectData()
		effectdata:SetOrigin( shootOrigin + a_up * s_Pos )
		effectdata:SetAngles( Attachment.Ang )
		effectdata:SetScale( 1.5 )
		util.Effect( "MuzzleEffect", effectdata, true, true )
		
	vehicle:GetPhysicsObject():ApplyForceOffset( -Aimang:Forward() * 120000, shootOrigin ) 
end
