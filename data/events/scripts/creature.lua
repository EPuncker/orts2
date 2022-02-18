function Creature:onChangeOutfit(outfit)
	if EventCallback.onChangeMount then
		if not EventCallback.onChangeMount(self, outfit.lookMount) then
			return false
		end
	end
	if EventCallback.onChangeOutfit then
		return EventCallback.onChangeOutfit(self, outfit)
	else
		return true
	end
end

function Creature:onAreaCombat(tile, isAggressive)
	if EventCallback.onAreaCombat then
		return EventCallback.onAreaCombat(self, tile, isAggressive)
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

	player:setStorageValue(PlayerStorageKeys.combatProtectionStorage, 2)
	addEvent(function(cid)
		local player = Player(cid)
		if not player then
			return
		end

		player:setStorageValue(PlayerStorageKeys.combatProtectionStorage, 0)
		player:remove()
	end, time * 1000, cid)
end

function Creature:onTargetCombat(target)
	if EventCallback.onTargetCombat then
		return EventCallback.onTargetCombat(self, target)
	else
		if not self then
			return true
		end

		if target:isPlayer() then
			if self:isMonster() then
				local protectionStorage = target:getStorageValue(PlayerStorageKeys.combatProtectionStorage)

				if target:getIp() == 0 then -- If player is disconnected, monster shall ignore to attack the player
					if protectionStorage <= 0 then
						addEvent(removeCombatProtection, 30 * 1000, target.uid)
						target:setStorageValue(PlayerStorageKeys.combatProtectionStorage, 1)
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
	if EventCallback.onHear then
		EventCallback.onHear(self, speaker, words, type)
	end
end
