local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local choose = {}
local cancel = {}
local available = {}

local grizzlyAdamsConfig = {
	ranks = {
		--NOTE: The variable "name" is not necessary to be declared. I let it so people who wants to change the script will now wich item is each one.
		huntsMan_rank = {
			{id = 11208, buy = 0, sell = 50, name = "antlers"},
			{id = 10549, buy = 0, sell = 100, name = "bloody pincers"},
			{id = 11183, buy = 0, sell = 35, name = "crab pincers"},
			{id = 10573, buy = 0, sell = 55, name = "cyclops toe"},
			{id = 10564, buy = 0, sell = 30, name = "frosty ear of a troll"},
			{id = 11193, buy = 0, sell = 600, name = "hydra head"},
			{id = 11366, buy = 0, sell = 80, name = "lancer beetle shell"},
			{id = 10578, buy = 0, sell = 420, name = "mutated bat ear"},
			{id = 11222, buy = 0, sell = 400, name = "sabretooth"},
			{id = 11367, buy = 0, sell = 20, name = "sandcrawler shell"},
			{id = 10547, buy = 0, sell = 280, name = "scarab pincers"},
			{id = 11365, buy = 0, sell = 60, name = "terramite legs"},
			{id = 11363, buy = 0, sell = 170, name = "terramite shell"},
			{id = 11184, buy = 0, sell = 95, name = "terrorbird beak"},

			{id = 7398, buy = 0, sell=500, name = "cyclops trophy"},
			{id = 11315, buy = 0, sell=15000, name = "draken trophy"},
			{id = 11336, buy = 0, sell=8000, name = "lizard trophy"},
			{id = 7401, buy = 0, sell=500, name = "minotaur trophy"}
		},

		bigGameHunter_rank = {
			{id = 7397, buy = 0, sell = 3000, name = "deer trophy"},
			{id = 7400, buy = 0, sell = 3000, name = "lion trophy"},
			{id = 7394, buy = 0, sell = 3000, name = "wolf trophy"}
		},

		trophyHunter_rank = {
			{id = 7393, buy = 0, sell = 40000, name = "demon trophy"},
			{id = 7396, buy = 0, sell = 20000, name = "behemoth trophy"},
			{id = 7399, buy = 0, sell = 10000, name = "dragon lord trophy"},

			{id = 10518, buy = 1000, sell = 0, name = "demon backpack"},
		},
	}
}

local items, data = {}
for i = 1, #grizzlyAdamsConfig.ranks.huntsMan_rank do
	data = grizzlyAdamsConfig.ranks.huntsMan_rank[i]
	items[data.id] = {id = data.id, buy = data.buy, sell = data.sell, name = ItemType(data.id):getName():lower()}
end
for i = 1, #grizzlyAdamsConfig.ranks.bigGameHunter_rank do
	data = grizzlyAdamsConfig.ranks.bigGameHunter_rank[i]
	items[data.id] = {id = data.id, buy = data.buy, sell = data.sell, name = ItemType(data.id):getName():lower()}
end
for i = 1, #grizzlyAdamsConfig.ranks.trophyHunter_rank do
	data = grizzlyAdamsConfig.ranks.trophyHunter_rank[i]
	items[data.id] = {id = data.id, buy = data.buy, sell = data.sell, name = ItemType(data.id):getName():lower()}
end

local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(JOIN_STOR) == -1 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome |PLAYERNAME|. Would you like to join the 'Paw and Fur - Hunting Elite'?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back old chap. What brings you here this time?")
	end
	return true
end

