-- Players cannot throw items on teleports if set to true
local blockTeleportTrashing = false

local ec = EventCallback

ec.onMoveItem = function(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if blockTeleportTrashing and toPosition.x ~= CONTAINER_POSITION then
		local thing = Tile(toPosition):getItemByType(ITEM_TYPE_TELEPORT)
		if thing then
			self:sendCancelMessage('Sorry, not possible.')
			self:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end

	if table.contains({1714, 1715, 1716, 1717, 1738, 1740, 1741, 1747, 1748, 1749}, item.itemid) and item.actionid > 0 or item.actionid == 5640 then
		self:sendCancelMessage('You cannot move this object.')
		return false
	elseif item.itemid == 7466 then
		self:sendCancelMessage('You cannot move this object.')
		return false
	end

	if fromPosition.x == CONTAINER_POSITION and toPosition.x == CONTAINER_POSITION and item.itemid == 8710 and self:getItemCount(8710) == 2 and self:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.cockroachLegsMsgStorage) ~= 1 then
		self:sendTextMessage(MESSAGE_INFO_DESCR, 'Well done, you have enough cockroach legs! You should head back to Santiago with them. Climb the ladder to the north to exit.')
		self:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.cockroachLegsMsgStorage, 1)
		self:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 6)
	end

	if item:getAttribute("wrapid") ~= 0 then
		local tile = Tile(toPosition)
		if (fromPosition.x ~= CONTAINER_POSITION and toPosition.x ~= CONTAINER_POSITION) or tile and not tile:getHouse() then
			if tile and not tile:getHouse() then
				return RETURNVALUE_NOTPOSSIBLE
			end
		end
	end

	if toPosition.x ~= CONTAINER_POSITION then
		return RETURNVALUE_NOERROR
	end

	if item:getTopParent() == self and bit.band(toPosition.y, 0x40) == 0 then
		local itemType, moveItem = ItemType(item:getId())
		if bit.band(itemType:getSlotPosition(), SLOTP_TWO_HAND) ~= 0 and toPosition.y == CONST_SLOT_LEFT then
			moveItem = self:getSlotItem(CONST_SLOT_RIGHT)
		elseif itemType:getWeaponType() == WEAPON_SHIELD and toPosition.y == CONST_SLOT_RIGHT then
			moveItem = self:getSlotItem(CONST_SLOT_LEFT)
			if moveItem and bit.band(ItemType(moveItem:getId()):getSlotPosition(), SLOTP_TWO_HAND) == 0 then
				return RETURNVALUE_NOERROR
			end
		end

		if moveItem then
			local parent = item:getParent()
			if parent:isContainer() and parent:getSize() == parent:getCapacity() then
				return RETURNVALUE_CONTAINERNOTENOUGHROOM
			else
				return moveItem:moveTo(parent) and RETURNVALUE_NOERROR or RETURNVALUE_NOTPOSSIBLE
			end
		end
	end

	return RETURNVALUE_NOERROR
end
ec:register()
