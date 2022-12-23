local waterIds = {4608, 4609, 4610, 4611, 4612, 4613, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625}

local mechanicalFishing = Action()

function mechanicalFishing.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains(waterIds, target.itemid) then
		return false
	end

	-- TODO: might need to add a check to allow fishing only if got quest storage

	if not player:getPosition():isInRange(Position(32730, 31133, 8), Position(32870, 31302, 8)) then -- check if player is in yalahar sewers
		player:say("You can only use this on Yalahar sewers.", TALKTYPE_MONSTER_SAY)
		return false
	end
	toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
	-- need to verify if it should add skill tries
	-- player:addSkillTries(SKILL_FISHING, 1)
	if math.random(1, 100) <= math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_FISHING) - 10) * 0.597, 10), 50) then
		if not player:removeItem(8309, 1) then -- nail
			return true
		end

		player:addItem(10224, 1) -- mechanical fish
	end
	return true
end

mechanicalFishing:id(10223)
mechanicalFishing:allowFarUse(true)
mechanicalFishing:register()
