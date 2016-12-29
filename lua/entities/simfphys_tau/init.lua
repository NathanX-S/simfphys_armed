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
end


function ENT:Think()
	local Fire = self:GetFire()
	local Attacker = self:GetAttacker()
	if (Fire == true and IsValid(Attacker)) then
		self.NextShoot = self.NextShoot or 0
		if ( self.NextShoot < CurTime() ) then
			self:FireWeapon(Attacker)
			self.NextShoot = CurTime() + 0.22
		end
	end
	
	self:NextThink(CurTime())
	return true
end

function ENT:FireWeapon(ply)
	self:EmitSound("simulated_vehicles/weapons/tau_fire"..math.Round(math.random(1,4),0)..".wav")

	local deltapos = self:GetPos() - self.OldPos
	self.OldPos = self:GetPos()
	
	local shootOrigin = self:LocalToWorld( Vector(0,0,3) ) + deltapos * engine.TickInterval() 
	local shootAngles = self:GetAngles()

	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= shootOrigin
		bullet.Dir 			= shootAngles:Forward()
		bullet.Spread 		= Vector(0.01,0.01,0)
		bullet.Tracer		= 0
		bullet.Force		= 10
		bullet.Damage		= 12
		bullet.HullSize		= 1
		bullet.Callback = function(att, tr, dmginfo)
		
		local effect = ents.Create("env_spark")
			effect:SetKeyValue("targetname", "target")
			effect:SetPos( tr.HitPos + tr.HitNormal * 2 )
			effect:SetAngles( tr.HitNormal:Angle() )
			effect:Spawn()
			effect:SetKeyValue("spawnflags","128")
			effect:SetKeyValue("Magnitude",5)
			effect:SetKeyValue("TrailLength",3)
			effect:Fire( "SparkOnce" )
			effect:Fire("kill","",0.21)
			
		local effectdata = EffectData()
			effectdata:SetOrigin( tr.HitPos )
			effectdata:SetStart( shootOrigin )
			effectdata:SetAttachment( 1 )
			effectdata:SetEntity( self )
			effectdata:SetScale( 6000 )	
			effectdata:SetMagnitude( 30 )	
			util.Effect( "arctaucannon", effectdata )
			
		local laser1 = ents.Create("env_laser")
			laser1:SetKeyValue("renderamt", "200")
			laser1:SetKeyValue("rendercolor", "255 255 150")
			laser1:SetKeyValue("texture", "sprites/laserbeam.spr")
			laser1:SetKeyValue("TextureScroll", "14")
			laser1:SetKeyValue("targetname", "laser1" )
			laser1:SetKeyValue("renderfx", "2")
			laser1:SetKeyValue("width", "0.5")
			laser1:SetKeyValue("dissolvetype", "None")
			laser1:SetKeyValue("EndSprite", "")
			laser1:SetKeyValue("LaserTarget", "target")
			laser1:SetKeyValue("TouchType", "-1")
			laser1:SetKeyValue("NoiseAmplitude", "2")
			laser1:Spawn()
			laser1:Fire("SetParent",self,0)
			laser1:Fire("TurnOn", "", 0.01)
			laser1:Fire("kill", "", 0.12)
			laser1:SetPos(shootOrigin)
		
		local laser2 = ents.Create("env_laser")
			laser2:SetKeyValue("renderamt", "200")
			laser2:SetKeyValue("rendercolor", "255 145 "..math.random(0,16))
			laser2:SetKeyValue("texture", "sprites/laserbeam.spr")
			laser2:SetKeyValue("TextureScroll", "14")
			laser2:SetKeyValue("targetname", "laser2" )
			laser2:SetKeyValue("renderfx", "2")
			laser2:SetKeyValue("width", "1")
			laser2:SetKeyValue("dissolvetype", "None")
			laser2:SetKeyValue("EndSprite", "")
			laser2:SetKeyValue("LaserTarget", "target")
			laser2:SetKeyValue("TouchType", "-1")
			laser2:SetKeyValue("NoiseAmplitude", "0")
			laser2:Spawn()
			laser2:Fire("SetParent",self,0)
			laser2:Fire("TurnOn", "", 0.01)
			laser2:Fire("kill", "", 0.12)
			laser2:SetPos(shootOrigin)
			
		util.Decal("fadingscorch", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal)
		end
		bullet.Attacker 	= ply
	self:FireBullets( bullet )
end