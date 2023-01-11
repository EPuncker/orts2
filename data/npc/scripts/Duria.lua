local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)			npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()							npcHandler:onThink()						end

-- Spells Keyword:
keywordHandler:addSpellKeyword({'find person'}, {npcHandler = npcHandler, spellName = "Find Person", price = 80, level = 8, vocation = VOCATION_KNIGHT})
keywordHandler:addSpellKeyword({'light'}, {npcHandler = npcHandler, spellName = "Light", price = 0, level = 8, vocation = VOCATION_KNIGHT})
keywordHandler:addSpellKeyword({'cure poison'}, {npcHandler = npcHandler, spellName = "Cure Poison", price = 150, level = 10, vocation = VOCATION_KNIGHT})
keywordHandler:addSpellKeyword({'wound cleansing'}, {npcHandler = npcHandler, spellName = "Wound Cleansing", price = 0, level = 8, vocation = VOCATION_KNIGHT})
keywordHandler:addSpellKeyword({'great light'}, {npcHandler = npcHandler, spellName = "Great Light", price = 500, level = 13, vocation = VOCATION_KNIGHT})

-- Transcripts:
keywordHandler:addKeyword({'healing spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have {Wound Cleansing} and {Cure Poison}."})
keywordHandler:addKeyword({'support spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have {Light}, {Find Person} and {Great Light}."})
keywordHandler:addKeyword({'spells'}, StdModule.say, {npcHandler = npcHandler, text = "I can teach you {healing spells} and {support spells}. What kind of spell do you wish to learn? You can also tell me for which level you would like to learn a spell, if you prefer that."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Can teach ye' spells for all mag levels up to 3. In what level do you want to learn a {spell}?"})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "I am Duria Steelbender, daughter of Fire, of the Dragoneaters"})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Bah, to much plants and stuff, to few tunnels if you'd ask me."})
keywordHandler:addKeyword({'knights'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Knights are proud of being dwarfs, jawoll."})
keywordHandler:addKeyword({'heroes'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Heroes are rare in this days, jawoll."})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Was there once. Can't handle the crime overthere."})
keywordHandler:addKeyword({'spell'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Can teach ye' spells for all mag levels up to 3. In what level do you want to learn a {spell}?"})

-- Set Message:
npcHandler:setMessage(MESSAGE_GREET, 'Hiho, fellow knight |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Goodbye.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Be carefull out there, jawoll.')

npcHandler:addModule(FocusModule:new())
