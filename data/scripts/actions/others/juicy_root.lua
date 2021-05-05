local rootsTable = {
	[23475] = 23477,
	[23476] = 23478
}

local juicyRoot = Action()

function juicyRoot.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if math.random(2) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You successfully harvest some juicy roots.")
		player:addItem(23662, 1) -- juicy roots
		if player:getStorageValue(PlayerStorageKeys.Oramond.MissionToTakeRoots) < 0 then
			player:setStorageValue(PlayerStorageKeys.Oramond.HarvestedRootCount, 1)
			player:setStorageValue(PlayerStorageKeys.Oramond.MissionToTakeRoots, 1)
			player:setStorageValue(PlayerStorageKeys.Oramond.QuestLine, 1)
		elseif player:getStorageValue(PlayerStorageKeys.Oramond.MissionToTakeRoots) == 1 then
			player:setStorageValue(PlayerStorageKeys.Oramond.HarvestedRootCount, harvestedCount + 1)
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your harvesting attempt destroyed more of the juicy roots than you could salvage.")
	end
	local roots = rootsTable[item.itemid]
	if roots then
		item:transform(roots)
		item:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
		item:decay()
	end
	if table.contains({23477, 23478}, item.itemid) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This root has already been harvested, nothing to gain here.")
	end
	return true
end

for k, v in pairs(rootsTable) do
	juicyRoot:id(k)
end
juicyRoot:id(23477, 23478)
juicyRoot:register()
