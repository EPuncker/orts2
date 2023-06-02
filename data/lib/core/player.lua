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
	local points = self:getStorageValue(PlayerStorageKeys.BigfootBurden.Rank)
	local questProgress = self:getStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine)
	if points >= 30 and points < 120 then
		if questProgress == 14 then
			self:setStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine, 15)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
		self:addAchievement('Gnome Little Helper')
	elseif points >= 120 and points < 480 then
		if questProgress == 15 then
			self:setStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine, 16)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
		self:addAchievement('Gnome Friend')
	elseif points >= 480 and points < 1440 then
		if questProgress == 16 then
			self:setStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine, 17)
			self:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
		self:addAchievement('Gnomelike')
	elseif points >= 1440 then
		if questProgress == 17 then
			self:setStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine, 18)
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
		PlayerStorageKeys.WhatAFoolishQuest.CookieDelivery.Simonthebeggar, PlayerStorageKeys.WhatAFoolishQuest.CookieDelivery.Markwin, PlayerStorageKeys.WhatAFoolishQuest.CookieDelivery.Ariella,
		PlayerStorageKeys.WhatAFoolishQuest.CookieDelivery.Hairycles, PlayerStorageKeys.WhatAFoolishQuest.CookieDelivery.Djinn, PlayerStorageKeys.WhatAFoolishQuest.CookieDelivery.Avartar,
		PlayerStorageKeys.WhatAFoolishQuest.CookieDelivery.Orcking, PlayerStorageKeys.WhatAFoolishQuest.CookieDelivery.Lorbas, PlayerStorageKeys.WhatAFoolishQuest.CookieDelivery.Wyda,
		PlayerStorageKeys.WhatAFoolishQuest.CookieDelivery.Hjaern
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
	return table.contains({VOCATION_DRUID, VOCATION_ELDER_DRUID}, self:getVocation():getId())
end

function Player.isKnight(self)
	return table.contains({VOCATION_KNIGHT, VOCATION_ELITE_KNIGHT}, self:getVocation():getId())
end

function Player.isPaladin(self)
	return table.contains({VOCATION_PALADIN, VOCATION_ROYAL_PALADIN}, self:getVocation():getId())
end

function Player.isMage(self)
	return table.contains({VOCATION_SORCERER, VOCATION_DRUID, VOCATION_MASTER_SORCERER, VOCATION_ELDER_DRUID}, self:getVocation():getId())
end

function Player.isSorcerer(self)
	return table.contains({VOCATION_SORCERER, VOCATION_MASTER_SORCERER}, self:getVocation():getId())
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
	return self:getPremiumTime() > 0 or configManager.getBoolean(configKeys.FREE_PREMIUM) or self:hasFlag(PlayerFlag_IsAlwaysPremium)
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

function Player.canCarryMoney(self, amount)
	-- Anyone can carry as much imaginary money as they desire
	if amount == 0 then
		return true
	end

	-- The 3 below loops will populate these local variables
	local totalWeight = 0
	local inventorySlots = 0

	local currencyItems = Game.getCurrencyItems()
	for index = #currencyItems, 1, -1 do
		local currency = currencyItems[index]
		-- Add currency coins to totalWeight and inventorySlots
		local worth = currency:getWorth()
		local currencyCoins = math.floor(amount / worth)
		if currencyCoins > 0 then
			amount = amount - (currencyCoins * worth)
			while currencyCoins > 0 do
				local count = math.min(100, currencyCoins)
				totalWeight = totalWeight + currency:getWeight(count)
				currencyCoins = currencyCoins - count
				inventorySlots = inventorySlots + 1
			end
		end
	end

	-- If player don't have enough capacity to carry this money
	if self:getFreeCapacity() < totalWeight then
		return false
	end

	-- If player don't have enough available inventory slots to carry this money
	local backpack = self:getSlotItem(CONST_SLOT_BACKPACK)
	if not backpack or backpack:getEmptySlots(true) < inventorySlots then
		return false
	end
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

