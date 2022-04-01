function Monster:onDropLoot(corpse)
	local player = Player(corpse:getCorpseOwner())
	if player then
		player:updateKillTracker(self, corpse)
	end
	if hasEventCallback(EVENT_CALLBACK_ONDROPLOOT) then
		EventCallback(EVENT_CALLBACK_ONDROPLOOT, self, corpse)
	end
end

function Monster:onSpawn(position, startup, artificial)
	if hasEventCallback(EVENT_CALLBACK_ONSPAWN) then
		return EventCallback(EVENT_CALLBACK_ONSPAWN, self, position, startup, artificial)
	else
		return true
	end
end
