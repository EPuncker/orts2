local createCobraFlask = GlobalEvent("Create Cobra Flask")

function createCobraFlask.onThink(interval)
	local position = Position(33395, 32666, 5)
	local flask = Tile(position):getItemById(33952)
	if not flask then
		Game.createItem(33952, 1, position)
	end

	return true
end

createCobraFlask:interval(1000 * 60 * 60 * 8)
createCobraFlask:register()
