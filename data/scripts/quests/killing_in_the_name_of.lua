local kills = CreatureEvent("KillingInTheNameOfKills")

function kills.onKill(creature, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	local targetName, startedTasks, taskId = target:getName():lower(), player:getStartedTasks()
	for i = 1, #startedTasks do
		taskId = startedTasks[i]
		if table.contains(tasks[taskId].creatures, targetName) then
			local killAmount = player:getStorageValue(KILLSSTORAGE_BASE + taskId)
			if killAmount < tasks[taskId].killsRequired then
				player:setStorageValue(KILLSSTORAGE_BASE + taskId, killAmount + 1)
			end
		end
	end
	return true
end

kills:register()
