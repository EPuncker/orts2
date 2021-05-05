local function doTransformCoalBasins(cbPos)
	local tile = Position(cbPos):getTile()
	if tile then
		local thing = tile:getItemById(1485)
		if thing then
			thing:transform(1484)
		end
	end
end

local config = {
	[0] = 50015,
	[1] = 50016,
	[2] = 50017,
	[3] = 50018,
	[4] = 50019,
	coalBasins = {
		Position(32214, 31850, 15),
		Position(32215, 31850, 15),
		Position(32216, 31850, 15)
	},
	effects = {
		[0] = {
			Position(32217, 31845, 14),
			Position(32218, 31845, 14),
			Position(32219, 31845, 14),
			Position(32220, 31845, 14),
			Position(32217, 31843, 14),
			Position(32218, 31842, 14),
			Position(32219, 31841, 14)
		},
		[1] = {
			Position(32217, 31844, 14),
			Position(32218, 31844, 14),
			Position(32219, 31843, 14),
			Position(32220, 31845, 14),
			Position(32219, 31845, 14)
		},
		[2] = {
			Position(32217, 31842, 14),
			Position(32219, 31843, 14),
			Position(32219, 31845, 14),
			Position(32218, 31844, 14),
			Position(32217, 31844, 14),
			Position(32217, 31845, 14)
		},
		[3] = {
			Position(32217, 31845, 14),
			Position(32218, 31846, 14),
			Position(32218, 31844, 14),
			Position(32219, 31845, 14),
			Position(32220, 31846, 14)
		},
		[4] = {
			Position(32219, 31841, 14),
			Position(32219, 31842, 14),
			Position(32219, 31846, 14),
			Position(32217, 31843, 14),
			Position(32217, 31844, 14),
			Position(32217, 31845, 14),
			Position(32218, 31843, 14),
			Position(32218, 31845, 14)
		},
	},
}


function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local switchNum = Game.getStorageValue("switchNum")
	if switchNum == -1 then
		Game.setStorageValue("switchNum", 0)
	end

	local table = config[switchNum]
	if not table then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.ThirdSeal) < 1 then
		if item.uid == table then
			item:transform(1945)
			Game.setStorageValue("switchNum", math.max(1, Game.getStorageValue("switchNum") + 1))
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			for i = 1, #config.effects[switchNum] do
				Position(config.effects[switchNum][i]):sendMagicEffect(CONST_ME_ENERGYHIT)
			end
			if Game.getStorageValue("switchNum") == 5 then
				for i = 1, #config.coalBasins do
					doTransformCoalBasins(config.coalBasins[i])
				end
			end
		else
			toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
		end
	else
		return false
	end
	return true
end
