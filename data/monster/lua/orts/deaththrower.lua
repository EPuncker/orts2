local mType = Game.createMonsterType("Deaththrower")
local monster = {}

monster.description = "a deaththrower"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 1551
}

monster.health = 100
monster.maxHealth = 100
monster.race = "undead"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 5 * 1000,
	chance = 16
}

monster.flags = {
	attackable = true,
	hostile = true,
	pushable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = true,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.attacks = {
	{name = "dark torturer skill reducer",interval = 2000, chance = 15, range = 6, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_POFF, target = false}
}

monster.defenses = {
	defense = 1,
	armor = 1
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
	{type = "invisible", condition = true}
}

mType:register(monster)
