
local Materials = {
	"particle/smokesprites_0001",
	"particle/smokesprites_0002",
	"particle/smokesprites_0003",
	"particle/smokesprites_0004",
	"particle/smokesprites_0005",
	"particle/smokesprites_0006",
	"particle/smokesprites_0007",
	"particle/smokesprites_0008",
	"particle/smokesprites_0009",
	"particle/smokesprites_0010",
	"particle/smokesprites_0011",
	"particle/smokesprites_0012",
	"particle/smokesprites_0013",
	"particle/smokesprites_0014",
	"particle/smokesprites_0015",
	"particle/smokesprites_0016"
}

local function RandVector(min,max)
	min = min or -1
	max = max or 1
	
	local vec = Vector(math.Rand(min,max),math.Rand(min,max),math.Rand(min,max))
	return vec
end

function EFFECT:Init( data )
	local vehicle = data:GetEntity()
	
	local ID = vehicle:LookupAttachment( "muzzle" )
	local Attachment = vehicle:GetAttachment( ID )
	
	local Pos = Attachment.Pos
	local Dir = Attachment.Ang:Up()
	local vel = vehicle:GetVelocity()
	
	self:Muzzle( Pos, Dir, vel )
	self:Smoke( Pos, Dir, vel )
	self:Smoke2( Pos, Attachment.Ang:Forward(), Dir, vel )
	self:Smoke2( Pos, -Attachment.Ang:Forward(), Dir, vel )
end

function EFFECT:Muzzle( pos, dir, vel )
	local emitter = ParticleEmitter( pos, false )
	
	for i = 0,20 do
		local particle = emitter:Add( "effects/muzzleflash2", pos )

		if particle then
			particle:SetVelocity( dir * math.Rand(50,200) + vel )
			particle:SetDieTime( 0.3 )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.random(24,60) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( -1, 1 ) )
			particle:SetColor( 255,255,255 )
			particle:SetCollide( false )
		end
	end
	
	emitter:Finish()
end

function EFFECT:Smoke( pos, dir, vel )
	local emitter = ParticleEmitter( pos, false )
	
	for i = 0,60 do
		local particle = emitter:Add( Materials[math.random(1,table.Count( Materials ))], pos )
		
		if particle then
			particle:SetVelocity( dir * math.Rand(300,1300) + RandVector() * math.Rand(0,10) + vel )
			particle:SetDieTime( math.Rand(1,2) )
			particle:SetAirResistance( math.Rand(300,600) ) 
			particle:SetStartAlpha( 150 )
			particle:SetStartSize( 5 )
			particle:SetEndSize( math.Rand(80,160) )
			particle:SetRoll( math.Rand(-1,1) )
			particle:SetColor( 120,120,120 )
			particle:SetGravity( RandVector() * 200 )
			particle:SetCollide( false )
		end
	end
	
	emitter:Finish()
end

function EFFECT:Smoke2( pos, dir, dir_grav, vel )
	local emitter = ParticleEmitter( pos, false )
	
	for i = 0,20 do
		local particle = emitter:Add( Materials[math.random(1,table.Count( Materials ))], pos )
		
		if particle then
			particle:SetVelocity( dir * math.Rand(250,800) + RandVector() * math.Rand(0,50) + vel)
			particle:SetDieTime( math.Rand(0.5,1) )
			particle:SetAirResistance( 800 ) 
			particle:SetStartAlpha( 150 )
			particle:SetStartSize( math.Rand(0,15) )
			particle:SetEndSize( math.Rand(40,120) )
			particle:SetRoll( math.Rand(-1,1) )
			particle:SetColor( 120,120,120 )
			particle:SetGravity( dir_grav * 200 )
			particle:SetCollide( false )
		end
	end
	
	emitter:Finish()
end


function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
