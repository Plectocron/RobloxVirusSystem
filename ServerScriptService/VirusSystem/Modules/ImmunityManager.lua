local immunityConfig = require(script.Parent.Parent.CONFIGs.ImmunityConfig)
local virusConfig = require(script.Parent.Parent.CONFIGs.VirusConfig)

local ImmunityManager = {}

function ImmunityManager.GetImmunityLevel(playerCharacter)
	return playerCharacter:FindFirstChild("ImmunityLevel").Value
end

function ImmunityManager.SetImmunityLevel(playerCharacter, level)
	if typeof(level) ~= "number" then warn(level.. " is not a number.") return end
	playerCharacter:FindFirstChild("ImmunityLevel").Value = level
end

function ImmunityManager.VirusCanBypassImmunity(virusName, immunityLevel)
	local virus = virusConfig[virusName]
	if not virus then warn(virusName.. " doesn't exist in the VirusConfig") return false end
	
	return virus.ImmunityPenetration > immunityLevel
end

return ImmunityManager
