local virusConfig = require(game.ServerScriptService.VirusSystem.CONFIGs.VirusConfig)
local CollectionService = game:GetService("CollectionService")

local function onSmallpoxAdded(playerCharacter)
	
end

CollectionService:GetInstanceAddedSignal("Smallpox"):Connect(onSmallpoxAdded)
