local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20000)
condition:setFormula(-0.55, 0, -0.75, 0)

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)
combat:addCondition(condition)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))
combat:addCondition(condition)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
