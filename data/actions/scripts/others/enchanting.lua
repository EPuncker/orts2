local items = {
    equipment = {
        [2147] = { -- small ruby
            [COMBAT_FIREDAMAGE] = {id = 2343, targetId = 2147} -- helmet of the ancients (enchanted)
        },
        [8905] = { -- rainbow shield
            [COMBAT_FIREDAMAGE] = {id = 8906}, [COMBAT_ICEDAMAGE] = {id = 8907},
            [COMBAT_EARTHDAMAGE] = {id = 8909}, [COMBAT_ENERGYDAMAGE] = {id = 8908}
        },
        [9949] = { -- dracoyle statue
            [COMBAT_EARTHDAMAGE] = {id = 9948} -- dracoyle statue (enchanted)
        },
        [9954] = { -- dracoyle statue
            [COMBAT_EARTHDAMAGE] = {id = 9953} -- dracoyle statue (enchanted)
        },
        [10022] = { -- worn firewalker boots
            [COMBAT_FIREDAMAGE] = {id = 9933, say = {text = "Take the boots off first."}},
            slot = {type = CONST_SLOT_FEET, check = true}
        },
        [24716] = { -- werewolf amulet
            [COMBAT_NONE] = {
                id = 24717,
                effects = {failure = CONST_ME_POFF, success = CONST_ME_THUNDER},
                message = {text = "The amulet cannot be enchanted while worn."}
            },
            slot = {type = CONST_SLOT_NECKLACE, check = true}
        },
        [24718] = { -- werewolf helmet
            [COMBAT_NONE] = {
                id = {
                    [SKILL_CLUB] = {id = 24783},
                    [SKILL_SWORD] = {id = 24783},
                    [SKILL_AXE] = {id = 24783},
                    [SKILL_DISTANCE] = {id = 24783},
                    [SKILL_MAGLEVEL] = {id = 24783}
                },
                effects = {failure = CONST_ME_POFF, success = CONST_ME_THUNDER},
                message = {text = "The helmet cannot be enchanted while worn."},
                usesStorage = true
            },
            slot = {type = CONST_SLOT_HEAD, check = true}
        },
        charges = 1000, effect = CONST_ME_MAGIC_RED
    },
 
    spheres = {
        [7759] = {VOCATION_PALADIN, VOCATION_ROYAL_PALADIN},
        [7760] = {VOCATION_SORCERER, VOCATION_MASTER_SORCERER},
        [7761] = {VOCATION_DRUID, VOCATION_ELDER_DRUID},
        [7762] = {VOCATION_KNIGHT, VOCATION_ELITE_KNIGHT}
    },
 
    valuables = {
        [2146] = {id = 7759, shrine = {7508, 7509, 7510, 7511}}, -- small sapphire
        [2147] = {id = 7760, shrine = {7504, 7505, 7506, 7507}}, -- small ruby
        [2149] = {id = 7761, shrine = {7516, 7517, 7518, 7519}}, -- small emerald
        [2150] = {id = 7762, shrine = {7512, 7513, 7514, 7515}}, -- small amethyst
        soul = 2, mana = 300, effect = CONST_ME_HOLYDAMAGE
    },
 
    [2342] = {combatType = COMBAT_FIREDAMAGE, targetId = 2147}, -- helmet of the ancients
    [7759] = {combatType = COMBAT_ICEDAMAGE}, -- small enchanted sapphire
    [7760] = {combatType = COMBAT_FIREDAMAGE}, -- small enchanted ruby
    [7761] = {combatType = COMBAT_EARTHDAMAGE}, -- small enchanted emerald
    [7762] = {combatType = COMBAT_ENERGYDAMAGE}, -- small enchanted amethyst
    [24739] = {combatType = COMBAT_NONE} -- moonlight crystals
}
 
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target or not target:isItem() then
        return false
    end
 
    local itemId, targetId = item:getId(), target:getId()
    local targetType = items.valuables[itemId] or items.equipment[items[itemId].targetId or targetId]
    if not targetType then
        return false
    end
 
    if table.contains({33268, 33269}, toPosition.x) and toPosition.y == 31830 and toPosition.z == 10 and player:getStorageValue(PlayerStorageKeys.ElementalSphere.QuestLine) > 0 then
        if not table.contains(items.spheres[item.itemid], player:getVocation():getId()) then
            return false
        elseif table.contains({7915, 7916}, target.itemid) then
            player:say("Turn off the machine first.", TALKTYPE_MONSTER_SAY)
            return true
        else
            player:setStorageValue(PlayerStorageKeys.ElementalSphere.MachineGemCount, math.max(1, player:getStorageValue(PlayerStorageKeys.ElementalSphere.MachineGemCount) + 1))
            toPosition:sendMagicEffect(CONST_ME_PURPLEENERGY)
            item:transform(item.itemid, item.type - 1)
            return true
        end
    end
 
    if targetType.shrine then
        if not table.contains(targetType.shrine, targetId) then
            player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
            return true
        end
 
        if player:getMana() < items.valuables.mana then
            player:sendCancelMessage(RETURNVALUE_NOTENOUGHMANA)
            return true
        end
 
        if player:getSoul() < items.valuables.soul then
            player:sendCancelMessage(RETURNVALUE_NOTENOUGHSOUL)
            return true
        end
        player:addSoul(-items.valuables.soul)
        player:addMana(-items.valuables.mana)
        player:addManaSpent(items.valuables.mana)
        player:addItem(targetType.id)
        player:getPosition():sendMagicEffect(items.valuables.effect)
        player:sendSupplyUsed(item)
        item:remove(1)
    else
        local targetItem = targetType[items[itemId].combatType]
        if not targetItem or targetItem.targetId and targetItem.targetId ~= targetId then
            return false
        end
 
        local isInSlot = targetType.slot and targetType.slot.check and target:getType():usesSlot(targetType.slot.type) and Player(target:getParent())
        if isInSlot then
            if targetItem.say then
                player:say(targetItem.say.text, TALKTYPE_MONSTER_SAY)
                return true
            elseif targetItem.message then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetItem.message.text)
            else
                return false
            end
        else
            if targetItem.targetId then
                item:transform(targetItem.id)
                item:decay()
                player:sendSupplyUsed(target)
                target:remove(1)
            else
                if targetItem.usesStorage then
                    local vocationId = player:getVocation():getDemotion():getId()
                    local storage = storages[itemId] and storages[itemId][targetId] and storages[itemId][targetId][vocationId]
                    if not storage then
                        return false
                    end
 
                    local storageValue = player:getStorageValue(storage.key)
                    if storageValue == -1 then
                        return false
                    end
 
                    local transform = targetItem.id and targetItem.id[storageValue]
                    if not transform then
                        return false
                    end
                    target:transform(transform.id)
                else
                    target:transform(targetItem.id)
                end
 
                if target:hasAttribute(ITEM_ATTRIBUTE_DURATION) then
                    target:decay()
                end
 
                if target:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
                    target:setAttribute(ITEM_ATTRIBUTE_CHARGES, items.equipment.charges)
                end
                player:sendSupplyUsed(item)
                item:remove(1)
            end
        end
        player:getPosition():sendMagicEffect(targetItem.effects and (isInSlot and targetItem.effects.failure or targetItem.effects.success) or items.equipment.effect)
    end
    return true
end