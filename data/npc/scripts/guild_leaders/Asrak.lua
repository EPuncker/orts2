local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)			npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)	end
function onThink()							npcHandler:onThink()						end

-- Spells Keyword:
keywordHandler:addSpellKeyword({"arrow call"}, {npcHandler = npcHandler, spellName = "Arrow Call", price = 0, level = 1, vocation = VOCATION_PALADIN})
keywordHandler:addSpellKeyword({"bruise bane"}, {npcHandler = npcHandler, spellName = "Bruise Bane", price = 0, level = 1, vocation = VOCATION_KNIGHT})
keywordHandler:addSpellKeyword({"conjure arrow"}, {npcHandler = npcHandler, spellName = "Conjure Arrow", price = 450, level = 13, vocation = VOCATION_PALADIN})
keywordHandler:addSpellKeyword({"conjure explosive arrow"}, {npcHandler = npcHandler, spellName = "Conjure Explosive Arrow", price = 1000, level = 25, vocation = VOCATION_PALADIN})
keywordHandler:addSpellKeyword({"conjure poisoned arrow"}, {npcHandler = npcHandler, spellName = "Conjure Poisoned Arrow", price = 700, level = 16, vocation = VOCATION_PALADIN})
keywordHandler:addSpellKeyword({"cure poison"}, {npcHandler = npcHandler, spellName = "Cure Poison", price = 150, level = 10, vocation = VOCATION_KNIGHT})
keywordHandler:addSpellKeyword({"divine healing"}, {npcHandler = npcHandler, spellName = "Divine Healing", price = 3000, level = 35, vocation = VOCATION_PALADIN})
keywordHandler:addSpellKeyword({"find person"}, {npcHandler = npcHandler, spellName = "Find Person", price = 80, level = 8, vocation = VOCATION_KNIGHT})
keywordHandler:addSpellKeyword({"great light"}, {npcHandler = npcHandler, spellName = "Great Light", price = 500, level = 13, vocation = VOCATION_KNIGHT, VOCATION_PALADIN})
keywordHandler:addSpellKeyword({"intense healing"}, {npcHandler = npcHandler, spellName = "Intense Healing", price = 350, level = 20, vocation = VOCATION_PALADIN})
keywordHandler:addSpellKeyword({"light"}, {npcHandler = npcHandler, spellName = "Light", price = 0, level = 8, vocation = VOCATION_KNIGHT, VOCATION_PALADIN})
keywordHandler:addSpellKeyword({"light healing"}, {npcHandler = npcHandler, spellName = "Light Healing", price = 0, level = 8, vocation = VOCATION_PALADIN})
keywordHandler:addSpellKeyword({"magic patch"}, {npcHandler = npcHandler, spellName = "Magic Patch", price = 0, level = 1, vocation = VOCATION_PALADIN})
keywordHandler:addSpellKeyword({"wound cleansing"}, {npcHandler = npcHandler, spellName = "Wound Cleansing", price = 0, level = 8, vocation = VOCATION_KNIGHT})
keywordHandler:addSpellKeyword({"destroy field rune"}, {npcHandler = npcHandler, spellName = "Destroy Field Rune", price = 700, level = 17, vocation = VOCATION_PALADIN})

