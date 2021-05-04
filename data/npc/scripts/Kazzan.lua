local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(PlayerStorageKeys.WhatAFoolishQuest.Questline) == 35
			and player:getStorageValue(PlayerStorageKeys.WhatAFoolishQuest.ScaredKazzan) ~= 1
			and player:getOutfit().lookType == 65 then
		player:setStorageValue(PlayerStorageKeys.WhatAFoolishQuest.ScaredKazzan, 1)
		npcHandler:say('WAAAAAHHH!!!', cid)
		return false
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:addModule(FocusModule:new())
