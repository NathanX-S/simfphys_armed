AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 20 )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:Initialize()	
	self:SetModel( "models/weapons/w_smg1.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	self.OldPos = Vector(0,0,0)
	self.Left = true
end


function ENT:Think()
	local Fire = self:GetFire()
	local Attacker = self:GetAttacker()
	if (Fire == true and IsValid(Attacker)) then
		self.NextShoot = self.NextShoot or 0
		if ( self.NextShoot < CurTime() ) then
			self:FireWeapon(Attacker)
			self.NextShoot = CurTime() + 0.4
		end
	end
	
	self:NextThink(CurTime())
	return true
end

function ENT:FireWeapon(ply)
	self:EmitSound("simulated_vehicles/weapons/apc_fire"..math.Round(math.random(1,4),0)..".wav")
	
	local deltapos = self:GetPos() - self.OldPos
	self.OldPos = self:GetPos()
	
	if (self.Left) then
		self.Left = false
	else
		self.Left = true
	end
	local Switchpos = self.Left and -2 or 2
	
	local shootOrigin = self:LocalToWorld( Vector(15,0,2.2 + Switchpos) ) + deltapos * engine.TickInterval() 
	local shootAngles = ply:EyeAngles() - Angle(10,0,0)

	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= shootAngles:Forward()
		bullet.Spread 		= Vector(0.03,0.03,0)
		bullet.Tracer		= 0
		bullet.Force		= 10
		bullet.Damage		= 80
		bullet.HullSize		= 20
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetOrigin( tr.HitPos )
				util.Effect( "helicoptermegabomb", effectdata, true, true )
				
			util.BlastDamage( self, ply, tr.HitPos, 150,80 )
			
			util.Decal("scorch", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal)
			
			sound.Play( Sound( "ambient/explosions/explode_1.wav" ), tr.HitPos, 75, 200, 1 )
		end
		bullet.Attacker 	= ply
	self:FireBullets( bullet )
	
	local effectdata = EffectData()
		effectdata:SetOrigin( shootOrigin )
		effectdata:SetAngles( shootAngles )
		effectdata:SetScale( math.random(1.5,3) )
		util.Effect( "MuzzleEffect", effectdata, true, true )
end