-- Transcripts:
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "I am the overseer of the pits and the trainer of the gladiators."})
keywordHandler:addKeyword({"gladiators"}, StdModule.say, {npcHandler = npcHandler, text = "Those wannabe fighters are weak and most of them are unable to comprehend a higher concept like the Mooh'Tah."})
keywordHandler:addKeyword({"help"}, StdModule.say, {npcHandler = npcHandler, text = "I teach worthy warriors the way of the knight."})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = " I am known as Asrak the Ironhoof."})
keywordHandler:addKeyword({"time"}, StdModule.say, {npcHandler = npcHandler, text = "It is 0:00 pm."})
keywordHandler:addKeyword({"king", "tibianus"}, StdModule.say, {npcHandler = npcHandler, text = "Your human army might be big, but without skills. They are only sheep to be slaughtered."})
keywordHandler:addKeyword({"army"}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, I only teach spells to knights and paladins."})
keywordHandler:addKeyword({"spell"}, StdModule.say, {npcHandler = npcHandler, text = "The dungeons of your desires and fears are the only ones you really should fear and those you really have to conquer."})
keywordHandler:addKeyword({"dungeon"}, StdModule.say, {npcHandler = npcHandler, text = " By them we were imbued with the rage that almost costed our existence. By them we were used as pawns in wars that were not ours."})
keywordHandler:addKeyword({"gods"}, StdModule.say, {npcHandler = npcHandler, text = "Inferior creatures of rage, driven by their primitive urges. Only worthy to be noticed to test one's skills."})
keywordHandler:addKeyword({"monsters"}, StdModule.say, {npcHandler = npcHandler, text = "To rely on magic is like to cheat fate. All cheaters will find their just punishment one day, and so will he."})
keywordHandler:addKeyword({"ferumbras"}, StdModule.say, {npcHandler = npcHandler, text = " If it's truly a weapon to slay gods it might be worth to be sought for."})
keywordHandler:addKeyword({"excalibug"}, StdModule.say, {npcHandler = npcHandler, text = "The city pays me well and those undisciplined gladiators need my skills and guidance badly."})
keywordHandler:addKeyword({"venore"}, StdModule.say, {npcHandler = npcHandler, text = "The city is only a shadow of what we could have accomplished without that curse of rage that the gods bestowed upon us."})
keywordHandler:addKeyword({"mintwallin"}, StdModule.say, {npcHandler = npcHandler, text = "In the ancient wars we lost much because of the rage. The one good thing is we lost our trust in the gods, too."})
keywordHandler:addKeyword({"minotaur"}, StdModule.say, {npcHandler = npcHandler, text = "In the ancient wars we lost much because of the rage. The one good thing is we lost our trust in the gods, too."})
keywordHandler:addKeyword({"rage"}, StdModule.say, {npcHandler = npcHandler, text = "Rage is the legacy of Brog, the beast. To overcome it is our primal goal. The Mooh'Tah is our only hope of salvation and perfection."})
keywordHandler:addKeyword({"mooh'tah"}, StdModule.say, {npcHandler = npcHandler, text = "The Mooh'Tah teaches us control. It provides you with weapon, armor, and shield. It teaches you harmony and focus."})
keywordHandler:addKeyword({"harmony"}, StdModule.say, {npcHandler = npcHandler, text = "There is an elegant harmony in every thing done right. If you feel the harmony of an action you can sing its song."})
keywordHandler:addKeyword({"song"}, StdModule.say, {npcHandler = npcHandler, text = "Each harmonic action has it own song. If you can sing it, you are in harmony with that action. This is where the minotaurean battlesongs come from."})
keywordHandler:addKeyword({"battlesongs"}, StdModule.say, {npcHandler = npcHandler, text = "Each Mooh'Tah master focuses his skills on the harmony of battle. He is one with the song that he's singing with his voice or at least his heart."})
keywordHandler:addKeyword({"weapon"}, StdModule.say, {npcHandler = npcHandler, text = "Make your will your weapon, and your enemies will perish."})
keywordHandler:addKeyword({"armor"}, StdModule.say, {npcHandler = npcHandler, text = "Courage is the only armor that shields you against rage and fear, the greatest dangers you will have to face."})
keywordHandler:addKeyword({"shield"}, StdModule.say, {npcHandler = npcHandler, text = "Your confidence shall be your shield. Nothing can penetrate that defence. No emotion will let you lose your focus."})

-- Set Message:
npcHandler:setMessage(MESSAGE_GREET, "I welcome you, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_FAREWELL, "May your path be as straight as an arrow.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May your path be as straight as an arrow.")

npcHandler:addModule(FocusModule:new())