function Player.removeTotalMoney(self, amount)
	local moneyCount = self:getMoney()
	local bankCount = self:getBankBalance()
	if amount <= moneyCount then
		self:removeMoney(amount)
		return true
	elseif amount <= (moneyCount + bankCount) then
		if moneyCount ~= 0 then
			self:removeMoney(moneyCount)
			local remains = amount - moneyCount
			self:setBankBalance(bankCount - remains)
			self:sendTextMessage(MESSAGE_INFO_DESCR, ("Paid %d from inventory and %d gold from bank account. Your account balance is now %d gold."):format(moneyCount, amount - moneyCount, self:getBankBalance()))
			return true
		end

		self:setBankBalance(bankCount - amount)
		self:sendTextMessage(MESSAGE_INFO_DESCR, ("Paid %d gold from bank account. Your account balance is now %d gold."):format(amount, self:getBankBalance()))
		return true
	end
	return false
end

function Player.addLevel(self, amount, round)
	round = round or false
	local level, amount = self:getLevel(), amount or 1
	if amount > 0 then
		return self:addExperience(Game.getExperienceForLevel(level + amount) - (round and self:getExperience() or Game.getExperienceForLevel(level)))
	end
	return self:removeExperience(((round and self:getExperience() or Game.getExperienceForLevel(level)) - Game.getExperienceForLevel(level + amount)))
end

function Player.addMagicLevel(self, value)
	local currentMagLevel = self:getBaseMagicLevel()
	local sum = 0

	if value > 0 then
		while value > 0 do
			sum = sum + self:getVocation():getRequiredManaSpent(currentMagLevel + value)
			value = value - 1
		end

		return self:addManaSpent(sum - self:getManaSpent())
	end

	value = math.min(currentMagLevel, math.abs(value))
	while value > 0 do
		sum = sum + self:getVocation():getRequiredManaSpent(currentMagLevel - value + 1)
		value = value - 1
	end

	return self:removeManaSpent(sum + self:getManaSpent())
end

function Player.addSkillLevel(self, skillId, value)
	local currentSkillLevel = self:getSkillLevel(skillId)
	local sum = 0

	if value > 0 then
		while value > 0 do
			sum = sum + self:getVocation():getRequiredSkillTries(skillId, currentSkillLevel + value)
			value = value - 1
		end

		return self:addSkillTries(skillId, sum - self:getSkillTries(skillId))
	end

	value = math.min(currentSkillLevel, math.abs(value))
	while value > 0 do
		sum = sum + self:getVocation():getRequiredSkillTries(skillId, currentSkillLevel - value + 1)
		value = value - 1
	end

	return self:removeSkillTries(skillId, sum + self:getSkillTries(skillId), true)
end

function Player.addSkill(self, skillId, value, round)
	if skillId == SKILL_LEVEL then
		return self:addLevel(value, round or false)
	elseif skillId == SKILL_MAGLEVEL then
		return self:addMagicLevel(value)
	end
	return self:addSkillLevel(skillId, value)
end

function Player.getWeaponType(self)
	local weapon = self:getSlotItem(CONST_SLOT_LEFT)
	if weapon then
		return weapon:getType():getWeaponType()
	end
	return WEAPON_NONE
end

