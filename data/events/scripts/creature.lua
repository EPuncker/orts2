function Creature:onChangeOutfit(outfit)
	local onChangeMount = EventCallback.onChangeMount
	if onChangeMount then
		if not onChangeMount(self, outfit.lookMount) then
			return false
		end
	end
	local onChangeOutfit = EventCallback.onChangeOutfit
	if onChangeOutfit then
		return onChangeOutfit(self, outfit)
	end
	return true
end

function Creature:onAreaCombat(tile, isAggressive)
	local onAreaCombat = EventCallback.onAreaCombat
	if onAreaCombat then
		return onAreaCombat(self, tile, isAggressive)
	end
	return RETURNVALUE_NOERROR
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
	local onTargetCombat = EventCallback.onTargetCombat
	if onTargetCombat then
		return onTargetCombat(self, target)
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
	return RETURNVALUE_NOERROR
end

function Creature:onHear(speaker, words, type)
	local onHear = EventCallback.onHeard
	if onHear then
		onHear(self, speaker, words, type)
	end
end
