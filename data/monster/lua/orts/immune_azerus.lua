local mType = Game.createMonsterType("Immune Azerus")
local monster = {}

monster.name = "Azerus"
monster.description = "Azerus"
monster.experience = 6000
monster.outfit = {
	lookType = 309
}

monster.health = 26000
monster.maxHealth = 26000
monster.race = "blood"
monster.corpse = 0
monster.speed = 286
monster.manaCost = 0

monster.changeTarget = {
	interval = 5 * 1000,
	chance = 8
}

monster.flags = {
	attackable = true,
	hostile = true,
	pushable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 85,
	targetDistance = 1,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.summon = {
	maxSummons = 10,
	summons = {
		{name = "Rift Worm", chance = 30, interval = 3000, count = 8},
		{name = "Rift Brood", chance = 30, interval = 3000, count = 8},
		{name = "Rift Scythe", chance = 30, interval = 3000, count = 8},
		{name = "War Golem", chance = 30, interval = 3000, count = 5}
	}
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "The ultimate will finally consume this unworthy existence!"},
	{text = "My masters and I will tear down barriers and join the ultimate in its realm!"},
	{text = "The power of the Yalahari will all be mine!"},
	{text = "He who has returned from beyond has taught me secrets you can't even grasp!"},
	{text = "You can't hope to penetrate my shields!"},
	{text = "Do you really think you could beat me?"},
	{text = "We will open the rift for a new time to come!"},
	{text = "The end of times has come!"},
	{text = "The great machinator will make his entrance soon!"},
	{text = "You might scratch my shields but they will never break!"}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -3800, range = 7, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_BIGCLOUDS, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -524, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false},
	{name ="combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -1050, length = 8, spread = 3, effect = CONST_ME_FIREATTACK, target = false}
}

monster.defenses = {
	defense = 65,
	armor = 40,
	{name ="combat", interval = 2000, chance = 11, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_GREEN, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 100},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE , percent = 100},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "invisible", condition = true}
}

mType:register(monster)
