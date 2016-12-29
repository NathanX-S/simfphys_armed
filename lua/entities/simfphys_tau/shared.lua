ENT.Type            = "anim"


ENT.PrintName = "simfphys tau"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "Fun + Games"

ENT.Spawnable = false


function ENT:SetupDataTables()
	self:NetworkVar( "Bool",0, "Fire" )
	self:NetworkVar( "Entity",0, "Attacker" )
end
