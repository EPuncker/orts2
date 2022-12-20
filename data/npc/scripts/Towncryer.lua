local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)			npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()							npcHandler:onThink()						end

local voices = {
	{ text = "Hear me! Hear me! The mage Wyrdin in the Edron academy is looking for brave adventurers to undertake a task!" },
	{ text = "Hear me! Hear me! The postmaster\'s guild has open spots for aspiring postmen! Contact Kevin Postner at the post office in the plains south of Kazordoon!" },
	{ text = "Hear me! Hear me! The inquisition is looking for daring people to fight evil! Apply at the inquisition headquarters next to the Thaian jail!" }
}

local worldChanges = {
	{ storage = GlobalStorageKeys.WorldBoard.Yasir, text = "Hear ye! Hear ye! What a lucky and beautiful day! Visit Carlin, Ankrahmun, or Liberty Bay. Yasir, the oriental trader might be there. Gather your creature products, for this chance is rare." },
	{ storage = GlobalStorageKeys.WorldBoard.NightmareIsle.ankrahmunNorthEasttext, text = "In Ankrahmun's desert, a storm has revealed the entry to a nightmare that can't be sealed. Horrible creatures there spell instant death to all young adventurers who dare take a breath!" },
	{ storage = GlobalStorageKeys.WorldBoard.NightmareIsle.darashiaNorthtext, text = "Near Darashia's coast, a storm has revealed the entry to a nightmare that can't be sealed. Horrible creatures there spell instant death to all young adventurers who dare take a breath!" },
	{ storage = GlobalStorageKeys.WorldBoard.NightmareIsle.darashiaNorthWest, text = "Near Drefia's mountains, a storm has revealed the entry to a nightmare that can't be sealed. Horrible creatures there spell instant death to all young adventurers who dare take a breath!" }
}

for i = 1, #worldChanges do
	if getGlobalStorageValue(worldChanges[i].storage) > 0 then
		table.insert(voices, {text = worldChanges[i].text})
	end
end

npcHandler:addModule(VoiceModule:new(voices))
