local function sendSleepEffect(position)
	position:sendMagicEffect(CONST_ME_SLEEP)
end

local barbarianHorn = Action()

function barbarianHorn.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid == 3110 and item.itemid == 7140 then
		player:say('You fill your horn with ale.', TALKTYPE_MONSTER_SAY)
		item:transform(7141)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target.itemid == 7174 and item.itemid == 7141 then
		player:say('The bear is now unconcious.', TALKTYPE_MONSTER_SAY)
		item:transform(7140)
		target:transform(7175)
		toPosition:sendMagicEffect(CONST_ME_STUN)
	elseif item.itemid == 7175 then
		if player:getStorageValue(PlayerStorageKeys.BarbarianTest.Questline) == 4 then
			player:say('You hug the unconcious bear.', TALKTYPE_MONSTER_SAY)
			player:setStorageValue(PlayerStorageKeys.BarbarianTest.Questline, 5)
			player:setStorageValue(PlayerStorageKeys.BarbarianTest.Mission02, 2)
			player:addAchievement('Bearhugger')
			item:transform(7174)
			toPosition:sendMagicEffect(CONST_ME_SLEEP)
		else
			player:say('You don\'t feel like hugging an unconcious bear.', TALKTYPE_MONSTER_SAY)
		end
	elseif item.itemid == 7174 then
		player:say('Grr.', TALKTYPE_MONSTER_SAY)
		player:say('The bear is not amused by the disturbance.', TALKTYPE_MONSTER_SAY)
		doAreaCombatHealth(player, COMBAT_PHYSICALDAMAGE, player:getPosition(), 0, -10, -30, CONST_ME_POFF)
	elseif item.itemid == 7176 then
		if player:getStorageValue(PlayerStorageKeys.BarbarianTest.Questline) == 6 then
			if player:getCondition(CONDITION_DRUNK) then
				player:say('You hustle the mammoth. What a fun. *hicks*.', TALKTYPE_MONSTER_SAY)
				player:setStorageValue(PlayerStorageKeys.BarbarianTest.Questline, 7)
				player:setStorageValue(PlayerStorageKeys.BarbarianTest.Mission03, 2)
				item:transform(7177)
				item:decay()
				addEvent(sendSleepEffect, 60 * 1000, toPosition)
				toPosition:sendMagicEffect(CONST_ME_SLEEP)
			else
				player:say('You are not drunk enought to hustle a mammoth.', TALKTYPE_MONSTER_SAY)
			end
		end
	end
	return true
end

barbarianHorn:id(7140, 7141, 7174, 7175, 7176)
barbarianHorn:register()

local barbarianMead = Action()

function barbarianMead.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.BarbarianTest.Questline) == 2 and player:getStorageValue(PlayerStorageKeys.BarbarianTest.MeadTotalSips) <= 20 then
		if math.random(5) > 1 then
			player:say('The world seems to spin but you manage to stay on your feet.', TALKTYPE_MONSTER_SAY)
			player:setStorageValue(PlayerStorageKeys.BarbarianTest.MeadSuccessSips, player:getStorageValue(PlayerStorageKeys.BarbarianTest.MeadSuccessSips) + 1)
			if player:getStorageValue(PlayerStorageKeys.BarbarianTest.MeadSuccessSips) == 9 then
				player:say('10 sips in a row. Yeah!', TALKTYPE_MONSTER_SAY)
				player:setStorageValue(PlayerStorageKeys.BarbarianTest.Questline, 3)
				player:setStorageValue(PlayerStorageKeys.BarbarianTest.Mission01, 3)
				return true
			end
		else
			player:say('The mead was too strong. You passed out for a moment.', TALKTYPE_MONSTER_SAY)
			player:setStorageValue(PlayerStorageKeys.BarbarianTest.MeadSuccessSips, 0)
		end

		player:setStorageValue(PlayerStorageKeys.BarbarianTest.MeadTotalSips, player:getStorageValue(PlayerStorageKeys.BarbarianTest.MeadTotalSips) + 1)
	elseif player:getStorageValue(PlayerStorageKeys.BarbarianTest.MeadTotalSips) > 20 then
		player:say('Ask Sven for another round.', TALKTYPE_MONSTER_SAY)
		player:setStorageValue(PlayerStorageKeys.BarbarianTest.Questline, 1)
		player:setStorageValue(PlayerStorageKeys.BarbarianTest.Mission01, 1)
	elseif player:getStorageValue(PlayerStorageKeys.BarbarianTest.Questline) >= 3 then
		player:say('You already passed the test, no need to torture yourself anymore.', TALKTYPE_MONSTER_SAY)
	end
	return true
end

barbarianMead:uid(3110)
barbarianMead:register()
