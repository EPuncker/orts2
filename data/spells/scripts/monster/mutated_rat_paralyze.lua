local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20000)
condition:setFormula(-0.2, 0, -0.45, 0)

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_POISONAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_POISON)
combat:addCondition(condition)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
