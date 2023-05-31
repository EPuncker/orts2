local rayOfLight = Action()

function rayOfLight.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.UnnaturalSelection.Mission05) == 1 then
		player:setStorageValue(PlayerStorageKeys.UnnaturalSelection.Questline, 11)
		player:setStorageValue(PlayerStorageKeys.UnnaturalSelection.Mission05, 2) --Questlog, Unnatural Selection Quest "Mission 5: Ray of Light"
		player:say("A ray of sunlight comes down from the heaven and hits the crystal. Wow. That probably means Fasuon is supporting.", TALKTYPE_MONSTER_SAY)
		toPosition:sendMagicEffect(CONST_ME_HOLYAREA)
	end
	return true
end

rayOfLight:uid(12335)
rayOfLight:register()

local allAroundtheWorld = MoveEvent()

local config = {
	[1] = {text = 'You hold the skull up high. You can resist the urge to have it look through a telescope though.', position = Position(33263, 31834, 1)},
	[2] = {text = 'You hold up the skull and let it take a peek over the beautiful elven town through the dense leaves.', position = Position(32711, 31668, 1)},
	[3] = {text = 'Thanita gives you a really strange look as you hold up the skull, but oh well.', position = Position(32537, 31772, 1)},
	[4] = {text = 'That was a real easy one. And you are used to getting strange looks now, so whatever!', position = Position(33216, 32450, 1)},
	[5] = {text = 'Wow, it\'s hot up here. Luckily the skull can\'t get a sunburn any more, but you can, so you better descend again!', position = Position(33151, 32845, 2)},
	[6] = {text = 'Considering that higher places around here aren\'t that easy to reach, you think the view from here is tolerably good.', position = Position(32588, 32801, 4)},
	[7] = {text = 'Yep, that\'s a pretty high spot. If Lazaran ever sees what the skull sees, he\'d be pretty satisfied with that nice view.', position = Position(32346, 32808, 2)},
	[8] = {text = 'Well, there are higher spots around here, but none of them is as easily reachable as this one. It just has to suffice.', position = Position(32789, 31238, 3)},
	[9] = {text = 'Nice! White in white as far as the eye can see. Time to leave before your fingers turn into icicles.', position = Position(32236, 31096, 2)},
	[10] = {text = 'That\'s definitely one of the highest spots in whole Tibia. If that\'s not simply perfect you don\'t know what it is.', position = Position(32344, 32265, 0)},
	[11] = {text = 'What a beautiful view. Worthy of a Queen indeed! Time to head back to Lazaran and show him what you got.', position = Position(32316, 31752, 0)}
}

function allAroundtheWorld.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetValue = config[player:getStorageValue(PlayerStorageKeys.UnnaturalSelection.Mission02)]
	if not targetValue then
		return true
	end

	if player:getPosition() == targetValue.position and player:getItemCount(11076) >= 1 then --Questlog, Unnatural Selection Quest 'Mission 2: All Around the World'
		player:setStorageValue(PlayerStorageKeys.UnnaturalSelection.Mission02, player:getStorageValue(PlayerStorageKeys.UnnaturalSelection.Mission02) + 1)
		player:say(targetValue.text, TALKTYPE_MONSTER_SAY)
	end
	return true
end

allAroundtheWorld:type("stepin")
allAroundtheWorld:aid(12332)
allAroundtheWorld:register()

local danceEvolution = MoveEvent()

local config = {
	[1] = Position(32991, 31497, 1),
	[2] = Position(32990, 31498, 1),
	[3] = Position(32991, 31497, 1),
	[4] = Position(32992, 31498, 1),
	[5] = Position(32991, 31497, 1),
	[6] = Position(32991, 31498, 1),
	[7] = Position(32990, 31497, 1),
	[8] = Position(32991, 31496, 1),
	[9] = Position(32992, 31497, 1),
	[10] = Position(32991, 31496, 1),
	[11] = Position(32991, 31497, 1),
	[12] = Position(32990, 31496, 1),
	[13] = Position(32991, 31497, 1),
	[14] = Position(32992, 31496, 1),
	[15] = Position(32991, 31497, 1),
	[16] = Position(32991, 31496, 1)
}

function danceEvolution.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local dancePosition = config[player:getStorageValue(PlayerStorageKeys.UnnaturalSelection.DanceStatus)]
	if not dancePosition then
		return true
	end

	if position ~= dancePosition then
		player:setStorageValue(PlayerStorageKeys.UnnaturalSelection.DanceStatus, 1)
		player:say('You did it wrong. now you have to start again.', TALKTYPE_MONSTER_SAY)
		config[1]:sendMagicEffect(CONST_ME_SMALLPLANTS)
		return true
	end

	local danceStatus = player:getStorageValue(PlayerStorageKeys.UnnaturalSelection.DanceStatus)
	if danceStatus == 1 then
		player:say('Dance for the mighty Krunus!', TALKTYPE_MONSTER_SAY)
	end

	player:setStorageValue(PlayerStorageKeys.UnnaturalSelection.DanceStatus, danceStatus + 1) --Questlog, Unnatural Selection Quest Mission 2: All Around the World

	local nextpos = config[player:getStorageValue(PlayerStorageKeys.UnnaturalSelection.DanceStatus)]
	if nextpos then
		nextpos:sendMagicEffect(CONST_ME_SMALLPLANTS)
	end

	if danceStatus + 1 > #config then --Questlog, Unnatural Selection Quest Mission 3: Dance Dance Evolution
		player:setStorageValue(PlayerStorageKeys.UnnaturalSelection.Mission03, 3)
		player:setStorageValue(PlayerStorageKeys.UnnaturalSelection.Questline, 7)
		player:say('Krunus should be pleased.', TALKTYPE_MONSTER_SAY)
		player:addAchievement('Talented Dancer')
	end
	return true
end

danceEvolution:type("stepin")
danceEvolution:aid(12333)
danceEvolution:register()
