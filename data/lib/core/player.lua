APPLY_SKILL_MULTIPLIER = true
local addManaSpentFunc = Player.addManaSpent
function Player.addManaSpent(...)
	APPLY_SKILL_MULTIPLIER = false
	local ret = addManaSpentFunc(...)
	APPLY_SKILL_MULTIPLIER = true
	return ret
end

local addSkillTriesFunc = Player.addSkillTries
function Player.addSkillTries(...)
	APPLY_SKILL_MULTIPLIER = false
	local ret = addSkillTriesFunc(...)
	APPLY_SKILL_MULTIPLIER = true
	return ret
end

function Player.checkGnomeRank(self)
	local points = self:getStorageValue(PlayerStorageKeys.BIGFOOTBURDEN.RANK)
	local questProgress = self:getStorageValue(PlayerStorageKeys.BIGFOOTBURDEN.QUESTLINE)
	if points >= 30 and points < 120 then
		if questProgress == 14 then
			self:setStorageValue(PlayerStorageKeys.BIGFOOTBURDEN.QUESTLINE, 15)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
		self:addAchievement('Gnome Little Helper')
	elseif points >= 120 and points < 480 then
		if questProgress == 15 then
			self:setStorageValue(PlayerStorageKeys.BIGFOOTBURDEN.QUESTLINE, 16)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
		self:addAchievement('Gnome Friend')
	elseif points >= 480 and points < 1440 then
		if questProgress == 16 then
			self:setStorageValue(PlayerStorageKeys.BIGFOOTBURDEN.QUESTLINE, 17)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
		self:addAchievement('Gnomelike')
	elseif points >= 1440 then
		if questProgress == 17 then
			self:setStorageValue(PlayerStorageKeys.BIGFOOTBURDEN.QUESTLINE, 18)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
		self:addAchievement('Honorary Gnome')
	end
	return true
end

function Player.depositMoney(self, amount)
	if not self:removeMoney(amount) then
		return false
	end

	self:setBankBalance(self:getBankBalance() + amount)
	return true
end

local foodCondition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)

function Player.feed(self, food)
	local condition = self:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
	if condition then
		condition:setTicks(condition:getTicks() + (food * 1000))
	else
		local vocation = self:getVocation()
		if not vocation then
			return nil
		end

		foodCondition:setTicks(food * 1000)
		foodCondition:setParameter(CONDITION_PARAM_HEALTHGAIN, vocation:getHealthGainAmount())
		foodCondition:setParameter(CONDITION_PARAM_HEALTHTICKS, vocation:getHealthGainTicks() * 1000)
		foodCondition:setParameter(CONDITION_PARAM_MANAGAIN, vocation:getManaGainAmount())
		foodCondition:setParameter(CONDITION_PARAM_MANATICKS, vocation:getManaGainTicks() * 1000)

		self:addCondition(foodCondition)
	end
	return true
end

function Player.getBlessings(self)
	local blessings = 0
	for i = 1, 5 do
		if self:hasBlessing(i) then
			blessings = blessings + 1
		end
	end
	return blessings
end

function Player.getClosestFreePosition(self, position, extended)
	if self:getAccountType() >= ACCOUNT_TYPE_GOD then
		return position
	end
	return Creature.getClosestFreePosition(self, position, extended)
end

function Player.getCookiesDelivered(self)
	local storage, amount = {
		STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.SIMONTHEBEGGAR, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.MARKWIN, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.ARIELLA,
		STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.HAIRYCLES, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.DJINN, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.AVARTAR,
		STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.ORCKING, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.LORBAS, STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.WYDA,
		STORAGE.WHATAFOOLISHQUEST.COOKIEDELIVERY.HJAERN
	}, 0
	for i = 1, #storage do
		if self:getStorageValue(storage[i]) == 1 then
			amount = amount + 1
		end
	end
	return amount
end

function Player.getDepotItems(self, depotId)
	return self:getDepotChest(depotId, true):getItemHoldingCount()
end

function Player.hasFlag(self, flag)
	return self:getGroup():hasFlag(flag)
end

function Player.getLossPercent(self)
	local blessings = 0
	local lossPercent = {
		[0] = 100,
		[1] = 70,
		[2] = 45,
		[3] = 25,
		[4] = 10,
		[5] = 0
	}

	for i = 1, 5 do
		if self:hasBlessing(i) then
			blessings = blessings + 1
		end
	end
	return lossPercent[blessings]
end

function Player.hasRookgaardShield(self)
	-- Wooden Shield, Studded Shield, Brass Shield, Plate Shield, Copper Shield
	return self:getItemCount(2512) > 0
			or self:getItemCount(2526) > 0
			or self:getItemCount(2511) > 0
			or self:getItemCount(2510) > 0
			or self:getItemCount(2530) > 0