function Player.updateKillTracker(self, monster, corpse)
	local monsterType = monster:getType()
	if not monsterType then
		return false
	end

	local msg = NetworkMessage()
	msg:addByte(0xD1)
	msg:addString(monster:getName())

	local monsterOutfit = monsterType:getOutfit()
	msg:addU16(monsterOutfit.lookType or 19)
	msg:addByte(monsterOutfit.lookHead)
	msg:addByte(monsterOutfit.lookBody)
	msg:addByte(monsterOutfit.lookLegs)
	msg:addByte(monsterOutfit.lookFeet)
	msg:addByte(monsterOutfit.lookAddons)

	local corpseSize = corpse:getSize()
	msg:addByte(corpseSize)
	for index = corpseSize - 1, 0, -1 do
		msg:addItem(corpse:getItem(index))
	end

	local party = self:getParty()
	if party then
		local members = party:getMembers()
		members[#members + 1] = party:getLeader()

		for _, member in ipairs(members) do
			msg:sendToPlayer(member)
		end
	else
		msg:sendToPlayer(self)
	end

	msg:delete()
	return true
end

function Player.getTotalMoney(self)
	return self:getMoney() + self:getBankBalance()
end

function Player.addAddonToAllOutfits(self, addon)
	for sex = 0, 1 do
		local outfits = Game.getOutfits(sex)
		for outfit = 1, #outfits do
			self:addOutfitAddon(outfits[outfit].lookType, addon)
		end
	end
end

function Player.addAllMounts(self)
	local mounts = Game.getMounts()
	for mount = 1, #mounts do
		self:addMount(mounts[mount].id)
	end
end

function Player.setSpecialContainersAvailable(self, available)
	local msg = NetworkMessage()
	msg:addByte(0x2A)

	msg:addByte(0x00) -- stash
	msg:addByte(available and 0x01 or 0x00) -- market

	msg:sendToPlayer(self)
	msg:delete()
	return true
end

function Player.addBankBalance(self, amount)
	self:setBankBalance(self:getBankBalance() + amount)
end

function Player.isPromoted(self)
	local vocation = self:getVocation()
	local fromVocId = vocation:getDemotion():getId()
	return vocation:getId() ~= fromVocId
end

function Player.getMaxTrackedQuests(self)
	return configManager.getNumber(self:isPremium() and configKeys.QUEST_TRACKER_PREMIUM_LIMIT or configKeys.QUEST_TRACKER_FREE_LIMIT)
end

function Player.getQuests(self)
	local quests = {}
	for _, quest in pairs(Game.getQuests()) do
		if quest:isStarted(self) then
			quests[#quests + 1] = quest
		end
	end
	return quests
end

function Player.sendQuestLog(self)
	local msg = NetworkMessage()
	msg:addByte(0xF0)
	local quests = self:getQuests()
	msg:addU16(#quests)

	for _, quest in pairs(quests) do
		msg:addU16(quest.id)
		msg:addString(quest.name)
		msg:addByte(quest:isCompleted(self))
	end

	msg:sendToPlayer(self)
	msg:delete()
	return true
end

function Player.sendQuestLine(self, quest)
	local msg = NetworkMessage()
	msg:addByte(0xF1)
	msg:addU16(quest.id)
	local missions = quest:getMissions(self)
	msg:addByte(#missions)

	for _, mission in pairs(missions) do
		msg:addU16(mission.id)
		msg:addString(mission:getName(self))
		msg:addString(mission:getDescription(self))
	end

	msg:sendToPlayer(self)
	msg:delete()
	return true
end

function Player.getTrackedQuests(self, missionsId)
	local playerId = self:getId()
	local maxTrackedQuests = self:getMaxTrackedQuests()
	local trackedQuests = {}
	Game.getTrackedQuests()[playerId] = trackedQuests
	local quests = Game.getQuests()
	local missions = Game.getMissions()
	local trackeds = 0
	for _, missionId in pairs(missionsId) do
		local mission = missions[missionId]
		if mission and mission:isStarted(self) then
			trackedQuests[mission] = quests[mission.questId]
			trackeds = trackeds + 1
			if trackeds >= maxTrackedQuests then
				break
			end
		end
	end
	return trackedQuests, trackeds
end

function Player.sendQuestTracker(self, missionsId)
	local msg = NetworkMessage()
	msg:addByte(0xD0)
	msg:addByte(1)

	local trackedQuests, trackeds = self:getTrackedQuests(missionsId)
	msg:addByte(self:getMaxTrackedQuests() - trackeds)
	msg:addByte(trackeds)

	for mission, quest in pairs(trackedQuests or {}) do
		msg:addU16(mission.id)
		msg:addString(quest.name)
		msg:addString(mission:getName(self))
		msg:addString(mission:getDescription(self))
	end

	msg:sendToPlayer(self)
	msg:delete()
	return true
end

function Player.sendUpdateQuestTracker(self, mission)
	local msg = NetworkMessage()
	msg:addByte(0xD0)
	msg:addByte(0)

	msg:addU16(mission.id)
	msg:addString(mission:getName(self))
	msg:addString(mission:getDescription(self))

	msg:sendToPlayer(self)
	msg:delete()
	return true
end

function Player.getBestiaryKills(self, raceId)
	return math.max(0, self:getStorageValue(PlayerStorageKeys.bestiaryKillsBase + raceId))
end

function Player.setBestiaryKills(self, raceId, value)
	return self:setStorageValue(PlayerStorageKeys.bestiaryKillsBase + raceId, value)
end

function Player.addBestiaryKills(self, raceId)
	local monsterType = MonsterType(raceId)
	if not monsterType then
		return false
	end

	local kills = self:getBestiaryKills(raceId)
	local newKills = kills + 1
	local bestiaryInfo = monsterType:getBestiaryInfo()
	for _, totalKills in pairs({bestiaryInfo.prowess, bestiaryInfo.expertise, bestiaryInfo.mastery}) do
		if kills == 0 or (kills < totalKills and newKills >= totalKills) then
			self:sendTextMessage(MESSAGE_EVENT_DEFAULT, string.format("You unlocked details for the creature %s.", monsterType:getName()))
			self:sendBestiaryMilestoneReached(raceId)
			break
		end
	end
	return self:setBestiaryKills(raceId, newKills)
end

function Player.sendBestiaryMilestoneReached(self, raceId)
	local msg = NetworkMessage()
	msg:addByte(0xD9)
	msg:addU16(raceId)
	msg:sendToPlayer(self)
	msg:delete()
	return true
end

local function getStaminaBonus(staminaMinutes)
	if staminaMinutes > 2340 then
		return 150
	elseif staminaMinutes < 840 then
		return 50
	else
		return 100
	end
end

function Player.updateClientExpDisplay(self)
	-- Experience bonus (includes server rates)
	local expGainRate = 100 * Game.getExperienceStage(self:getLevel())
	self:setClientExpDisplay(expGainRate)

	-- Stamina bonus
	local staminaMinutes = self:getStamina()
	local staminaBonus = getStaminaBonus(staminaMinutes)
	self:setClientStaminaBonusDisplay(staminaBonus)
	return true
end

function Player.sendHighscores(self, entries, params)
	local msg = NetworkMessage()
	msg:addByte(0xB1)

	msg:addByte(params.action)

	msg:addByte(0x01)
	msg:addString(configManager.getString(configKeys.SERVER_NAME))
	msg:addString(params.world)

	msg:addByte(params.worldType)
	msg:addByte(params.battlEye)

	local vocations = Game.getUnpromotedVocations()
	msg:addByte(#vocations + 1)

	msg:addU32(0xFFFFFFFF)
	msg:addString("All vocations")

	for _, vocation in ipairs(vocations) do
		msg:addU32(vocation:getId())
		msg:addString(vocation:getName())
	end

	msg:addU32(params.vocation)

	msg:addByte(#HIGHSCORES_CATEGORIES)
	for id, category in ipairs(HIGHSCORES_CATEGORIES) do
		msg:addByte(id)
		msg:addString(category.name)
	end

	msg:addByte(params.category)

	msg:addU16(params.page)
	msg:addU16(params.totalPages)

	msg:addByte(#entries.data)
	for _, entry in pairs(entries.data) do
		msg:addU32(entry.rank)
		msg:addString(entry.name)
		msg:addString(entry.title)
		msg:addByte(entry.vocation)
		msg:addString(entry.world)
		msg:addU16(entry.level)
		msg:addByte(self:getGuid() == entry.id and 0x01 or 0x00)
		msg:addU64(entry.points)
	end

	msg:addByte(0xFF) -- unknown
	msg:addByte(0x00) -- display loyalty title column
	msg:addByte(HIGHSCORES_CATEGORIES[params.category].type or 0x00)

	msg:addU32(entries.ts)

	msg:sendToPlayer(self)
	msg:delete()
	return true
end

function Player.takeScreenshot(self, screenshotType, ignoreConfig)
	if not ignoreConfig and (screenshotType < SCREENSHOT_TYPE_FIRST or screenshotType > SCREENSHOT_TYPE_LAST) then
		return false
	end

	local msg = NetworkMessage()
	msg:addByte(0x75)
	msg:addByte(screenshotType)
	msg:sendToPlayer(self)
	msg:delete()
	return true
end

function Player.getBlessings(self)
	local blessings = 0
	for i = 1, 6 do
		if self:hasBlessing(i) then
			blessings = blessings + 1
		end
	end
	return blessings
end

local slots = {
	CONST_SLOT_RIGHT,
	CONST_SLOT_LEFT,
	CONST_SLOT_HEAD,
	CONST_SLOT_NECKLACE,
	CONST_SLOT_ARMOR,
	CONST_SLOT_LEGS,
	CONST_SLOT_FEET,
	CONST_SLOT_RING
}

function Player.getTotalArmor(self)
	local total = 0
	local item
	for i = 1, #slots do
		item = self:getSlotItem(slots[i])
		if item then
			total = total + item:getType():getArmor()
		end
	end
	return total
end

function Player.getTotalDefense(self)
	local total = 0
	local item
	for i = 1, #slots do
		item = self:getSlotItem(slots[i])
		if item then
			total = total + item:getType():getDefense()
		end
	end
	return total
end
