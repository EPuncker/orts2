local mType = Game.createMonsterType("Demon Summoner")
local monster = {}

monster.description = "bones"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 460
}

monster.health = 100
monster.maxHealth = 100
monster.race = "undead"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.flags = {
	attackable = false,
	hostile = true,
	pushable = false,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 100,
	targetDistance = 1,
	hidehealth = true,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{name = "Demon", chance = 100, interval = 1000, count = 1}
	}
}

monster.defenses = {
	defense = 0,
	armor = 0,
	{name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, effect = CONST_ME_MORTAREA, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 100},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_DROWNDAMAGE, percent = 100},
	{type = COMBAT_ICEDAMAGE, percent = 100},
	{type = COMBAT_HOLYDAMAGE, percent = 100},
	{type = COMBAT_DEATHDAMAGE, percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true}
}

mType:register(monster)