local function joinTables(old, new)
	for k, v in pairs(new) do
		old[k] = v
	end
	return old
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then return false end

	local player = Player(cid)
	if msgcontains("trade", msg) then
		local tradeItems = {}
		if player:getPawAndFurRank() >= 2 then
			tradeItems = grizzlyAdamsConfig.ranks.huntsMan_rank
			if player:getPawAndFurRank() == 4 then
				tradeItems = joinTables(tradeItems, grizzlyAdamsConfig.ranks.bigGameHunter_rank)
			elseif player:getPawAndFurRank() == 5 or player:getPawAndFurRank() == 6 then
				tradeItems = joinTables(tradeItems, grizzlyAdamsConfig.ranks.bigGameHunter_rank)
				tradeItems = joinTables(tradeItems, grizzlyAdamsConfig.ranks.trophyHunter_rank)
			end
			openShopWindow(cid, tradeItems, onBuy, onSell)
			return npcHandler:say("It's my offer.", cid)
		else
			return npcHandler:say("You don't have any rank.", cid)
		end
	elseif (msgcontains("join", msg) or msgcontains("yes", msg))
			and npcHandler.topic[cid] == 0
			and player:getStorageValue(JOIN_STOR) ~= 1 then
		player:setStorageValue(JOIN_STOR, 1)
		npcHandler:say("Great!", cid)
	elseif table.contains({"tasks", "task", "mission"}, msg:lower()) then
		local can = player:getTasks()
		if player:getStorageValue(JOIN_STOR) == -1 then
			return npcHandler:say("You'll have to {join}, to get any {tasks}.",cid)
		end
		if #can > 0 then
			local text = ""
			local sep = ", "
			table.sort(can, function(a, b) return a < b end)
			local t = 0
			local id
			for i = 1, #can do
				id = can[i]
				t = t + 1
				if t == #can - 1 then
					sep = " and "
				elseif t == #can then
					sep = "."
				end
				text = text .. "{" .. (tasks[id].name or tasks[id].raceName) .. "}" .. sep
			end
			npcHandler:say("The current task" .. (#can > 1 and "s" or "") .. " that you can choose " .. (#can > 1 and "are" or "is") .. " " .. text, cid)
			npcHandler.topic[cid] = 0
		else
			npcHandler:say("I don't have any task for you right now.", cid)
		end
	elseif msg ~= "" and player:canStartTask(msg) then
		if #player:getStartedTasks() >= tasksByPlayer then
			npcHandler:say("Sorry, but you already started " .. tasksByPlayer .. " tasks. You can check their {status} or {cancel} a task.", cid)
			return true
		end
		local task = getTaskByName(msg)
		if task and player:getStorageValue(QUESTSTORAGE_BASE + task) > 0 then
			return false
		end
		npcHandler:say("In this task you must defeat " .. tasks[task].killsRequired .. " " .. tasks[task].raceName .. ". Are you sure that you want to start this task?", cid)
		choose[cid] = task
		npcHandler.topic[cid] = 1
	elseif msg:lower() == "yes" and npcHandler.topic[cid] == 1 then
		player:setStorageValue(QUESTSTORAGE_BASE + choose[cid], 1)
		player:setStorageValue(KILLSSTORAGE_BASE + choose[cid], 0)
		npcHandler:say("Excellent! You can check the {status} of your task saying {report} to me. Also you can {cancel} tasks to.", cid)
		choose[cid] = nil
		npcHandler.topic[cid] = 0
	elseif msgcontains("status", msg) then
		local started = player:getStartedTasks()
		if started and #started > 0 then
			local text = ""
			local sep = ", "
			table.sort(started, (function(a, b) return (a < b) end))
			local t = 0
			local id
			for i = 1, #started do
				id = started[i]
				t = t + 1
				if t == #started - 1 then
					sep = " and "
				elseif t == #started then
					sep = "."
				end
				text = text .. "Task name: " .. tasks[id].raceName .. ". Current kills: " .. player:getStorageValue(KILLSSTORAGE_BASE + id) .. ".\n"
			end
			npcHandler:say({"The status of your current tasks is:\n" .. text}, cid)
		else
			npcHandler:say("You haven't started any task yet.", cid)
		end
	elseif msgcontains("report", msg) then
		local started = player:getStartedTasks()
		local finishedAtLeastOne = false
		local finished = 0
		if started and #started > 0 then
			local id, reward
			for i = 1, #started do
				id = started[i]
				if player:getStorageValue(KILLSSTORAGE_BASE + id) >= tasks[id].killsRequired then
					for j = 1, #tasks[id].rewards do
						reward = tasks[id].rewards[j]
						local deny = false
						if reward.storage then
							if player:getStorageValue(reward.storage[1]) >= reward.storage[2] then
								deny = true
							end
						end
						if table.contains({REWARD_MONEY, "money"}, reward.type:lower()) and not deny then
							player:addMoney(reward.value[1])
						elseif table.contains({REWARD_EXP, "exp", "experience"}, reward.type:lower()) and not deny then
							player:addExperience(reward.value[1], true)
						elseif table.contains({REWARD_ACHIEVEMENT, "achievement", "ach"}, reward.type:lower()) and not deny then
							player:addAchievement(reward.value[1])
						elseif table.contains({REWARD_STORAGE, "storage", "stor"}, reward.type:lower()) and not deny then
							player:setStorageValue(reward.value[1], reward.value[2])
						elseif table.contains({REWARD_POINT, "points", "point"}, reward.type:lower()) and not deny then
							player:setStorageValue(POINTSSTORAGE, getPlayerTasksPoints(cid) + reward.value[1])
						elseif table.contains({REWARD_ITEM, "item", "items", "object"}, reward.type:lower()) and not deny then
							player:addItem(reward.value[1], reward.value[2])
						end

						if reward.storage then
							player:setStorageValue(reward.storage[1], reward.storage[2])
						end
					end

					player:setStorageValue(QUESTSTORAGE_BASE + id, (tasks[id].norepeatable and 2 or 0))
					player:setStorageValue(KILLSSTORAGE_BASE + id, -1)
					player:setStorageValue(REPEATSTORAGE_BASE + id, math.max(player:getStorageValue(REPEATSTORAGE_BASE + id), 0))
					player:setStorageValue(REPEATSTORAGE_BASE + id, player:getStorageValue(REPEATSTORAGE_BASE + id) + 1)
					finishedAtLeastOne = true
					finished = finished + 1
				end
			end
			if not finishedAtLeastOne then
				local started = player:getStartedTasks()
				if started and #started > 0 then
					local text = ""
					local sep = ", "
					table.sort(started, (function(a, b) return (a < b) end))
					local t = 0
					local id
					for i = 1, #started do
						id = started[i]
						t = t + 1
						if (t == #started - 1) then
							sep = " and "
						elseif (t == #started) then
							sep = "."
						end
						text = text .. "{" .. (tasks[id].name or tasks[id].raceName) .. "}" .. sep
					end
					npcHandler:say("The current task" .. (#started > 1 and "s" or "") .. " that you started " .. (#started > 1 and "are" or "is") .. " " .. text, cid)
				end
			else
				npcHandler:say("Awesome! you finished " .. (finished > 1 and "various" or "a") .. " task" .. (finished > 1 and "s" or "") .. ". Talk to me again if you want to start a {task}.", cid)
			end
		else
			npcHandler:say("You haven't started any task yet.", cid)
		end
	elseif msg:lower() == "started" then
		local started = player:getStartedTasks()
		if started and #started > 0 then
			local text = ""
			local sep = ", "
			table.sort(started, (function(a, b) return (a < b) end))
			local t = 0
			local id
			for i = 1, #started do
				id = started[i]
				t = t + 1
				if t == #started - 1 then
					sep = " and "
				elseif t == #started then
					sep = "."
				end
				text = text .. "{" .. (tasks[id].name or tasks[id].raceName) .. "}" .. sep
			end

			npcHandler:say("The current task" .. (#started > 1 and "s" or "") .. " that you started " .. (#started > 1 and "are" or "is") .. " " .. text, cid)
		else
			npcHandler:say("You haven't started any task yet.", cid)
		end
	elseif msg:lower() == "cancel" then
		local started = player:getStartedTasks()
		local task = getTaskByName(msg)
		local text = ""
		local sep = ", "
		table.sort(started, (function(a, b) return (a < b) end))
		local t = 0
		local id
		for i = 1, #started do
			id = started[i]
			t = t + 1
			if t == #started - 1 then
				sep = " or "
			elseif t == #started then
				sep = "?"
			end
			text = text .. "{" .. (tasks[id].name or tasks[id].raceName) .. "}" .. sep
		end
		if started and #started > 0 then
			npcHandler:say("Cancelling a task will make the counter restart. Which of these tasks you want cancel?" .. (#started > 1 and "" or "") .. " " .. text, cid)
			npcHandler.topic[cid] = 2
		else
			npcHandler:say("You haven't started any task yet.", cid)
		end
	elseif getTaskByName(msg) and npcHandler.topic[cid] == 2 and table.contains(getPlayerStartedTasks(cid), getTaskByName(msg)) then
		local task = getTaskByName(msg)
		if player:getStorageValue(KILLSSTORAGE_BASE + task) > 0 then
			npcHandler:say("You currently killed " .. player:getStorageValue(KILLSSTORAGE_BASE + task) .. "/" .. tasks[task].killsRequired .. " " .. tasks[task].raceName .. ". Cancelling this task will restart the count. Are you sure you want to cancel this task?", cid)
		else
			npcHandler:say("Are you sure you want to cancel this task?", cid)
		end
		npcHandler.topic[cid] = 3
		cancel[cid] = task
	elseif getTaskByName(msg) and npcHandler.topic[cid] == 1 and table.contains(getPlayerStartedTasks(cid), getTaskByName(msg)) then
		local task = getTaskByName(msg)
		if player:getStorageValue(KILLSSTORAGE_BASE + task) > 0 then
			npcHandler:say("You currently killed " .. player:getStorageValue(KILLSSTORAGE_BASE + task) .. "/" .. tasks[task].killsRequired .. " " .. tasks[task].raceName .. ".", cid)
		else
			npcHandler:say("You currently killed 0/" .. tasks[task].killsRequired .. " " .. tasks[task].raceName .. ".", cid)
		end
		npcHandler.topic[cid] = 0
	elseif msg:lower() == "yes" and npcHandler.topic[cid] == 3 then
		player:setStorageValue(QUESTSTORAGE_BASE + cancel[cid], -1)
		player:setStorageValue(KILLSSTORAGE_BASE + cancel[cid], -1)
		npcHandler:say("You have cancelled the task " .. (tasks[cancel[cid]].name or tasks[cancel[cid]].raceName) .. ".", cid)
		npcHandler.topic[cid] = 0
	elseif table.contains({"points", "rank"}, msg:lower()) then
		if player:getPawAndFurPoints() < 1 then
			npcHandler:say("At this time, you have " .. player:getPawAndFurPoints() .. " Paw & Fur points. You " .. (player:getPawAndFurRank() == 6 and "are an Elite Hunter" or player:getPawAndFurRank() == 5 and "are a Trophy Hunter" or player:getPawAndFurRank() == 4 and "are a Big Game Hunter" or player:getPawAndFurRank() == 3 and "are a Ranger" or player:getPawAndFurRank() == 2 and "are a Huntsman" or player:getPawAndFurRank() == 1 and "are a Member" or "haven't been ranked yet") .. ".", cid)
		else
			npcHandler:say("At this time, you have " .. player:getPawAndFurPoints() .. " Paw & Fur points. You " .. (player:getPawAndFurRank() == 6 and "are an Elite Hunter" or player:getPawAndFurRank() == 5 and "are a Trophy Hunter" or player:getPawAndFurRank() == 4 and "are a Big Game Hunter" or player:getPawAndFurRank() == 3 and "are a Ranger" or player:getPawAndFurRank() == 2 and "are a Huntsman" or player:getPawAndFurRank() == 1 and "are a Member" or "haven't been ranked yet") .. ".", cid)
		end
		npcHandler.topic[cid] = 0
	elseif table.contains({"special task"}, msg:lower()) then
		if player:getPawAndFurPoints() >= 90 then -- Tiquandas Revenge 90 points
			if player:getStorageValue(PlayerStorageKeys.KillingInTheNameOf.MissionTiquandasRevenge) == 1 then -- Check if he has already started the task.
				npcHandler:say("You have already started the task. Go find Tiquandas Revenge and take revenge yourself!", cid)
			else
				npcHandler:say({
					"Have you heard about Tiquandas Revenge? It is said that the jungle itself is alive and takes revenge for all the bad things people have done to it. ...",
					"I myself believe that there is some truth in this clap trap. Something 'real' which therefore must have a hideout somewhere. Go find it and take revenge yourself!"
				}, cid)
				player:setStorageValue(PlayerStorageKeys.KillingInTheNameOf.TiquandasRevengeTeleport, 1) -- Task needed to enter Tiquandas Revenge TP
				player:setStorageValue(PlayerStorageKeys.KillingInTheNameOf.MissionTiquandasRevenge, 1) -- Won't give this task again.
			end
		end
		if player:getPawAndFurPoints() >= 100 then -- Demodras 100 points
			if player:getStorageValue(PlayerStorageKeys.KillingInTheNameOf.MissionDemodras) == 1 then -- Check if he has already started the task.
				npcHandler:say("You have already started the special task. Find Demodras and kill it.", cid)
			else
				npcHandler:say("This task is a very dangerous one. I want you to look for Demodras' hideout. It might be somewhere under the Plains of Havoc. Good luck, old chap.", cid)
				player:setStorageValue(PlayerStorageKeys.KillingInTheNameOf.DemodrasTeleport, 1) -- Task needed to enter Demodras TP
				player:setStorageValue(PlayerStorageKeys.KillingInTheNameOf.MissionDemodras, 1) -- Won't give this task again.
			end
		end
		npcHandler.topic[cid] = 0
	end
end

local function onBuy(cid, item, subType, amount, ignoreCap, inBackpacks)
	local player = Player(cid)
	if (ignoreCap == false and (player:getFreeCapacity() < ItemType(items[item].id):getWeight(amount) or inBackpacks and player:getFreeCapacity() < (ItemType(items[item].id):getWeight(amount) + ItemType(ITEM_SHOPPING_BAG):getWeight()))) then
		return player:sendTextMessage(MESSAGE_STATUS_SMALL, "You don't have enough capacity.")
	end
	if items[item].buy <= player:getTotalMoney() then
		if inBackpacks then
			local container = Game.createItem(ITEM_SHOPPING_BAG, 1)
			local bp = player:addItemEx(container)
			if bp ~= 1 then
				return player:sendTextMessage(MESSAGE_STATUS_SMALL, "You don't have enough space in your container.")
			end
			for i = 1, amount do
				container:addItem(items[item].id, items[item])
			end
		else
			return
			player:addItem(items[item].id, amount, false, items[item]) and
			player:removeTotalMoney(amount * items[item].buy) and
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Bought "..amount.."x "..items[item].realName.." for "..items[item].buy * amount.." gold.")
		end
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Bought "..amount.."x "..items[item].realName.." for "..items[item].buy * amount.." gold.")
		player:removeTotalMoney(amount * items[item].buy)
	else
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "You do not have enough money.")
	end
	return true
end

local function onSell(cid, item, subType, amount, ignoreCap, inBackpacks)
	local player = Player(cid)
	if items[item].sell then
		player:addMoney(items[item].sell * amount)
		player:removeItem(items[item].id, amount, -1, ignoreEquipped) and
		return player:sendTextMessage(MESSAGE_INFO_DESCR, "Sold "..amount.."x "..items[item].name.." for "..items[item].sell * amount.." gold.")
	end
	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, "Happy hunting, old chap!")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