end

function Player.isDruid(self)
	return table.contains({2, 6}, self:getVocation():getId())
end

function Player.isKnight(self)
	return table.contains({4, 8}, self:getVocation():getId())
end

function Player.isPaladin(self)
	return table.contains({3, 7}, self:getVocation():getId())
end

function Player.isMage(self)
	return table.contains({1, 2, 5, 6}, self:getVocation():getId())
end

function Player.isSorcerer(self)
	return table.contains({1, 5}, self:getVocation():getId())
end

function Player.getPremiumTime(self)
	return math.max(0, self:getPremiumEndsAt() - os.time())
end

function Player.setPremiumTime(self, seconds)
	self:setPremiumEndsAt(os.time() + seconds)
	return true
end

function Player.addPremiumTime(self, seconds)
	self:setPremiumTime(self:getPremiumTime() + seconds)
	return true
end

function Player.removePremiumTime(self, seconds)
	local currentTime = self:getPremiumTime()
	if currentTime < seconds then
		return false
	end

	self:setPremiumTime(currentTime - seconds)
	return true
end

function Player.getPremiumDays(self)
	return math.floor(self:getPremiumTime() / 86400)
end

function Player.addPremiumDays(self, days)
	return self:addPremiumTime(days * 86400)
end

function Player.removePremiumDays(self, days)
	return self:removePremiumTime(days * 86400)
end

function Player.isPremium(self)
	return self:getPremiumTime() > 0 or configManager.getBoolean(configKeys.FREE_PREMIUM)
end

function Player.isPromoted(self)
	local vocation = self:getVocation()
	local promotedVocation = vocation:getPromotion()
	promotedVocation = promotedVocation and promotedVocation:getId() or 0

	return promotedVocation == 0 and vocation:getId() ~= promotedVocation
end

function Player.isUsingOtClient(self)
	return self:getClient().os >= CLIENTOS_OTCLIENT_LINUX
end

function Player.sendCancelMessage(self, message)
	if type(message) == "number" then
		message = Game.getReturnMessage(message)
	end
	return self:sendTextMessage(MESSAGE_STATUS_SMALL, message)
end

function Player.sendExtendedOpcode(self, opcode, buffer)
	if not self:isUsingOtClient() then
		return false
	end

	local networkMessage = NetworkMessage()
	networkMessage:addByte(0x32)
	networkMessage:addByte(opcode)
	networkMessage:addString(buffer)
	networkMessage:sendToPlayer(self)
	networkMessage:delete()
	return true
end

function Player.transferMoneyTo(self, target, amount)
	local balance = self:getBankBalance()
	if amount > balance then
		return false
	end

	local targetPlayer = Player(target)
	if targetPlayer then
		targetPlayer:setBankBalance(targetPlayer:getBankBalance() + amount)
	else
		if not playerExists(target) then
			return false
		end
		db.query("UPDATE `players` SET `balance` = `balance` + '" .. amount .. "' WHERE `name` = " .. db.escapeString(target))
	end

	self:setBankBalance(self:getBankBalance() - amount)
	return true
end

function Player.withdrawMoney(self, amount)
	local balance = self:getBankBalance()
	if amount > balance or not self:addMoney(amount) then
		return false
	end

	self:setBankBalance(balance - amount)
	return true
end

function Player.depositMoney(self, amount)
	if not self:removeMoney(amount) then
		return false
	end

	self:setBankBalance(self:getBankBalance() + amount)
	return true
end

function Player.addLevel(self, amount, round)
	local experience, level, amount = 0, self:getLevel(), amount or 1
	if amount > 0 then
		experience = getExperienceForLevel(level + amount) - (round and self:getExperience() or getExperienceForLevel(level))
	else
		experience = -((round and self:getExperience() or getExperienceForLevel(level)) - getExperienceForLevel(level + amount))
	end
	return self:addExperience(experience)
end

function Player.addMagicLevel(self, value)
	return self:addManaSpent(self:getVocation():getRequiredManaSpent(self:getBaseMagicLevel() + value + 1) - self:getManaSpent())
end

function Player.addSkill(self, skillId, value, round)
	if skillId == SKILL_LEVEL then
		return self:addLevel(value, round)
	elseif skillId == SKILL_MAGLEVEL then
		return self:addMagicLevel(value)
	end
	return self:addSkillTries(skillId, self:getVocation():getRequiredSkillTries(skillId, self:getSkillLevel(skillId) + value) - self:getSkillTries(skillId))
end

function Player.getWeaponType()
	local weapon = self:getSlotItem(CONST_SLOT_LEFT)
	if weapon then
		return ItemType(weapon:getId()):getWeaponType()
	end
	return WEAPON_NONE
end

