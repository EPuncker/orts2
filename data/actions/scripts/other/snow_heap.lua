function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	Game.createItem(2111, 1, item:getPosition())
	return onUseSpoon(player, item, fromPosition, target, toPosition, isHotkey)
end
