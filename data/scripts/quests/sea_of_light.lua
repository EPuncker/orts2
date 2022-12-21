local rareCrystal = Action()

function rareCrystal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4224 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.SeaOfLightQuest.Questline) ~= 7 then
		return false
	end

	player:setStorageValue(PlayerStorageKeys.SeaOfLightQuest.Questline, 8)
	player:setStorageValue(PlayerStorageKeys.SeaOfLightQuest.Mission3, 2)
	local destination = Position(32017, 31730, 8)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	item:remove()
	return true
end

rareCrystal:id(10614)
rareCrystal:register()

local collectorCorpse = Action()

function collectorCorpse.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 10612 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.SeaOfLightQuest.Questline) ~= 8 then
		return false
	end

	player:say('You carefully put the mirror crystal into the astronomers\'s device.', TALKTYPE_MONSTER_SAY)
	player:getStorageValue(PlayerStorageKeys.SeaOfLightQuest.Questline, 9)
	player:setStorageValue(PlayerStorageKeys.SeaOfLightQuest.Mission3, 3)
	item:transform(10616)
	return true
end

collectorCorpse:id(10615)
collectorCorpse:register()

local iceCube = Action()

function iceCube.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.SeaOfLightQuest.Questline) < 8 then
		return false
	end

	local destination = Position(32017, 31730, 8)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

iceCube:aid(4225)
iceCube:register()

