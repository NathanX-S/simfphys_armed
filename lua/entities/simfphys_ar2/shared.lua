ENT.Type            = "anim"


ENT.PrintName = "simfphys ar2"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "Fun + Games"

ENT.Spawnable = false
ENT.AdminOnly = false


function ENT:SetupDataTables()
	self:NetworkVar( "Bool",0, "Fire" )
	self:NetworkVar( "Entity",0, "Attacker" )
end
