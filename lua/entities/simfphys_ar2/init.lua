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
end


function ENT:Think()
	local Fire = self:GetFire()
	local Attacker = self:GetAttacker()
	if (Fire == true and IsValid(Attacker)) then
		self.NextShoot = self.NextShoot or 0
		if ( self.NextShoot < CurTime() ) then
			self:FireWeapon(Attacker)
			self.NextShoot = CurTime() + 0.125
		end
	end
	
	self:NextThink(CurTime())
	return true
end

function ENT:FireWeapon(ply)
	self:EmitSound("Weapon_AR2.Single")

	local shootOrigin = self:GetPos() + self:GetVelocity() * engine.TickInterval() 
	local shootAngles = self:GetAngles()

	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= shootAngles:Forward()
		bullet.Spread 		= Vector(0.03,0.03,0)
		bullet.Tracer		= 1
		bullet.TracerName 	= "AirboatGunHeavyTracer"
		bullet.Force		= 3
		bullet.Damage		= 20
		bullet.HullSize		= 10
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetOrigin( tr.HitPos + tr.HitNormal * 2 )
				effectdata:SetNormal( tr.HitNormal )
				util.Effect( "AR2Impact", effectdata, true, true )
		end
		bullet.Attacker 	= ply
	self:FireBullets( bullet )
	
	local effectdata = EffectData()
		effectdata:SetOrigin( shootOrigin )
		effectdata:SetAngles(shootAngles )
		effectdata:SetEntity( self )
		effectdata:SetAttachment( self:LookupAttachment("muzzle") ) 
		util.Effect( "AirboatMuzzleFlash", effectdata, true, true )
end