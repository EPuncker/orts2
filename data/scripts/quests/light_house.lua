local lightHouseLever = Action()

function lightHouseLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.actionid == 50023 then --first lever to open the ladder
		local laddertile = Tile(Position(32225, 32276, 8))
			if item.itemid == 1945 then
				laddertile:getItemById(9021):transform(8280)
				item:transform(1946)
			else
				laddertile:getItemById(8280):transform(9021)
				item:transform(1945)
			end
	elseif item.actionid == 50024 then --second lever to open the portal to cyclops
		local portaltile = Tile(Position(32232, 32276, 9))
		if item.itemid == 1945 then
			if portaltile:getItemById(1387) then
				portaltile:getItemById(1387):remove()
			else
				local portal = Game.createItem(1387, 1, Position(32232, 32276, 9))
				if portal then
					portal:setActionId(50026)
				end

				item:transform(1946)
			end
		else
			if portaltile:getItemById(1387) then
				portaltile:getItemById(1387):remove()
				item:transform(1945)
			end
		end
	end
	return true
end

lightHouseLever:aid(50023, 50024)
lightHouseLever:register()
