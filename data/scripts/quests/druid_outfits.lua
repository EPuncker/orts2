local flowerPosition = Position(32024, 32830, 4)

local function decayFlower()
	local item = Tile(flowerPosition):getItemById(5659)
	if item then
		item:transform(5687)
	end
end

local function bloom()
	if math.random(7) ~= 1 then
		addEvent(bloom, 60 * 60 * 1000)
		return
	end

	local item = Tile(flowerPosition):getItemById(5687)
	if item then
		item:transform(5659)
		flowerPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
	end

	local bloomHours = math.random(2, 6)
	addEvent(decayFlower, bloomHours * 60 * 60 * 1000)
	addEvent(bloom, bloomHours * 60 * 60 * 1000)
end

local bloomingGriffinclaw = GlobalEvent("GriffinclawFlower")

function bloomingGriffinclaw.onStartup()
	bloom()
	return true
end

bloomingGriffinclaw:register()

local waterSkin = Action()

function waterSkin.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 5663 then
		return false
	end

	toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
	item:transform(5939)
	return true
end

waterSkin:id(5938)
waterSkin:register()
