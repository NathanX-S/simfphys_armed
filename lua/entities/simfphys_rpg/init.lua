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
			self.NextShoot = CurTime() + 1
		end
	end
	
	self:NextThink(CurTime())
	return true
end

function ENT:FireWeapon(ply)
	if (!IsValid(self.Rocket)) then
		self:EmitSound("PropAPC.FireCannon")
		self.Rocket = ents.Create( "rpg_missile" )
		self.Rocket:SetPos( self:LocalToWorld( Vector(0,0,25) ) )
		self.Rocket:SetAngles( self:GetAngles() )
		self.Rocket:SetOwner( ply )
		self.Rocket:SetSaveValue( "m_flDamage", 150 )
		self.Rocket:Spawn()
		self.Rocket:Activate()
	end
end