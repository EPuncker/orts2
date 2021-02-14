function Creature:onChangeOutfit(outfit)
	if hasEventCallback(EVENT_CALLBACK_ONCHANGEMOUNT) then
		if not EventCallback(EVENT_CALLBACK_ONCHANGEMOUNT, self, outfit.lookMount) then
			return false
		end
	end
	if hasEventCallback(EVENT_CALLBACK_ONCHANGEOUTFIT) then
		return EventCallback(EVENT_CALLBACK_ONCHANGEOUTFIT, self, outfit)
	else
		return true
	end
end

function Creature:onAreaCombat(tile, isAggressive)
	if hasEventCallback(EVENT_CALLBACK_ONAREACOMBAT) then
		return EventCallback(EVENT_CALLBACK_ONAREACOMBAT, self, tile, isAggressive)
	else
		return RETURNVALUE_NOERROR
	end
end

local function removeCombatProtection(cid)
	local player = Player(cid)
	if not player then
		return true
	end

	local time = 0
	if player:isMage() then
		time = 10
	elseif player:isPaladin() then
		time = 20
	else
		time = 30
	end

	player:setStorageValue(Storage.combatProtectionStorage, 2)
	addEvent(function(cid)
		local player = Player(cid)
		if not player then
			return
		end

		player:setStorageValue(Storage.combatProtectionStorage, 0)
		player:remove()
	end, time * 1000, cid)
end

function Creature:onTargetCombat(target)
	if hasEventCallback(EVENT_CALLBACK_ONTARGETCOMBAT) then
		return EventCallback(EVENT_CALLBACK_ONTARGETCOMBAT, self, target)
	else
		if not self then
			return true
		end

		if target:isPlayer() then
			if self:isMonster() then
				local protectionStorage = target:getStorageValue(Storage.combatProtectionStorage)

				if target:getIp() == 0 then -- If player is disconnected, monster shall ignore to attack the player
					if protectionStorage <= 0 then
						addEvent(removeCombatProtection, 30 * 1000, target.uid)
						target:setStorageValue(Storage.combatProtectionStorage, 1)
					elseif protectionStorage == 1 then
						self:searchTarget()
						return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
					end

					return true
				end

				if protectionStorage >= os.time() then
					return RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER
				end
			end
		end
	end
end

function Creature:onHear(speaker, words, type)
	if hasEventCallback(EVENT_CALLBACK_ONHEAR) then
		EventCallback(EVENT_CALLBACK_ONHEAR, self, speaker, words, type)
	end
end
