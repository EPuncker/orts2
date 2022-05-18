local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20000)
condition:setFormula(-0.55, 0, -0.75, 0)

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_POISONAREA)
combat:addCondition(condition)
combat:setArea(createCombatArea(AREA_SQUARE1X1))

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
