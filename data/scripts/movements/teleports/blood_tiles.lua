local bloodTiles = MoveEvent()

function bloodTiles.onAddItem(moveitem, tileitem, position)
	local tileExceptions = {Position(33023, 32330, 10), Position(33023, 32331, 10), Position(33024, 32332, 10), Position(33025, 32332, 10)}
	if table.contains(tileExceptions, position) then
		return true
	end

	moveitem:remove()
	position:sendMagicEffect(CONST_ME_DRAWBLOOD)
	return true
end

bloodTiles:type("additem")
bloodTiles:id(20932, 20933, 20934, 20935, 20936, 20937)
bloodTiles:register()
