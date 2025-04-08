----------------------------------------------------------
--Randomizer2077

--Based on the CursedRandomizer mod by Jackexe

--Created by alixbugbug with help from Jaxstutz
--If you are looking to make your own mod or to modify this one and you have some questions, don't hesitate to dm @alixbugbug on twitter or @alixbugbug.bsky.social on bluesky! 
--Keep in mind I'm a bit of a gonk :>

--Please feel free to modify the mod any way you'd like, and if you're looking to make it better and release your own version, don't hesitate, just give proper credit <3

--PS: Don't look at the ChaoticFirearms function. If you do, don't let me know !!!
-----------------------------------------------------------


Cron = require('External/Cron.lua')
Json = require('External/json.lua')
local Exclusions = require('exclusions')
local playerDefaults = {}

local excludedCharacterIDs = Exclusions.CharacterIDs
local noRandoCharacterIDs = Exclusions.NoRandoCharacterIDs
local excludedLootRando = Exclusions.Loot
local excludedItemIDs = Exclusions.ItemIDs
local shuffleMainIDs = Exclusions.MainIDs
local shuffleMainMaleIDs = Exclusions.MainMaleIDs
local shuffleMainBuffIDs = Exclusions.MainBuffIDs
local shuffleFullMainIDs = Exclusions.MainAllIDs
local shuffleBossIDs = Exclusions.BossIDs
local shufflePsychoIDs = Exclusions.PsychoIDs
local excludedVendorIDs = Exclusions.VendorIDs
local defaultCarIDs = Exclusions.defaultCarIDs
local heals = Exclusions.heals
local grenades = Exclusions.grenades
local firearms = Exclusions.firearms
local swords = Exclusions.swords
local knives = Exclusions.knives
local blades = Exclusions.blades
local bluntWeapons = Exclusions.bluntWeapons


Config = {
    IsRandom = false,
    IsMainRandom = false,
    IsLootRandom = false,
    IsMainShuffle = false,
    IsMainFullShuffle = false,
    IsBossShuffle = false,
    IsPsychoShuffle = false,
    IsEveryonePsycho = false,
    IsVehicleRandom = false,
    IsFirearmChaos = false,
    IsAdRandom = false,
    IsComponentRandom = false,
    IsStartingRandom = false,
    psychoPercentage = 0,
    seed = 0
}


---------------
--Randomizers--
---------------


function BackupPlayerDefaults()
    local playerIDs = {
        "Character.mws_se5_03_player",
        "Character.Player_Puppet_Base",
        "Character.TPP_Player",
        "Character.TPP_Player_Cutscene_Male",
        "Character.TPP_Player_Cutscene_Female",
        "Character.Player_Puppet_Inventory",
        "Character.Player_Puppet_Photomode",
        "Character.Player_Puppet_Menu",
        "Character.Player_Replacer_Puppet_Base",
        "Character.TPP_Player_Cutscene_No_Impostor_Male",
        "Character.TPP_Player_Cutscene_No_Impostor_Female",
        "Character.Sample_Player",
        "AMM_Character.Player_Male",
        "AMM_Character.Player_Female",
        "AMM_Character.TPP_Player_Male",
        "AMM_Character.TPP_Player_Female",
    }

    for _, id in ipairs(playerIDs) do
        local record = TweakDB:GetRecord(id)
        if record then
            playerDefaults[id] = {
                abilities = TweakDB:GetFlat(record:GetID() .. ".abilites"),
                actionMap = TweakDB:GetFlat(record:GetID() .. ".actionMap"),
                archetypeName = TweakDB:GetFlat(record:GetID() .. ".archetypeName"),
                baseAttitudeGroup = TweakDB:GetFlat(record:GetID() .. ".baseAttitudeGroup"),
                entityTemplatePath = TweakDB:GetFlat(record:GetID() .. ".entityTemplatePath"),
                rarity = TweakDB:GetFlat(record:GetID() .. ".rarity"),
                reactionPreset = TweakDB:GetFlat(record:GetID() .. ".reactionPreset"),
                statModifierGroups = TweakDB:GetFlat(record:GetID() .. ".statModifierGroups"),
                statPools = TweakDB:GetFlat(record:GetID() .. ".statPools"),
                statModifiers = TweakDB:GetFlat(record:GetID() .. ".statModifiers"),
            }
        end
    end
end


function RestorePlayerDefaults()
    for id, defaults in pairs(playerDefaults) do
        local record = TweakDB:GetRecord(id)
        if record then
            for key, value in pairs(defaults) do
                TweakDB:SetFlat(record:GetID() .. "." .. key, value)
            end
        end
    end
end


OriginalNPCData = {}

function BackupOriginalNPCData()
    local allCharacters = TweakDB:GetRecords("gamedataCharacter_Record")
    for _, record in ipairs(allCharacters) do
        local recordID = record:GetID()
        OriginalNPCData[tostring(recordID.value)] = {
            reactionPreset = TweakDB:GetFlat(recordID .. ".reactionPreset"),
            baseAttitudeGroup = TweakDB:GetFlat(recordID .. ".baseAttitudeGroup"),
            archetypeName = TweakDB:GetFlat(recordID .. ".archetypeName")
        }
    end
end


RandomizedCharacters = {}

function RevertRandom()
    for _, record in ipairs(RandomizedCharacters) do
        local id = record["id"]
        local adam = record

        TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", adam["entityTemplatePath"])
        TweakDB:SetFlat(record:GetID() .. ".abilites", adam["abilites"])
        TweakDB:SetFlat(record:GetID() .. ".actionMap", adam["actionMap"])
        TweakDB:SetFlat(record:GetID() .. ".archetypeName", adam["archetypeName"])
        TweakDB:SetFlat(record:GetID() .. ".baseAttitudeGroup", adam["baseAttitudeGroup"])
        TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", adam["entityTemplatePath"])
        TweakDB:SetFlat(record:GetID() .. ".rarity", adam["rarity"])
        --TweakDB:SetFlat(record:GetID() .. ".reactionPreset", adam["reactionPreset"])
        TweakDB:SetFlat(record:GetID() .. ".statModifierGroups", adam["statModifierGroups"])
        TweakDB:SetFlat(record:GetID() .. ".voiceTag", adam["voiceTag"])
        TweakDB:SetFlat(record:GetID() .. ".weakspots", adam["weakspots"])
        TweakDB:SetFlat(record:GetID() .. ".EquipmentAreas", adam["EquipmentAreas"])
        --TweakDB:SetFlat(record:GetID() .. ".affiliation", adam["affiliation"])
        TweakDB:SetFlat(record:GetID() .. ".archetypeData", adam["archetypeData"])
        TweakDB:SetFlat(record:GetID() .. ".attachmentSlots", adam["attachmentSlots"])
        --TweakDB:SetFlat(record:GetID() .. ".isChild", adam["isChild"])
        --TweakDB:SetFlat(record:GetID() .. ".isCrowd", adam["isCrowd"])
        --TweakDB:SetFlat(record:GetID() .. ".isLightCrowd", adam["isLightCrowd"])
        TweakDB:SetFlat(record:GetID() .. ".objectActions", adam["objectActions"])
        TweakDB:SetFlat(record:GetID() .. ".scannerModulePreset", adam["scannerModulePreset"])
        TweakDB:SetFlat(record:GetID() .. ".statPools", adam["statPools"])
        TweakDB:SetFlat(record:GetID() .. ".statModifiers", adam["statModifiers"])
        TweakDB:SetFlat(record:GetID() .. ".threatTrackingPreset", adam["threatTrackingPreset"])
        TweakDB:SetFlat(record:GetID() .. ".secondaryEquipment", adam["secondaryEquipment"])
        TweakDB:SetFlat(record:GetID() .. ".primaryEquipment", adam["primaryEquipment"])
        TweakDB:SetFlat(record:GetID() .. ".lootDrop", adam["lootDrop"])
        TweakDB:SetFlat(record:GetID() .. ".lootBagEntity", adam["lootBagEntity"])
        TweakDB:SetFlat(record:GetID() .. ".items", adam["items"])
        TweakDB:SetFlat(record:GetID() .. ".itemGroups", adam["itemGroups"])
        TweakDB:SetFlat(record:GetID() .. ".dropsAmmoOnDeath", adam["dropsAmmoOnDeath"])
        TweakDB:SetFlat(record:GetID() .. ".dropsMoneyOnDeath", adam["dropsMoneyOnDeath"])
        TweakDB:SetFlat(record:GetID() .. ".dropsWeaponOnDeath", adam["dropsWeaponOnDeath"])
        TweakDB:SetFlat(record:GetID() .. ".defaultEquipment", adam["defaultEquipment"])
    end
end

local psychoConverted = {}

function CharacterRandomizer()
    local allCharacters = TweakDB:GetRecords("gamedataCharacter_Record")
    RandomizedCharacters = {}
    local characterData = {}
    local count = 0

    local function getPresetName(tdbid)
        local s = tostring(tdbid)
        local name = s:match("%-%-%[%[%s*(.-)%s*%]%]")
        if name then
            name = name:gsub("%-%-$",""):gsub("^%s+",""):gsub("%s+$","")
        end
        return name or s
    end

    local function isNoRandoCharacter(lowerBaseName)
        for _, noRandoID in ipairs(noRandoCharacterIDs) do
            if lowerBaseName == string.lower(noRandoID) then
                return true
            end
        end
        return false
    end

    for _,record in ipairs(allCharacters) do
        local id = record:GetID()
        local idValue = tostring(id.value)
        local baseName = idValue:match("Character%.(.+)") or idValue
        local lowerBaseName = string.lower(baseName)

        if playerDefaults[idValue] then
            goto continue
        end

        local isPsycho = false
        for _, psychoID in ipairs(shufflePsychoIDs) do
            if lowerBaseName == psychoID:lower() then
                isPsycho = true
                break
            end
        end

        if isPsycho and Config.IsPsychoShuffle then
            goto continue
        end
        if isPsycho and Config.IsEveryonePsycho then
            goto continue
        end

        if isNoRandoCharacter(lowerBaseName) then
            goto continue
        end

        if lowerBaseName:find("^amm_") or lowerBaseName:find("^amm_character") then
            goto continue
        end

        local isExcluded = false
        if not Config.IsMainRandom then
            for _, excludedID in ipairs(excludedCharacterIDs) do
                if lowerBaseName == string.lower(excludedID) then
                    if Config.IsBossShuffle then
                        local isBoss = false
                        for _, bossID in ipairs(shuffleBossIDs) do
                            if lowerBaseName == string.lower(bossID) then
                                isBoss = true
                                break
                            end
                        end
                        if isBoss then
                            isExcluded = false
                        else
                            isExcluded = true
                        end
                    else
                        isExcluded = true
                    end
                    break
                end
            end
        end

        if isExcluded then
            goto continue
        else
            local character = {}
            character["abilites"] = TweakDB:GetFlat(record:GetID() .. ".abilites")
            character["actionMap"] = TweakDB:GetFlat(record:GetID() .. ".actionMap")
            character["archetypeName"] =  TweakDB:GetFlat(record:GetID() .. ".archetypeName")
            character["baseAttitudeGroup"] =  TweakDB:GetFlat(record:GetID() .. ".baseAttitudeGroup")
            character["entityTemplatePath"] =  TweakDB:GetFlat(record:GetID() .. ".entityTemplatePath")
            character["rarity"] =  TweakDB:GetFlat(record:GetID() .. ".rarity")
            --local reactionPreset = TweakDB:GetFlat(record:GetID() .. ".reactionPreset")
            --character["reactionPreset"] = reactionPreset and getPresetName(reactionPreset) or nil
            character["statModifierGroups"] =  TweakDB:GetFlat(record:GetID() .. ".statModifierGroups")
            character["voiceTag"] = TweakDB:GetFlat(record:GetID() .. ".voiceTag")
            character["weakspots"] =  TweakDB:GetFlat(record:GetID() .. ".weakspots")
            character["EquipmentAreas"] = TweakDB:GetFlat(record:GetID() .. ".EquipmentAreas")
            --character["affiliation"] =  TweakDB:GetFlat(record:GetID() .. ".affiliation")
            character["archetypeData"] = TweakDB:GetFlat(record:GetID() .. ".archetypeData")
            character["attachmentSlots"] = TweakDB:GetFlat(record:GetID() .. ".attachmentSlots")
            --character["isChild", TweakDB:GetFlat(record:GetID() .. ".isChild")
            --character["isCrowd", TweakDB:GetFlat(record:GetID() .. ".isCrowd")
            --character["isLightCrowd", TweakDB:GetFlat(record:GetID() .. ".isLightCrowd")
            character["objectActions"] = TweakDB:GetFlat(record:GetID() .. ".objectActions")
            character["scannerModulePreset"] = TweakDB:GetFlat(record:GetID() .. ".scannerModulePreset")
            character["statPools"] = TweakDB:GetFlat(record:GetID() .. ".statPools")
            character["statModifiers"] = TweakDB:GetFlat(record:GetID() .. ".statModifiers")
            character["threatTrackingPreset"] = TweakDB:GetFlat(record:GetID() .. ".threatTrackingPreset")
            character["secondaryEquipment"] = TweakDB:GetFlat(record:GetID() .. ".secondaryEquipment").value
            character["primaryEquipment"] = TweakDB:GetFlat(record:GetID() .. ".primaryEquipment").value
            character["lootDrop"] = TweakDB:GetFlat(record:GetID() .. ".lootDrop")
            character["lootBagEntity"] = TweakDB:GetFlat(record:GetID() .. ".lootBagEntity")
            character["items"] = TweakDB:GetFlat(record:GetID() .. ".items")
            character["itemGroups"] = TweakDB:GetFlat(record:GetID() .. ".itemGroups")
            character["dropsAmmoOnDeath"] = TweakDB:GetFlat(record:GetID() .. ".dropsAmmoOnDeath")
            character["dropsMoneyOnDeath"] = TweakDB:GetFlat(record:GetID() .. ".dropsMoneyOnDeath")
            character["dropsWeaponOnDeath"] = TweakDB:GetFlat(record:GetID() .. ".dropsWeaponOnDeath")
            character["defaultEquipment"] = TweakDB:GetFlat(record:GetID() .. ".defaultEquipment").value
            character["id"] = record:GetID()
            characterData[count] = character
            count = count + 1
        end
        ::continue::
    end

    local keyset = {}
    for k in pairs(characterData) do
        table.insert(keyset, k)
    end
    local totalChar = 0

    for _,record in ipairs(allCharacters) do
        local id = record:GetID();
        local idValue = tostring(id.value)
        local baseName = idValue:match("Character%.(.+)") or idValue
        local lowerBaseName = string.lower(baseName)
        local adam = characterData[keyset[math.random(#keyset)]]

        if playerDefaults[idValue] then
            goto continue
        end

        local isExcluded = false
        local original = nil
        local originalReactionPreset = TweakDB:GetFlat(record:GetID() .. ".reactionPreset")
        originalReactionPreset = originalReactionPreset and getPresetName(originalReactionPreset) or ""
        local randomReactionPreset = adam["reactionPreset"] and getPresetName(adam["reactionPreset"]) or ""

        local isPsycho = false
        for _, psychoID in ipairs(shufflePsychoIDs) do
            if lowerBaseName == psychoID:lower() then
                isPsycho = true
                break
            end
        end

        if psychoConverted[idValue] then
            goto continue
        end

        if isPsycho and Config.IsPsychoShuffle then
            goto continue
        end
        if isPsycho and Config.IsEveryonePsycho then
            goto continue
        end

        if isNoRandoCharacter(lowerBaseName) then
            goto continue
        end

        if lowerBaseName:find("^amm_") or lowerBaseName:find("^amm_character") then
            goto continue
        end

        if not Config.IsMainRandom then
            for _, excludedID in ipairs(excludedCharacterIDs) do
                if lowerBaseName == string.lower(excludedID) then
                    isExcluded = true
                    break
                end
            end
        end
        
        if original ~= nil then
            RandomizedCharacters[totalChar] = original
            totalChar = totalChar + 1
        end

        local aggressivePresets = {
            "ReactionPresets.Ganger_Aggressive",
            "ReactionPresets.Mechanical_Aggressive",
            "ReactionPresets.InVehicle_Aggressive",
            "ReactionPresets.InVehicle_Aggressive_Police",
            "ReactionPresets.Lore_Aggressive",
            "ReactionPresets.Sleep_Aggressive",
            "ReactionPresets.Corpo_Aggressive"
        }
        local passivePresets = {
            "ReactionPresets.NoReaction",
            "ReactionPresets.Civilian_Passive",
            "ReactionPresets.Corpo_Passive",
            "ReactionPresets.Mechanical_Passive",
            "ReactionPresets.Civilian_NoReaction",
            "ReactionPresets.Ganger_Passive",
            "ReactionPresets.Sleep_Passive",
            "ReactionPresets.Lore_Passive",
            "ReactionPresets.InVehicle_Passive",
            "ReactionPresets.Child"
        }

        local function matchesAnyPreset(preset, presetList)
            for _, v in ipairs(presetList) do
                if preset == v then
                    return true
                end
            end
            return false
        end

        if not isExcluded then
            TweakDB:SetFlat(record:GetID() .. ".abilites", adam["abilites"])
            TweakDB:SetFlat(record:GetID() .. ".actionMap", adam["actionMap"])
            TweakDB:SetFlat(record:GetID() .. ".archetypeName", adam["archetypeName"])
            --TweakDB:SetFlat(record:GetID() .. ".baseAttitudeGroup", adam["baseAttitudeGroup"])
            TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", adam["entityTemplatePath"])
            TweakDB:SetFlat(record:GetID() .. ".rarity", adam["rarity"])
            --if matchesAnyPreset(originalReactionPreset, aggressivePresets) then
                --local randomAggressive = aggressivePresets[math.random(#aggressivePresets)]
                --TweakDB:SetFlat(record:GetID()..".reactionPreset", randomAggressive)
            --elseif matchesAnyPreset(originalReactionPreset, passivePresets) then
                --local randomPassive = passivePresets[math.random(#passivePresets)]
                --TweakDB:SetFlat(record:GetID()..".reactionPreset", randomPassive)
            --else
                --TweakDB:SetFlat(record:GetID() .. ".reactionPreset", adam["reactionPreset"])
            --end
            TweakDB:SetFlat(record:GetID() .. ".statModifierGroups", adam["statModifierGroups"])
            TweakDB:SetFlat(record:GetID() .. ".voiceTag", adam["voiceTag"])
            TweakDB:SetFlat(record:GetID() .. ".weakspots", adam["weakspots"])
            TweakDB:SetFlat(record:GetID() .. ".EquipmentAreas", adam["EquipmentAreas"])
            --TweakDB:SetFlat(record:GetID() .. ".affiliation", adam["affiliation"])
            TweakDB:SetFlat(record:GetID() .. ".archetypeData", adam["archetypeData"])
            TweakDB:SetFlat(record:GetID() .. ".attachmentSlots", adam["attachmentSlots"])
            --TweakDB:SetFlat(record:GetID() .. ".isChild", adam["isChild"])
            --TweakDB:SetFlat(record:GetID() .. ".isCrowd", adam["isCrowd"])
            --TweakDB:SetFlat(record:GetID() .. ".isLightCrowd", adam["isLightCrowd"])
            TweakDB:SetFlat(record:GetID() .. ".objectActions", adam["objectActions"])
            TweakDB:SetFlat(record:GetID() .. ".scannerModulePreset", adam["scannerModulePreset"])
            TweakDB:SetFlat(record:GetID() .. ".statPools", adam["statPools"])
            TweakDB:SetFlat(record:GetID() .. ".statModifiers", adam["statModifiers"])
            TweakDB:SetFlat(record:GetID() .. ".threatTrackingPreset", adam["threatTrackingPreset"])
            TweakDB:SetFlat(record:GetID() .. ".secondaryEquipment", adam["secondaryEquipment"])
            TweakDB:SetFlat(record:GetID() .. ".primaryEquipment", adam["primaryEquipment"])
            TweakDB:SetFlat(record:GetID() .. ".lootDrop", adam["lootDrop"])
            TweakDB:SetFlat(record:GetID() .. ".lootBagEntity", adam["lootBagEntity"])
            TweakDB:SetFlat(record:GetID() .. ".items", adam["items"])
            TweakDB:SetFlat(record:GetID() .. ".itemGroups", adam["itemGroups"])
            TweakDB:SetFlat(record:GetID() .. ".dropsAmmoOnDeath", adam["dropsAmmoOnDeath"])
            TweakDB:SetFlat(record:GetID() .. ".dropsMoneyOnDeath", adam["dropsMoneyOnDeath"])
            TweakDB:SetFlat(record:GetID() .. ".dropsWeaponOnDeath", adam["dropsWeaponOnDeath"])
            TweakDB:SetFlat(record:GetID() .. ".defaultEquipment", adam["defaultEquipment"])

        elseif (string.find(tostring(id.value), "Player")) then
            TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", adam["entityTemplatePath"])
        end
        ::continue::
    end
    print("[Randomizer2077] NPC randomization complete!")
end


function StartingInventoryRandomizer()
    local file = io.open("clothing.txt", "r")
    if not file then
        error("Could not open clothing.txt")
    end
    local fileContent = file:read("*a")
    file:close()

    local shirtList = {}
    local pantsList = {}
    local shoesList = {}

    for line in fileContent:gmatch("[^\r\n]+") do
        local lowerLine = line:lower()
        if (lowerLine:find("shirt") or lowerLine:find("tshirt")) and not lowerLine:find("crafting") then
            table.insert(shirtList, line)
        end
        if lowerLine:find("pants") and not lowerLine:find("crafting") then
            table.insert(pantsList, line)
        end
        if (lowerLine:find("shoes") or lowerLine:find("boots")) and not lowerLine:find("crafting") then
            table.insert(shoesList, line)
        end
    end

    local randomShirt = shirtList[math.random(#shirtList)]
    local randomPants = pantsList[math.random(#pantsList)]
    local randomShoes = shoesList[math.random(#shoesList)]

    local journalManager = Game.GetJournalManager()
    local trackedEntry = journalManager:GetTrackedEntry()
    local parentEntry = journalManager:GetParentEntry(trackedEntry)
    local questEntry = journalManager:GetParentEntry(parentEntry)
    local questId = questEntry:GetId()

    if questId == "q001_intro" then
        local p = Game.GetPlayer()
        local playerID = p:GetEntityID()
        local ssc = Game.GetScriptableSystemsContainer()
        local t = Game.GetTransactionSystem()
        local e = ssc:Get(CName.new("EquipmentSystem"))
        local d = e:GetPlayerData(p)

        local i_shirt = d:GetItemInEquipSlot(gamedataEquipmentArea.InnerChest, 0)
        if i_shirt and i_shirt.tdbid and i_shirt.tdbid.hash ~= 0 then
            local dt = t:GetItemData(p, i_shirt)
            if dt:HasTag("Quest") then
                dt:RemoveDynamicTag("Quest")
            end
            t:RemoveItem(p, i_shirt, 1)
        end

        local i_pants = d:GetItemInEquipSlot(gamedataEquipmentArea.Legs, 0)
        if i_pants and i_pants.tdbid and i_pants.tdbid.hash ~= 0 then
            local dt2 = t:GetItemData(p, i_pants)
            if dt2:HasTag("Quest") then
                dt2:RemoveDynamicTag("Quest")
            end
            t:RemoveItem(p, i_pants, 1)
        end

        local i_shoes = d:GetItemInEquipSlot(gamedataEquipmentArea.Feet, 0)
        if i_shoes and i_shoes.tdbid and i_shoes.tdbid.hash ~= 0 then
            local dt3 = t:GetItemData(p, i_shoes)
            if dt3:HasTag("Quest") then
                dt3:RemoveDynamicTag("Quest")
            end
            t:RemoveItem(p, i_shoes, 1)
        end

        Game.AddToInventory(randomShirt, 1)
        Game.AddToInventory(randomPants, 1)
        Game.AddToInventory(randomShoes, 1)

        local i_weapon = d:GetItemInEquipSlot(gamedataEquipmentArea.Weapon, 0)
        if i_weapon and i_weapon.tdbid and i_weapon.tdbid.hash ~= 0 then
            print("hi weapon")
            local dtw = t:GetItemData(p, i_weapon)
            if dtw:HasTag("Quest") then
                dtw:RemoveDynamicTag("Quest")
            end
            t:RemoveItem(p, i_weapon, 1)
        end

        Game.GetTransactionSystem():RemoveItem(Game.GetPlayer(), GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.BonesMcCoy70V0")), 1)
        Game.GetTransactionSystem():RemoveItem(Game.GetPlayer(), GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.FirstAidWhiffV0")), 1)
        Game.GetTransactionSystem():RemoveItem(Game.GetPlayer(), GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.GrenadeFragRegular")), 1)
        Game.GetTransactionSystem():RemoveItem(Game.GetPlayer(), GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.GrenadeEMPRegular")), 1)
        Game.GetTransactionSystem():RemoveItem(Game.GetPlayer(), GetSingleton("gameItemID"):FromTDBID(TweakDBID.new("Items.GrenadeFlashRegular")), 1)


        local combinedWeapons = {}
        for _, w in ipairs(firearms) do table.insert(combinedWeapons, w) end
        for _, w in ipairs(blades) do table.insert(combinedWeapons, w) end
        for _, w in ipairs(bluntWeapons) do table.insert(combinedWeapons, w) end

        if #combinedWeapons > 0 then
            local randomWeapon = combinedWeapons[math.random(#combinedWeapons)]
            Game.AddToInventory(randomWeapon, 1)
        end

        local randomGrenade = grenades[math.random(#grenades)]
        local randomHeal = heals[math.random(#heals)]

        Game.AddToInventory(randomGrenade, 1)
        Game.AddToInventory(randomHeal, 1)
    end
end


function LootRandomizer()
    local lootCount = 0
    local allLoot = TweakDB:GetRecords("gamedataLootItem_Record")
    local lootData = {}
    
    for _,record in ipairs(allLoot) do
        local loot = {}
        local id = record:GetID()
        local isItemExcluded = false
        local isLootExcluded = false
        if not IsComponentRandom then
            if string.find(tostring(id.value), "Material") then
                goto continue
            end
        end
        if not string.find(tostring(id.value), "Shard") then
            loot["dropChance"] = TweakDB:GetFlat(id .. ".dropChance")
            loot["dropCountMax"] = TweakDB:GetFlat(id .. ".dropCountMax")
            loot["dropCountMin"] =  TweakDB:GetFlat(id .. ".dropCountMin")
            loot["playerPrereqID"] =  TweakDB:GetFlat(id .. ".playerPrereqID").value
            loot["itemID"] =  TweakDB:GetFlat(id .. ".itemID").value
            loot["statModifiers"] =  TweakDB:GetFlat(id .. ".statModifiers")
            lootData[lootCount] = loot
            lootCount = lootCount + 1
        end
        ::continue::
    end


    local lootkeyset = {}
    for k in pairs(lootData) do
        table.insert(lootkeyset, k)
    end


    for _,record in ipairs(allLoot) do
        local id = record:GetID();
        local itemID = tostring(TweakDB:GetFlat(id .. ".itemID"))
        local normalizedItemID = itemID:match("%[(.-)%]") or itemID:match("[^:]+$") or itemID
        normalizedItemID = normalizedItemID:lower()
        local loot = lootData[lootkeyset[math.random(#lootkeyset)]]
        local isItemExcluded = false
        local isLootExcluded = false

        for _, excludedLootID in ipairs(excludedLootRando) do
            if string.find(normalizedItemID, string.lower(excludedLootID)) then
                isLootExcluded = true
                break
            end
        end

        for _, excludedItemID in ipairs(excludedItemIDs) do
            if string.find(normalizedItemID, string.lower(excludedItemID)) then
                isItemExcluded = true
                break
            end
        end

        if not IsComponentRandom then
            if string.find(tostring(id.value), "Material") then
                goto continue
            end
        end

        if isLootExcluded or isItemExcluded then
            goto continue
        else 
            if not string.find(tostring(id.value), "Shard") then
                TweakDB:SetFlat(id .. ".dropChance", loot["dropChance"])
                TweakDB:SetFlat(id .. ".dropCountMax", loot["dropCountMax"])
                TweakDB:SetFlat(id .. ".dropCountMin", loot["dropCountMin"])
                --TweakDB:SetFlat(id .. ".playerPrereqID", loot["playerPrereqID"])
                TweakDB:SetFlat(id .. ".itemID", loot["itemID"])
                --TweakDB:SetFlat(id .. ".statModifiers", loot["statModifiers"])
            end
        end
        ::continue::
    end
    print("[Randomizer2077] Loot randomization complete!")
end


function VendorRandomizer()
    local allVendorItems = TweakDB:GetRecords("gamedataVendorItem_Record")
    local vendorData = {}
    local vendorCount = 0

    local excludedVendorIDs = {}
    for _, vID in ipairs(Exclusions.VendorIDs) do
        excludedVendorIDs[vID:lower()] = true
    end

    for _, record in ipairs(allVendorItems) do
        local idValue = record:GetID().value
        local idLower = idValue:lower()

        if idValue:lower():find("money") then
            goto continue
        end

        if idValue ~= "Vendors.BaseMoney" and not excludedVendorIDs[idLower] then
            local item = {
                forceQuality       = TweakDB:GetFlat(idValue .. ".forceQuality"),
                generationPrereqs = TweakDB:GetFlat(idValue .. ".generationPrereqs"),
                item              = TweakDB:GetFlat(idValue .. ".item").value,
                quantity          = TweakDB:GetFlat(idValue .. ".quantity")
            }
            vendorData[vendorCount] = item
            vendorCount = vendorCount + 1
        end
        ::continue::
    end

    local vendorkeyset = {}
    for k in pairs(vendorData) do
        table.insert(vendorkeyset, k)
    end

    for _, record in ipairs(allVendorItems) do
        local idValue = record:GetID().value
        local idLower = idValue:lower()

        if idValue:lower():find("money") then
            goto continue
        end

        if idValue ~= "Vendors.BaseMoney" and not excludedVendorIDs[idLower] then
            local randKey = vendorkeyset[math.random(#vendorkeyset)]
            local newItemData = vendorData[randKey]
            TweakDB:SetFlat(idValue .. ".forceQuality",       newItemData.forceQuality)
            TweakDB:SetFlat(idValue .. ".generationPrereqs", newItemData.generationPrereqs)
            TweakDB:SetFlat(idValue .. ".item",              newItemData.item)
            TweakDB:SetFlat(idValue .. ".quantity",          newItemData.quantity)
        end
        ::continue::
    end
    print("[Randomizer2077] Vendor randomization complete!")
end


local playerVehicleDefaults = {}

local vehicleFields = {
    "entityTemplatePath",
    "displayName",
    "drivingSetup",
    "vehicleDestruction",
    "manufacturer",
    "model",
    "statModifiers",
    "statPools",
    "type",
    "icon",
    "vehAirControl",
    "vehAirControlAI",
    "vehDataPackage",
    "vehDriveModelData",
    "vehDriveModelDataAI",
    "vehEngineData",
    "vehImpactTraffic",
    "vehicleUIData",
    "weapons",
    "driving",
    "drivingParamsPanic",
    "drivingParamsRace"
}


function BackupVehicleDefaults()
    playerVehicleDefaults = {} -- Reset backup to avoid stale data
    for _, carID in ipairs(defaultCarIDs) do
        local record = TweakDB:GetRecord(carID)
        if record then
            local backupData = {}
            for _, field in ipairs(vehicleFields) do
                backupData[field] = TweakDB:GetFlat(record:GetID() .. "." .. field)
            end
            playerVehicleDefaults[carID] = backupData
        end
    end
end


function RestoreVehicleDefaults()
    for carID, defaults in pairs(playerVehicleDefaults) do
        local record = TweakDB:GetRecord(carID)
        if record then
            for _, field in ipairs(vehicleFields) do
                TweakDB:SetFlat(record:GetID() .. "." .. field, defaults[field])
            end
        end
    end
end


function isSafeVehicle(vehRecord)
    local path = TweakDB:GetFlat(vehRecord:GetID() .. ".entityTemplatePath") or ""
    local name = TweakDB:GetFlat(vehRecord:GetID() .. ".displayName") or ""

    local unsafe = {
        "av", "av1", "av2", "av3", "test", "helicopter", "barge",
        "phoenix", "driller", "satellite", "pod", "capsule", "maglev",
        "tram", "gps", "crane", "demo", "basilisk", "panzer", "template",
        "heli", "chopper", "tank", "drone", "seamurai", "yacht", "train",
        "crashsite", "combat", "custom_scenes", "manticore", "cargo",
        "ship", "airstrip", "bubble", "q000", "PlayerBike", "taptap",
        "disabled_interactions", "ps_interceptor", "q114_militech_gun_wagon_turrets",
        "v_001_limousine", "freight", "bombus", "crate", "container", "Default"
    }

    if path == "" then return false end
    if name == 0 or name == "" or name == "Default" then return false end
    
    local idValue = vehRecord:GetID().value:lower()
    for _, keyword in ipairs(unsafe) do
        if string.find(idValue, keyword:lower(), 1, true) then
            return false
        end
    end

    for _, keyword in ipairs(unsafe) do
        if string.find(idValue, "%f[%w]" .. keyword .. "%f[%W]") then
            return false
        end
    end    
    return true
end

  
function VehicleRandomizer()
    local allVehicles = TweakDB:GetRecords("gamedataVehicle_Record")
    if not allVehicles or #allVehicles == 0 then return end

    local bikePool, carPool = {}, {}
    for _, vehRecord in ipairs(allVehicles) do
        if isSafeVehicle(vehRecord) then
            local idLower = vehRecord:GetID().value:lower()
            table.insert(string.find(idLower, "bike") and bikePool or carPool, vehRecord)
        end
    end

    for _, defaultCarId in ipairs(defaultCarIDs) do
        local record = TweakDB:GetRecord(defaultCarId)
        if not record then
            goto continue
        end

        local lowerId = defaultCarId:lower()
        local pool = string.find(lowerId, "bike") and bikePool or carPool
        if #pool == 0 then return end
        local chosenVehicle = pool[math.random(#pool)]

        local targetID = record:GetID()
        local sourceID = chosenVehicle:GetID()
        for _, field in ipairs(vehicleFields) do
            TweakDB:SetFlat(targetID .. "." .. field, TweakDB:GetFlat(sourceID .. "." .. field))
        end
        ::continue::
    end
    print("[Randomizer2077] Player vehicles randomized!")
end


local originalAttacksCache = {}

function CacheDefaultAttacks()
    originalFirearmsCache = {}
    originalBladesCache = {}
    originalBluntCache = {}

    for _, weaponID in ipairs(firearms) do
        local record = TweakDB:GetRecord(weaponID)
        if record ~= nil then
            originalFirearmsCache[weaponID] = {
                --attacks            = TweakDB:GetFlat(weaponID .. ".attacks"),
                --npcRPGData         = TweakDB:GetFlat(weaponID .. ".npcRPGData"),
                statModifierGroups = TweakDB:GetFlat(weaponID .. ".statModifierGroups"),
                statModifiers      = TweakDB:GetFlat(weaponID .. ".statModifiers"),
                inlineStats        = TweakDB:GetFlat(weaponID .. ".inlineStats"),
                damageType         = TweakDB:GetFlat(weaponID .. ".damageType"),
                crosshair          = TweakDB:GetFlat(weaponID .. ".crosshair"),
                --primaryTrigger     = TweakDB:GetFlat(weaponID .. ".primaryTriggerMode"),
                --secondaryTrigger   = TweakDB:GetFlat(weaponID .. ".secondaryTriggerMode"),
            }
        end
    end

    for _, weaponID in ipairs(blades) do
        local record = TweakDB:GetRecord(weaponID)
        if record ~= nil then
            originalBladesCache[weaponID] = {
                --attacks            = TweakDB:GetFlat(weaponID .. ".attacks"),
                --npcRPGData         = TweakDB:GetFlat(weaponID .. ".npcRPGData"),
                statModifierGroups = TweakDB:GetFlat(weaponID .. ".statModifierGroups"),
                statModifiers      = TweakDB:GetFlat(weaponID .. ".statModifiers"),
                inlineStats        = TweakDB:GetFlat(weaponID .. ".inlineStats"),
            }
        end
    end

    for _, weaponID in ipairs(bluntWeapons) do
        local record = TweakDB:GetRecord(weaponID)
        if record ~= nil then
            originalBluntCache[weaponID] = {
                --attacks            = TweakDB:GetFlat(weaponID .. ".attacks"),
                --npcRPGData         = TweakDB:GetFlat(weaponID .. ".npcRPGData"),
                statModifierGroups = TweakDB:GetFlat(weaponID .. ".statModifierGroups"),
                statModifiers      = TweakDB:GetFlat(weaponID .. ".statModifiers"),
                inlineStats        = TweakDB:GetFlat(weaponID .. ".inlineStats"),
            }
        end
    end
end


function RestoreDefaultAttacks()
    for weaponID, defaults in pairs(originalFirearmsCache) do
        local record = TweakDB:GetRecord(weaponID)
        if record ~= nil then
            --TweakDB:SetFlat(weaponID .. ".attacks",            defaults.attacks)
            --TweakDB:SetFlat(weaponID .. ".npcRPGData",         defaults.npcRPGData)
            TweakDB:SetFlat(weaponID .. ".statModifierGroups", defaults.statModifierGroups)
            TweakDB:SetFlat(weaponID .. ".statModifiers",      defaults.statModifiers)
            TweakDB:SetFlat(weaponID .. ".damageType",         defaults.damageType)
            TweakDB:SetFlat(weaponID .. ".inlineStats",        defaults.inlineStats)
            TweakDB:GetFlat(weaponID .. ".crosshair",          defaults.crosshair)
            --TweakDB:GetFlat(weaponID .. ".primaryTriggerMode", defaults.primaryTrigger)
            --TweakDB:GetFlat(weaponID .. ".secondaryTriggerMode", defaults.secondaryTrigger)
        end
    end
    
    for weaponID, defaults in pairs(originalBladesCache) do
        local record = TweakDB:GetRecord(weaponID)
        if record ~= nil then
            --TweakDB:SetFlat(weaponID .. ".attacks",            defaults.attacks)
            --TweakDB:SetFlat(weaponID .. ".npcRPGData",         defaults.npcRPGData)
            TweakDB:SetFlat(weaponID .. ".statModifierGroups", defaults.statModifierGroups)
            TweakDB:SetFlat(weaponID .. ".statModifiers",      defaults.statModifiers)
            TweakDB:SetFlat(weaponID .. ".inlineStats",        defaults.inlineStats)
        end
    end

    for weaponID, defaults in pairs(originalBluntCache) do
        local record = TweakDB:GetRecord(weaponID)
        if record ~= nil then
            --TweakDB:SetFlat(weaponID .. ".attacks",            defaults.attacks)
            --TweakDB:SetFlat(weaponID .. ".npcRPGData",         defaults.npcRPGData)
            TweakDB:SetFlat(weaponID .. ".statModifierGroups", defaults.statModifierGroups)
            TweakDB:SetFlat(weaponID .. ".statModifiers",      defaults.statModifiers)
            TweakDB:SetFlat(weaponID .. ".inlineStats",        defaults.inlineStats)
        end
    end
end

local crosshairs = {
    "Crosshairs.Tech_Hex",
    "Crosshairs.Rasetsu",
    "Crosshairs.Power_Defender",
    "Crosshairs.Tech_Round",
    "Crosshairs.Power_Saratoga",
    "Crosshairs.Hex",
    "Crosshairs.Basic",
    "Crosshairs.Power_Overture",
    "Crosshairs.Tech_Simple",
    "Crosshairs.Pistol"
}

local ammo = {
    "Ammo.HandgunAmmo",
    "Ammo.SniperRifleAmmo",
    "Ammo.ShotgunAmmo",
    "Ammo.RifleAmmo"
}


local function GetRandomCrosshair()
    return crosshairs[math.random(#crosshairs)]
end


local function GetRandomAmmoType()
    return ammo[math.random(#ammo)]
end


function ChaoticFirearms()

    -- I warned you. :(

    local min, max = 1.0, 3.5

    local firearmsData = {}
    local bluntData = {}
    local swordsData = {}
    local knivesData = {}

    local handlingPool = {}
    local recoilPool = {}
    local damagePool = {}
    local spreadPool = {}
    local playerSpreadPool = {}
    local aimPool = {}
    local swayPool = {}
    local rangePool = {}
    local constantPool = {}
    local technicalPool = {}
    local powerPool = {}
    local smartPool = {}
    local miscPool = {}
    local reckoningPool = {}
    local rpgPool = {}
    local smartGunPool = {}
    local smartLinkPool = {}
    local smartProjPool = {}
    local statusPool = {}
    local damageMinMaxPool = {}
    -- local damageTypeRdm = {}
    local HGMult = {}
    local SGMult = {}
    local ARMult = {}
    local SRMult = {}
    local PRMult = {}
    local RVMult = {}
    local SMGMult = {}
    local PLMult = {}
    local GLMult = {}
    local LMGMult = {}
    local multPool = {}

    for _, weaponID in ipairs(firearms) do
        local record = TweakDB:GetRecord(weaponID)
        if record ~= nil then
            local statModifierGroups = TweakDB:GetFlat(weaponID .. ".statModifierGroups") or {}

            for _, modifierRef in ipairs(statModifierGroups) do
                local refString = tostring(modifierRef)
                if string.find(refString, "Handling_Stats") then
                    table.insert(handlingPool, modifierRef)
                elseif string.find(refString, "Recoil_Stats") then
                    table.insert(recoilPool, modifierRef)
                elseif string.find(refString, "Damage_Stats") then
                    table.insert(damagePool, modifierRef)
                elseif string.find(refString, "Spread_Stats") then
                    table.insert(spreadPool, modifierRef)
                elseif string.find(refString, "PlayerState_Spread_Stats") then
                    table.insert(playerSpreadPool, modifierRef)
                elseif string.find(refString, "Aim_Stats") then
                    table.insert(aimPool, modifierRef)
                elseif string.find(refString, "Sway_Stats") then
                    table.insert(swayPool, modifierRef)
                elseif string.find(refString, "Range_Stats") then
                    table.insert(rangePool, modifierRef)
                elseif string.find(refString, "Constant_Stats") then
                    table.insert(constantPool, modifierRef)
                --elseif string.find(refString, "Technical_Stats") then
                    --table.insert(technicalPool, modifierRef)
                --elseif string.find(refString, "Power_Stats") then
                    --table.insert(powerPool, modifierRef)
                --elseif string.find(refString, "Smart_Stats") then
                    --table.insert(smartPool, modifierRef)
                elseif string.find(refString, "Misc_Stats") then
                    table.insert(miscPool, modifierRef)
                elseif string.find(refString, "DeadReckoning_Stats") then
                    table.insert(reckoningPool, modifierRef)
                elseif string.find(refString, "RPG_Stats") then
                    table.insert(rpgPool, modifierRef)
                elseif string.find(refString, "SmartGun_Stats") then
                    table.insert(smartGunPool, modifierRef)
                elseif string.find(refString, "SmartGun_SmartLink_Stats") then
                    table.insert(smartLinkPool, modifierRef)
                elseif string.find(refString, "SmartGun_Projectile_Stats") then
                    table.insert(smartProjPool, modifierRef)
                elseif string.find(refString, "Status_Effect_Application_Stats") then
                    table.insert(statusPool, modifierRef)
                elseif string.find(refString, "Damage_Type_Min_Max") then
                    table.insert(damageMinMaxPool, modifierRef)
                --elseif string.find(refString, "Damage_Type_Randomization") then
                    --table.insert(damageTypeRdm, modifierRef)
                elseif string.find(refString, "Handgun_Mult_Stats") then
                    table.insert(HGMult, modifierRef)
                elseif string.find(refString, "Shotgun_Mult_Stats") then
                    table.insert(SGMult, modifierRef)
                elseif string.find(refString, "Assault_Rifle_Mult_Stats") then
                    table.insert(ARMult, modifierRef)
                elseif string.find(refString, "Sniper_Rifle_Mult_Stats") then
                    table.insert(SRMult, modifierRef)
                elseif string.find(refString, "Precision_Rifle_Mult_Stats") then
                    table.insert(PRMult, modifierRef)
                elseif string.find(refString, "Revolver_Mult_Stats") then
                    table.insert(RVMult, modifierRef)
                elseif string.find(refString, "Submachinegun_Mult_Stats") then
                    table.insert(SMGMult, modifierRef)
                --elseif string.find(refString, "ProjectileLauncher_Mult_Stats") then
                    --table.insert(PLMult, modifierRef)
                --elseif string.find(refString, "GrenadeLauncher_Mult_Stats") then
                    --table.insert(GLMult, modifierRef)
                elseif string.find(refString, "Lightmachinegun_Mult_Stats") then
                    table.insert(LMGMult, modifierRef)
                elseif string.find(refString, "Mult_Stats") then
                    table.insert(multPool, modifierRef)
                end
            end

            local data = {
                id                 = weaponID,
                --attacks            = TweakDB:GetFlat(weaponID .. ".attacks"),
                --npcRPGData         = TweakDB:GetFlat(weaponID .. ".npcRPGData"),
                statModifierGroups = statModifierGroups,
                statModifiers      = TweakDB:GetFlat(weaponID .. ".statModifiers"),
                inlineStats        = TweakDB:GetFlat(weaponID .. ".inlineStats"),
                --damageType         = TweakDB:GetFlat(weaponID .. ".damageType"),
            }
            table.insert(firearmsData, data)
        end
    end

    for _, weaponID in ipairs(swords) do
        local record = TweakDB:GetRecord(weaponID)
        if record ~= nil then
            local data = {
                id                 = weaponID,
                --attacks            = TweakDB:GetFlat(weaponID .. ".attacks"),
                --npcRPGData         = TweakDB:GetFlat(weaponID .. ".npcRPGData"),
                statModifierGroups = TweakDB:GetFlat(weaponID .. ".statModifierGroups"),
                statModifiers      = TweakDB:GetFlat(weaponID .. ".statModifiers"),
                inlineStats        = TweakDB:GetFlat(weaponID .. ".inlineStats"),
                --damageType         = TweakDB:GetFlat(weaponID .. ".damageType"),
            }
            table.insert(swordsData, data)
        end
    end

    for _, weaponID in ipairs(knives) do
        local record = TweakDB:GetRecord(weaponID)
        if record ~= nil then
            local data = {
                id                 = weaponID,
                --attacks            = TweakDB:GetFlat(weaponID .. ".attacks"),
                --npcRPGData         = TweakDB:GetFlat(weaponID .. ".npcRPGData"),
                statModifierGroups = TweakDB:GetFlat(weaponID .. ".statModifierGroups"),
                statModifiers      = TweakDB:GetFlat(weaponID .. ".statModifiers"),
                inlineStats        = TweakDB:GetFlat(weaponID .. ".inlineStats"),
                --damageType         = TweakDB:GetFlat(weaponID .. ".damageType"),
            }
            table.insert(knivesData, data)
        end
    end

    for _, weaponID in ipairs(bluntWeapons) do
        local record = TweakDB:GetRecord(weaponID)
        if record ~= nil then
            local data = {
                id                 = weaponID,
                --attacks            = TweakDB:GetFlat(weaponID .. ".attacks"),
                --npcRPGData         = TweakDB:GetFlat(weaponID .. ".npcRPGData"),
                statModifierGroups = TweakDB:GetFlat(weaponID .. ".statModifierGroups"),
                statModifiers      = TweakDB:GetFlat(weaponID .. ".statModifiers"),
                inlineStats        = TweakDB:GetFlat(weaponID .. ".inlineStats"),
                --damageType         = TweakDB:GetFlat(weaponID .. ".damageType"),
            }
            table.insert(bluntData, data)
        end
    end

    local function GetRandom(pool)
        if #pool > 0 then
            return pool[math.random(#pool)]
        end
        return nil
    end

    local function GetReplacementForStatGroup(group)
        local refString = tostring(group)
        if string.find(refString, "Handling_Stats") then
            return GetRandom(handlingPool)
        elseif string.find(refString, "Recoil_Stats") then
            return GetRandom(recoilPool)
        elseif string.find(refString, "Damage_Stats") then
            return GetRandom(damagePool)
        elseif string.find(refString, "Spread_Stats") then
            return GetRandom(spreadPool)
        elseif string.find(refString, "PlayerState_Spread_Stats") then
            return GetRandom(playerSpreadPool)
        elseif string.find(refString, "Aim_Stats") then
            return GetRandom(aimPool)
        elseif string.find(refString, "Sway_Stats") then
            return GetRandom(swayPool)
        elseif string.find(refString, "Range_Stats") then
            return GetRandom(rangePool)
        elseif string.find(refString, "Constant_Stats") then
            return GetRandom(constantPool)
        --elseif string.find(refString, "Technical_Stats") then
            --return GetRandom(technicalPool)
        --elseif string.find(refString, "Power_Stats") then
            --return GetRandom(powerPool)
        --elseif string.find(refString, "Smart_Stats") then
            --return GetRandom(smartPool)
        elseif string.find(refString, "Misc_Stats") then
            return GetRandom(miscPool)
        elseif string.find(refString, "DeadReckoning_Stats") then
            return GetRandom(reckoningPool)
        elseif string.find(refString, "RPG_Stats") then
            return GetRandom(rpgPool)
        elseif string.find(refString, "SmartGun_Stats") then
            return GetRandom(smartGunPool)
        elseif string.find(refString, "SmartGun_SmartLink_Stats") then
            return GetRandom(smartLinkPool)
        elseif string.find(refString, "SmartGun_Projectile_Stats") then
            return GetRandom(smartProjPool)
        elseif string.find(refString, "Status_Effect_Application_Stats") then
            return GetRandom(statusPool)
        elseif string.find(refString, "Damage_Type_Min_Max") then
            return GetRandom(damageMinMaxPool)
        elseif string.find(refString, "Handgun_Mult_Stats") then
            return GetRandom(HGMult)
        elseif string.find(refString, "Shotgun_Mult_Stats") then
            return GetRandom(ARMult)
        elseif string.find(refString, "Assault_Rifle_Mult_Stats") then
            return GetRandom(SRMult)
        elseif string.find(refString, "Sniper_Rifle_Mult_Stats") then
            return GetRandom(SRMult)
        elseif string.find(refString, "Precision_Rifle_Mult_Stats") then
            return GetRandom(PRMult)
        elseif string.find(refString, "Revolver_Mult_Stats") then
            return GetRandom(RVMult)
        elseif string.find(refString, "Submachinegun_Mult_Stats") then
            return GetRandom(SMGMult)
        elseif string.find(refString, "Lightmachinegun_Mult_Stats") then
            return GetRandom(LMGMult)
        elseif string.find(refString, "Mult_Stats") then
            return GetRandom(multPool)
        end
        return nil
    end

    local shuffledData = ShuffleTable(firearmsData)
    local shuffledSwordsData = ShuffleTable(swordsData)
    local shuffledKnivesData = ShuffleTable(knivesData)
    local shuffledBluntData = ShuffleTable(bluntData)

    for i = 1, #firearmsData do
        local randomReloadSpeed  = min + math.random() * (max - min)
        local randomCrosshair    = GetRandomCrosshair()
        --local randomTriggerMode  = GetRandomTriggerMode()
        --local randomTriggerModeB = GetRandomTriggerMode()
        local randomAmmoType     = GetRandomAmmoType()
        --local randomEvo          = GetRandomEvo()
        local original           = firearmsData[i]
        local random             = shuffledData[i]

        local origStatGroups = original.statModifierGroups or {}
        local newStatModifierGroups = {}
        for _, group in ipairs(origStatGroups) do
            local replacement = GetReplacementForStatGroup(group)
            if replacement then
                table.insert(newStatModifierGroups, replacement)
            else
                table.insert(newStatModifierGroups, group)
            end
        end

        --TweakDB:SetFlat(original.id .. ".npcRPGData",         random.npcRPGData)
        TweakDB:SetFlat(original.id .. ".statModifierGroups", newStatModifierGroups)
        TweakDB:SetFlat(original.id .. ".crosshair",          randomCrosshair)
        --TweakDB:SetFlat(original.id .. ".primaryTriggerMode", randomTriggerMode)
        --TweakDB:SetFlat(original.id .. ".secondaryTriggerMode", randomTriggerModeB)
        TweakDB:SetFlat(original.id .. ".ammo",               randomAmmoType)
        TweakDB:SetFlat(original.id .. ".baseEmptyReloadTime", randomReloadSpeed)
        TweakDB:SetFlat(original.id .. ".baseReloadTime",      randomReloadSpeed)
        --TweakDB:SetFlat(original.id .. ".evolution",           randomEvo)
        --TweakDB:SetFlat(original.id .. ".quality",             "Quality.Random")

        if random.inlineStats ~= nil then
            TweakDB:SetFlat(original.id .. ".inlineStats", random.inlineStats)
        end
    end

    for i = 1, #swordsData do
        local originalSwords = swordsData[i]
        local randomSwords   = shuffledSwordsData[i]
        --TweakDB:SetFlat(originalSwords.id .. ".npcRPGData",         randomSwords.npcRPGData)
        TweakDB:SetFlat(originalSwords.id .. ".statModifierGroups", randomSwords.statModifierGroups)
        TweakDB:SetFlat(originalSwords.id .. ".statModifiers",      randomSwords.statModifiers)
        if randomSwords.inlineStats ~= nil then
            TweakDB:SetFlat(originalSwords.id .. ".inlineStats", randomSwords.inlineStats)
        end
    end

    for i = 1, #knivesData do
        local originalKnives = knivesData[i]
        local randomKnives   = shuffledKnivesData[i]
        --TweakDB:SetFlat(originalKnives.id .. ".npcRPGData",         randomKnives.npcRPGData)
        TweakDB:SetFlat(originalKnives.id .. ".statModifierGroups", randomKnives.statModifierGroups)
        TweakDB:SetFlat(originalKnives.id .. ".statModifiers",      randomKnives.statModifiers)
        if randomKnives.inlineStats ~= nil then
            TweakDB:SetFlat(originalKnives.id .. ".inlineStats", randomKnives.inlineStats)
        end
    end

    for i = 1, #bluntData do
        local originalBlunt = bluntData[i]
        local randomBlunt   = shuffledBluntData[i]
        --TweakDB:SetFlat(originalBlunt.id .. ".npcRPGData",         randomBlunt.npcRPGData)
        TweakDB:SetFlat(originalBlunt.id .. ".statModifierGroups", randomBlunt.statModifierGroups)
        TweakDB:SetFlat(originalBlunt.id .. ".statModifiers",      randomBlunt.statModifiers)
        if randomBlunt.inlineStats ~= nil then
            TweakDB:SetFlat(originalBlunt.id .. ".inlineStats", randomBlunt.inlineStats)
        end
    end
    print("[Randomizer2077] Weapon stat randomization complete!")
end


function AdRandomizer()
    local allAds = TweakDB:GetRecords("gamedataAdvertisement_Record")
    local allSigns = TweakDB:GetRecords("gamedataStreetSign_Record")
    local adData = {}
    local signData = {}
  
    for _, adRecord in ipairs(allAds) do
      local adID = adRecord:GetID()
      adData[#adData+1] = {
        id = adID,
        def = TweakDB:GetFlat(adID .. ".definitions"),
        resource = TweakDB:GetFlat(adID .. ".resource"),
        --localizationKey = TweakDB:GetFlat(adID .. ".localizationKey")
      }
    end
  
    for _, adRecord in ipairs(allAds) do
      local pick = adData[math.random(#adData)]
      local adID = adRecord:GetID()
      TweakDB:SetFlat(adID .. ".definitions", pick.def)
      TweakDB:SetFlat(adID .. ".resource", pick.resource)
      --TweakDB:SetFlat(adID .. ".localizationKey", pick.localizationKey)
    end

    for _, signRecord in ipairs(allSigns) do
        local signID = signRecord:GetID()
        signData[#signData+1] = {
          id = signID,
          unique = TweakDB:GetFlat(signID .. ".isUnique"),
          resource = TweakDB:GetFlat(signID .. ".resource"),
          styleState = TweakDB:GetFlat(signID .. ".styleStateName"),
        }
    end
    
    for _, signRecord in ipairs(allSigns) do
        local pick = signData[math.random(#signData)]
        local signID = signRecord:GetID()
        TweakDB:SetFlat(signID .. ".isUnique", pick.unique)
        TweakDB:SetFlat(signID .. ".resource", pick.resource)
        TweakDB:SetFlat(signID .. ".styleStateName", pick.styleState)
    end

    print("[Randomizer2077] Advert randomization complete!")
end


-------------
--Shufflers--
-------------


function ShuffleTable(tbl)
    local shuffled = {}
    for i, v in ipairs(tbl) do
        local rand = math.random(#shuffled + 1)
        table.insert(shuffled, rand, v)
    end
    return shuffled
end


function RevertMainShuffle()

    local allCharacters = TweakDB:GetRecords("gamedataCharacter_Record")
    local tweakDBLookup = {}
    for _, record in ipairs(allCharacters) do
        local id = tostring(record:GetID().value):lower()
        tweakDBLookup[id] = record
    end

    local function restoreRecord(record, backup)
        TweakDB:SetFlat(record:GetID() .. ".abilities", backup.abilities)
        TweakDB:SetFlat(record:GetID() .. ".actionMap", backup.actionMap)
        TweakDB:SetFlat(record:GetID() .. ".archetypeName", backup.archetypeName)
        TweakDB:SetFlat(record:GetID() .. ".archetypeData", backup.archetypeData)
        TweakDB:SetFlat(record:GetID() .. ".displayName", backup.displayName)
        TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", backup.entityTemplatePath)
        TweakDB:SetFlat(record:GetID() .. ".scannerModulePreset", backup.scannerModule)
        TweakDB:SetFlat(record:GetID() .. ".rarity", backup.rarity)
        TweakDB:SetFlat(record:GetID() .. ".statModifierGroups", backup.statModifierGroups)
        TweakDB:SetFlat(record:GetID() .. ".statPools", backup.statPools)
        TweakDB:SetFlat(record:GetID() .. ".statModifiers", backup.statModifiers)
        TweakDB:SetFlat(record:GetID() .. ".voiceTag", backup.voiceTag)
    end

    if OriginalMainCharacterData and #OriginalMainCharacterData > 0 then
        for _, character in ipairs(OriginalMainCharacterData) do
            local record = tweakDBLookup[character.id]
            if record then
                restoreRecord(record, character)
            end
        end
    end

    if OriginalMainMaleCharacterData and #OriginalMainMaleCharacterData > 0 then
        for _, character in ipairs(OriginalMainMaleCharacterData) do
            local record = tweakDBLookup[character.id]
            if record then
                restoreRecord(record, character)
            end
        end
    end

    if OriginalMainFullCharacterData and #OriginalMainFullCharacterData > 0 then
        for _, character in ipairs(OriginalMainFullCharacterData) do
            local record = tweakDBLookup[character.id]
            if record then
                restoreRecord(record, character)
            end
        end
        print("[Randomizer2077] Full main character data reverted!")
    end
end


function MainCharacterShuffle()
    local mainCharacterData = {}
    local mainMaleCharacterData = {}
    local mainBuffCharacterData = {}
    local mainFullCharacterData = {}
    local shuffledMainData = {}
    local shuffledMaleMainData = {}
    local shuffledBuffMainData = {}
    local shuffledMainFullData = {}

    OriginalMainCharacterData = {}
    OriginalMainMaleCharacterData = {}
    OriginalMainBuffCharacterData = {}
    OriginalMainFullCharacterData = {}

    if not shuffleMainIDs or #shuffleMainIDs == 0 then
        return
    end

    if not shuffleMainMaleIDs or #shuffleMainMaleIDs == 0 then
        return
    end

    if not shuffleMainBuffIDs or #shuffleMainBuffIDs == 0 then
        return
    end

    if not shuffleFullMainIDs or #shuffleFullMainIDs == 0 then
        return
    end

    local allCharacters = TweakDB:GetRecords("gamedataCharacter_Record")
    local tweakDBLookup = {}
    for _, record in ipairs(allCharacters) do
        local id = tostring(record:GetID().value):lower()
        tweakDBLookup[id] = record
    end

    if Config.IsMainShuffle and not Config.IsMainFullShuffle then

        for _, id in ipairs(shuffleMainIDs) do
            local normalizedID = id:lower()

            for tweakDBID, record in pairs(tweakDBLookup) do
                local baseName = tweakDBID:match("character%.(.+)") or tweakDBID

                if tweakDBID:lower():find("^amm_") then
                    goto continue
                end                

                if baseName:lower():find("^amm_") or baseName:lower():find("^amm_character") then
                    goto continue
                end

                if baseName == normalizedID then
                    local character = {
                        id = tweakDBID,
                        abilities = TweakDB:GetFlat(record:GetID() .. ".abilities"),
                        actionMap = TweakDB:GetFlat(record:GetID() .. ".actionMap"),
                        archetypeName = TweakDB:GetFlat(record:GetID() .. ".archetypeName"),
                        archetypeData = TweakDB:GetFlat(record:GetID() .. ".archetypeData"),
                        displayName = TweakDB:GetFlat(record:GetID() .. ".displayName"),
                        -- baseAttitudeGroup = TweakDB:GetFlat(record:GetID() .. ".baseAttitudeGroup"),
                        entityTemplatePath = TweakDB:GetFlat(record:GetID() .. ".entityTemplatePath"),
                        scannerModule = TweakDB:GetFlat(record:GetID() .. ".scannerModulePreset"),
                        rarity = TweakDB:GetFlat(record:GetID() .. ".rarity"),
                        -- reactionPreset = TweakDB:GetFlat(record:GetID() .. ".reactionPreset"),
                        statModifierGroups = TweakDB:GetFlat(record:GetID() .. ".statModifierGroups"),
                        statPools = TweakDB:GetFlat(record:GetID() .. ".statPools"),
                        statModifiers = TweakDB:GetFlat(record:GetID() .. ".statModifiers"),
                        voiceTag = TweakDB:GetFlat(record:GetID() .. ".voiceTag"),
                    }
                    table.insert(mainCharacterData, character)
                    table.insert(OriginalMainCharacterData, character)
                    break
                end
                ::continue::
            end
        end
            
        for _, id in ipairs(shuffleMainMaleIDs) do
            local normalizedID = id:lower()

            for tweakDBID, record in pairs(tweakDBLookup) do
                local baseName = tweakDBID:match("character%.(.+)") or tweakDBID

                if tweakDBID:lower():find("^amm_") then
                    goto continue
                end                    

                if baseName:lower():find("^amm_") or baseName:lower():find("^amm_character") then
                    goto continue
                end

                if baseName == normalizedID then
                    local character = {
                            id = tweakDBID,
                            abilities = TweakDB:GetFlat(record:GetID() .. ".abilities"),
                            actionMap = TweakDB:GetFlat(record:GetID() .. ".actionMap"),
                            archetypeName = TweakDB:GetFlat(record:GetID() .. ".archetypeName"),
                            displayName = TweakDB:GetFlat(record:GetID() .. ".displayName"),
                            archetypeData = TweakDB:GetFlat(record:GetID() .. ".archetypeData"),
                            -- baseAttitudeGroup = TweakDB:GetFlat(record:GetID() .. ".baseAttitudeGroup"),
                            entityTemplatePath = TweakDB:GetFlat(record:GetID() .. ".entityTemplatePath"),
                            scannerModule = TweakDB:GetFlat(record:GetID() .. ".scannerModulePreset"),
                            rarity = TweakDB:GetFlat(record:GetID() .. ".rarity"),
                            -- reactionPreset = TweakDB:GetFlat(record:GetID() .. ".reactionPreset"),
                            statModifierGroups = TweakDB:GetFlat(record:GetID() .. ".statModifierGroups"),
                            statPools = TweakDB:GetFlat(record:GetID() .. ".statPools"),
                            statModifiers = TweakDB:GetFlat(record:GetID() .. ".statModifiers"),
                            voiceTag = TweakDB:GetFlat(record:GetID() .. ".voiceTag"),
                        }
                        table.insert(mainMaleCharacterData, character)
                        table.insert(OriginalMainMaleCharacterData, character)
                        break
                end
                ::continue::
            end
        end

        for _, id in ipairs(shuffleMainBuffIDs) do
            local normalizedID = id:lower()

            for tweakDBID, record in pairs(tweakDBLookup) do
                local baseName = tweakDBID:match("character%.(.+)") or tweakDBID

                if tweakDBID:lower():find("^amm_") then
                    goto continue
                end                

                if baseName:lower():find("^amm_") or baseName:lower():find("^amm_character") then
                    goto continue
                end

                if baseName == normalizedID then
                        local character = {
                            id = tweakDBID,
                            abilities = TweakDB:GetFlat(record:GetID() .. ".abilities"),
                            actionMap = TweakDB:GetFlat(record:GetID() .. ".actionMap"),
                            archetypeName = TweakDB:GetFlat(record:GetID() .. ".archetypeName"),
                            archetypeData = TweakDB:GetFlat(record:GetID() .. ".archetypeData"),
                            displayName = TweakDB:GetFlat(record:GetID() .. ".displayName"),
                            -- baseAttitudeGroup = TweakDB:GetFlat(record:GetID() .. ".baseAttitudeGroup"),
                            entityTemplatePath = TweakDB:GetFlat(record:GetID() .. ".entityTemplatePath"),
                            scannerModule = TweakDB:GetFlat(record:GetID() .. ".scannerModulePreset"),
                            rarity = TweakDB:GetFlat(record:GetID() .. ".rarity"),
                            -- reactionPreset = TweakDB:GetFlat(record:GetID() .. ".reactionPreset"),
                            statModifierGroups = TweakDB:GetFlat(record:GetID() .. ".statModifierGroups"),
                            statPools = TweakDB:GetFlat(record:GetID() .. ".statPools"),
                            statModifiers = TweakDB:GetFlat(record:GetID() .. ".statModifiers"),
                            voiceTag = TweakDB:GetFlat(record:GetID() .. ".voiceTag"),
                        }
                        table.insert(mainBuffCharacterData, character)
                        table.insert(OriginalMainBuffCharacterData, character)
                        break
                end
                ::continue::
            end
        end
    end

    if #mainCharacterData == 0 then
        return
    end

    if #mainMaleCharacterData == 0 then
        return
    end

    if #mainBuffCharacterData == 0 then
        return
    end

    shuffledMainData = ShuffleTable(mainCharacterData)
    if not shuffledMainData or #shuffledMainData == 0 then
        return
    end

    shuffledMaleMainData = ShuffleTable(mainMaleCharacterData)
    if not shuffledMaleMainData or #shuffledMaleMainData == 0 then
        return
    end

    shuffledBuffMainData = ShuffleTable(mainBuffCharacterData)
    if not shuffledBuffMainData or #shuffledBuffMainData == 0 then
        return
    end

    for i, character in ipairs(mainCharacterData) do
        local shuffledCharacter = shuffledMainData[i]
        local record = tweakDBLookup[character.id]
        if record then
                TweakDB:SetFlat(record:GetID() .. ".abilities", shuffledCharacter.abilities)
                TweakDB:SetFlat(record:GetID() .. ".actionMap", shuffledCharacter.actionMap)
                TweakDB:SetFlat(record:GetID() .. ".archetypeName", shuffledCharacter.archetypeName)
                TweakDB:SetFlat(record:GetID() .. ".archetypeData", shuffledCharacter.archetypeData)
                TweakDB:SetFlat(record:GetID() .. ".displayName", shuffledCharacter.displayName)
                -- TweakDB:SetFlat(record:GetID() .. ".baseAttitudeGroup", shuffledCharacter.baseAttitudeGroup)
                TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", shuffledCharacter.entityTemplatePath)
                TweakDB:SetFlat(record:GetID() .. ".scannerModulePreset", shuffledCharacter.scannerModule)
                TweakDB:SetFlat(record:GetID() .. ".rarity", shuffledCharacter.rarity)
                -- TweakDB:SetFlat(record:GetID() .. ".reactionPreset", shuffledCharacter.reactionPreset)
                TweakDB:SetFlat(record:GetID() .. ".statModifierGroups", shuffledCharacter.statModifierGroups)
                TweakDB:SetFlat(record:GetID() .. ".statPools", shuffledCharacter.statPools)
                TweakDB:SetFlat(record:GetID() .. ".statModifiers", shuffledCharacter.statModifiers)
                TweakDB:SetFlat(record:GetID() .. ".voiceTag", shuffledCharacter.voiceTag)
        end
    end

    for i, character in ipairs(mainMaleCharacterData) do
        local shuffledMaleCharacter = shuffledMaleMainData[i]
        local record = tweakDBLookup[character.id]
        if record then
                TweakDB:SetFlat(record:GetID() .. ".abilities", shuffledMaleCharacter.abilities)
                TweakDB:SetFlat(record:GetID() .. ".actionMap", shuffledMaleCharacter.actionMap)
                TweakDB:SetFlat(record:GetID() .. ".archetypeName", shuffledMaleCharacter.archetypeName)
                TweakDB:SetFlat(record:GetID() .. ".archetypeData", shuffledMaleCharacter.archetypeData)
                TweakDB:SetFlat(record:GetID() .. ".displayName", shuffledMaleCharacter.displayName)
                -- TweakDB:SetFlat(record:GetID() .. ".baseAttitudeGroup", shuffledMaleCharacter.baseAttitudeGroup)
                TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", shuffledMaleCharacter.entityTemplatePath)
                TweakDB:SetFlat(record:GetID() .. ".scannerModulePreset", shuffledMaleCharacter.scannerModule)
                TweakDB:SetFlat(record:GetID() .. ".rarity", shuffledMaleCharacter.rarity)
                -- TweakDB:SetFlat(record:GetID() .. ".reactionPreset", shuffledMaleCharacter.reactionPreset)
                TweakDB:SetFlat(record:GetID() .. ".statModifierGroups", shuffledMaleCharacter.statModifierGroups)
                TweakDB:SetFlat(record:GetID() .. ".statPools", shuffledMaleCharacter.statPools)
                TweakDB:SetFlat(record:GetID() .. ".statModifiers", shuffledMaleCharacter.statModifiers)
                TweakDB:SetFlat(record:GetID() .. ".voiceTag", shuffledMaleCharacter.voiceTag)
        end
    end

    for i, character in ipairs(mainBuffCharacterData) do
        local shuffledBuffCharacter = shuffledBuffMainData[i]
        local record = tweakDBLookup[character.id]
        if record then
                TweakDB:SetFlat(record:GetID() .. ".abilities", shuffledBuffCharacter.abilities)
                TweakDB:SetFlat(record:GetID() .. ".actionMap", shuffledBuffCharacter.actionMap)
                TweakDB:SetFlat(record:GetID() .. ".archetypeName", shuffledBuffCharacter.archetypeName)
                TweakDB:SetFlat(record:GetID() .. ".archetypeData", shuffledBuffCharacter.archetypeData)
                TweakDB:SetFlat(record:GetID() .. ".displayName", shuffledBuffCharacter.displayName)
                -- TweakDB:SetFlat(record:GetID() .. ".baseAttitudeGroup", shuffledBuffCharacter.baseAttitudeGroup)
                TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", shuffledBuffCharacter.entityTemplatePath)
                TweakDB:SetFlat(record:GetID() .. ".scannerModulePreset", shuffledBuffCharacter.scannerModule)
                TweakDB:SetFlat(record:GetID() .. ".rarity", shuffledBuffCharacter.rarity)
                -- TweakDB:SetFlat(record:GetID() .. ".reactionPreset", shuffledBuffCharacter.reactionPreset)
                TweakDB:SetFlat(record:GetID() .. ".statModifierGroups", shuffledBuffCharacter.statModifierGroups)
                TweakDB:SetFlat(record:GetID() .. ".statPools", shuffledBuffCharacter.statPools)
                TweakDB:SetFlat(record:GetID() .. ".statModifiers", shuffledBuffCharacter.statModifiers)
                TweakDB:SetFlat(record:GetID() .. ".voiceTag", shuffledBuffCharacter.voiceTag)
        end
    end

    print("[Randomizer2077] Main character shuffle complete!")

    if Config.IsMainFullShuffle then

        for _, id in ipairs(shuffleFullMainIDs) do
            local normalizedID = id:lower()

            for tweakDBID, record in pairs(tweakDBLookup) do
                local baseName = tweakDBID:match("character%.(.+)") or tweakDBID

                if baseName:lower():find("^amm_") or baseName:lower():find("^amm_character") then
                    goto continue
                end

                if baseName == normalizedID then
                        local character = {
                            id = tweakDBID,
                            abilities = TweakDB:GetFlat(record:GetID() .. ".abilities"),
                            actionMap = TweakDB:GetFlat(record:GetID() .. ".actionMap"),
                            archetypeName = TweakDB:GetFlat(record:GetID() .. ".archetypeName"),
                            archetypeData = TweakDB:GetFlat(record:GetID() .. ".archetypeData"),
                            displayName = TweakDB:GetFlat(record:GetID() .. ".displayName"),
                            -- baseAttitudeGroup = TweakDB:GetFlat(record:GetID() .. ".baseAttitudeGroup"),
                            entityTemplatePath = TweakDB:GetFlat(record:GetID() .. ".entityTemplatePath"),
                            scannerModule = TweakDB:GetFlat(record:GetID() .. ".scannerModulePreset"),
                            rarity = TweakDB:GetFlat(record:GetID() .. ".rarity"),
                            -- reactionPreset = TweakDB:GetFlat(record:GetID() .. ".reactionPreset"),
                            statModifierGroups = TweakDB:GetFlat(record:GetID() .. ".statModifierGroups"),
                            statPools = TweakDB:GetFlat(record:GetID() .. ".statPools"),
                            statModifiers = TweakDB:GetFlat(record:GetID() .. ".statModifiers"),
                            voiceTag = TweakDB:GetFlat(record:GetID() .. ".voiceTag"),
                        }
                        table.insert(mainFullCharacterData, character)
                        table.insert(OriginalMainFullCharacterData, character)
                        break
                end
                ::continue::
            end
        end
    end

    if #mainFullCharacterData == 0 then
        return
    end

    shuffledMainFullData = ShuffleTable(mainFullCharacterData)
    if not shuffledMainFullData or #shuffledMainFullData == 0 then
        return
    end

    for i, character in ipairs(mainFullCharacterData) do
        local shuffledFullCharacter = shuffledMainFullData[i]
        local record = tweakDBLookup[character.id]
        if record then
                TweakDB:SetFlat(record:GetID() .. ".abilities", shuffledFullCharacter.abilities)
                TweakDB:SetFlat(record:GetID() .. ".actionMap", shuffledFullCharacter.actionMap)
                TweakDB:SetFlat(record:GetID() .. ".archetypeName", shuffledFullCharacter.archetypeName)
                TweakDB:SetFlat(record:GetID() .. ".archetypeData", shuffledFullCharacter.archetypeData)
                TweakDB:SetFlat(record:GetID() .. ".displayName", shuffledFullCharacter.displayName)
                -- TweakDB:SetFlat(record:GetID() .. ".baseAttitudeGroup", shuffledFullCharacter.baseAttitudeGroup)
                TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", shuffledFullCharacter.entityTemplatePath)
                TweakDB:SetFlat(record:GetID() .. ".scannerModulePreset", shuffledFullCharacter.scannerModule)
                TweakDB:SetFlat(record:GetID() .. ".rarity", shuffledFullCharacter.rarity)
                -- TweakDB:SetFlat(record:GetID() .. ".reactionPreset", shuffledFullCharacter.reactionPreset)
                TweakDB:SetFlat(record:GetID() .. ".statModifierGroups", shuffledFullCharacter.statModifierGroups)
                TweakDB:SetFlat(record:GetID() .. ".statPools", shuffledFullCharacter.statPools)
                TweakDB:SetFlat(record:GetID() .. ".statModifiers", shuffledFullCharacter.statModifiers)
                TweakDB:SetFlat(record:GetID() .. ".voiceTag", shuffledFullCharacter.voiceTag)
        end
    end
    print("[Randomizer2077] Full main character shuffle complete!")
end


function PsychoShuffle()
    local psychoData = {}
    local shuffledData = {}

    if not shufflePsychoIDs or #shufflePsychoIDs == 0 then
        return
    end

    local allCharacters = TweakDB:GetRecords("gamedataCharacter_Record")
    local tweakDBLookup = {}
    for _, record in ipairs(allCharacters) do
        local id = tostring(record:GetID().value):lower()
        tweakDBLookup[id] = record
    end

    for _, id in ipairs(shufflePsychoIDs) do
        local normalizedID = id:lower()

        for tweakDBID, record in pairs(tweakDBLookup) do
            local baseName = tweakDBID:match("character%.(.+)") or tweakDBID
            if baseName == normalizedID then
                local character = {
                    id = tweakDBID,
                    abilities = TweakDB:GetFlat(record:GetID() .. ".abilities"),
                    actionMap = TweakDB:GetFlat(record:GetID() .. ".actionMap"),
                    archetypeName = TweakDB:GetFlat(record:GetID() .. ".archetypeName"),
                    -- baseAttitudeGroup = TweakDB:GetFlat(record:GetID() .. ".baseAttitudeGroup"),
                    entityTemplatePath = TweakDB:GetFlat(record:GetID() .. ".entityTemplatePath"),
                    rarity = TweakDB:GetFlat(record:GetID() .. ".rarity"),
                    -- reactionPreset = TweakDB:GetFlat(record:GetID() .. ".reactionPreset"),
                    statModifierGroups = TweakDB:GetFlat(record:GetID() .. ".statModifierGroups"),
                    statPools = TweakDB:GetFlat(record:GetID() .. ".statPools"),
                    statModifiers = TweakDB:GetFlat(record:GetID() .. ".statModifiers"),
                }
                table.insert(psychoData, character)
                break
            end
        end
    end

    if #psychoData == 0 then
        return
    end

    shuffledData = ShuffleTable(psychoData)
    if not shuffledData or #shuffledData == 0 then
        return
    end

    for i, character in ipairs(psychoData) do
        local shuffledCharacter = shuffledData[i]
        local record = tweakDBLookup[character.id]
        if record then
            TweakDB:SetFlat(record:GetID() .. ".abilities", shuffledCharacter.abilities)
            TweakDB:SetFlat(record:GetID() .. ".actionMap", shuffledCharacter.actionMap)
            TweakDB:SetFlat(record:GetID() .. ".archetypeName", shuffledCharacter.archetypeName)
            -- TweakDB:SetFlat(record:GetID() .. ".baseAttitudeGroup", shuffledCharacter.baseAttitudeGroup)
            TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", shuffledCharacter.entityTemplatePath)
            TweakDB:SetFlat(record:GetID() .. ".rarity", shuffledCharacter.rarity)
            -- TweakDB:SetFlat(record:GetID() .. ".reactionPreset", shuffledCharacter.reactionPreset)
            TweakDB:SetFlat(record:GetID() .. ".statModifierGroups", shuffledCharacter.statModifierGroups)
            TweakDB:SetFlat(record:GetID() .. ".statPools", shuffledCharacter.statPools)
            TweakDB:SetFlat(record:GetID() .. ".statModifiers", shuffledCharacter.statModifiers)
        end
    end
    print("[Randomizer2077] Cyberpsycho shuffle complete!")
end


function TurnEveryonePsycho(psychoPercentage)
    local psychoTemplates = {}
    local allCharacters   = TweakDB:GetRecords("gamedataCharacter_Record")

    psychoPercentage = psychoPercentage or Config.psychoPercentage or 100

    local aggressivePresets = {
        "ReactionPresets.Ganger_Aggressive",
        "ReactionPresets.Mechanical_Aggressive",
        "ReactionPresets.Lore_Aggressive",
        "ReactionPresets.Sleep_Aggressive",
        "ReactionPresets.Corpo_Aggressive"
    }

    for _, record in ipairs(allCharacters) do
        local idValue = record:GetID().value:lower()
        for _, psychoID in ipairs(shufflePsychoIDs) do
            if idValue:find(psychoID:lower()) then
                local psychoData = {
                    abilites           = TweakDB:GetFlat(record:GetID() .. ".abilites"),
                    actionMap          = TweakDB:GetFlat(record:GetID() .. ".actionMap"),
                    archetypeName      = TweakDB:GetFlat(record:GetID() .. ".archetypeName"),
                    entityTemplatePath = TweakDB:GetFlat(record:GetID() .. ".entityTemplatePath"),
                    baseAttitudeGroup  = TweakDB:GetFlat(record:GetID() .. ".baseAttitudeGroup"),
                    reactionPreset     = TweakDB:GetFlat(record:GetID() .. ".reactionPreset"),
                    affiliation        = TweakDB:GetFlat(record:GetID() .. ".affiliation"),
                    rarity             = TweakDB:GetFlat(record:GetID() .. ".rarity"),
                    statModifierGroups = TweakDB:GetFlat(record:GetID() .. ".statModifierGroups"),
                    voiceTag           = TweakDB:GetFlat(record:GetID() .. ".voiceTag"),
                    weakspots          = TweakDB:GetFlat(record:GetID() .. ".weakspots"),
                    EquipmentAreas     = TweakDB:GetFlat(record:GetID() .. ".EquipmentAreas"),
                    archetypeData      = TweakDB:GetFlat(record:GetID() .. ".archetypeData"),
                    attachmentSlots    = TweakDB:GetFlat(record:GetID() .. ".attachmentSlots"),
                    objectActions      = TweakDB:GetFlat(record:GetID() .. ".objectActions"),
                    scannerModulePreset= TweakDB:GetFlat(record:GetID() .. ".scannerModulePreset"),
                    statPools          = TweakDB:GetFlat(record:GetID() .. ".statPools"),
                    statModifiers      = TweakDB:GetFlat(record:GetID() .. ".statModifiers"),
                    threatTrackingPreset= TweakDB:GetFlat(record:GetID() .. ".threatTrackingPreset"),
                    secondaryEquipment = TweakDB:GetFlat(record:GetID() .. ".secondaryEquipment").value,
                    primaryEquipment   = TweakDB:GetFlat(record:GetID() .. ".primaryEquipment").value,
                    lootDrop           = TweakDB:GetFlat(record:GetID() .. ".lootDrop"),
                    lootBagEntity      = TweakDB:GetFlat(record:GetID() .. ".lootBagEntity"),
                    items              = TweakDB:GetFlat(record:GetID() .. ".items"),
                    itemGroups         = TweakDB:GetFlat(record:GetID() .. ".itemGroups"),
                    dropsAmmoOnDeath   = TweakDB:GetFlat(record:GetID() .. ".dropsAmmoOnDeath"),
                    dropsMoneyOnDeath  = TweakDB:GetFlat(record:GetID() .. ".dropsMoneyOnDeath"),
                    dropsWeaponOnDeath = TweakDB:GetFlat(record:GetID() .. ".dropsWeaponOnDeath"),
                    defaultEquipment   = TweakDB:GetFlat(record:GetID() .. ".defaultEquipment").value,
                }
                table.insert(psychoTemplates, psychoData)
                break
            end
        end
    end

    if #psychoTemplates == 0 then
        return
    end

    for _, record in ipairs(allCharacters) do
        local recordID = record:GetID()
        local idValue  = recordID.value:lower()

        if playerDefaults[recordID.value] then goto continue end

        local isExcluded = false
        for _, exclID in ipairs(excludedCharacterIDs) do
            if idValue:find(exclID:lower()) then
                isExcluded = true
                break
            end
        end

        if isExcluded then goto continue end

        local originalData = OriginalNPCData[tostring(recordID.value)] or {}
        local originalReactionPreset = originalData.reactionPreset or {}
        local originalBaseAttitudeGroup = originalData.baseAttitudeGroup or {}
        local originalArchetypeName = originalData.archetypeName or {}

        local presetValue = originalReactionPreset.value or ""
        local baseAttitudeValue = originalBaseAttitudeGroup.value or ""
        local archetypeValue = originalArchetypeName.value or ""

        local isEnemy = false
        for _, preset in ipairs(aggressivePresets) do
            if presetValue:find(preset) then
                isEnemy = true
                break
            end
        end

        if baseAttitudeValue:find("friendly") or baseAttitudeValue:find("civilian") then
            isEnemy = false
        end
        
        if not archetypeValue:find("humanoid") then
            isEnemy = false
        end

        if isEnemy and math.random(100) <= psychoPercentage then
            local randomPsycho = psychoTemplates[math.random(#psychoTemplates)]
            TweakDB:SetFlat(record:GetID() .. ".abilites", randomPsycho.abilites)
            TweakDB:SetFlat(record:GetID() .. ".actionMap", randomPsycho.actionMap)
            --TweakDB:SetFlat(record:GetID() .. ".archetypeName", randomPsycho.archetypeName)
            TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", randomPsycho.entityTemplatePath)
            --TweakDB:SetFlat(record:GetID() .. ".baseAttitudeGroup", randomPsycho.baseAttitudeGroup)
            --TweakDB:SetFlat(record:GetID() .. ".reactionPreset", randomPsycho.reactionPreset)
            TweakDB:SetFlat(record:GetID() .. ".threatTrackingPreset", randomPsycho.threatTrackingPreset)
            TweakDB:SetFlat(record:GetID() .. ".affiliation", randomPsycho.affiliation)
            TweakDB:SetFlat(record:GetID() .. ".rarity", randomPsycho.rarity)
            TweakDB:SetFlat(record:GetID() .. ".statModifierGroups", randomPsycho.statModifierGroups)
            TweakDB:SetFlat(record:GetID() .. ".voiceTag", randomPsycho.voiceTag)
            TweakDB:SetFlat(record:GetID() .. ".weakspots", randomPsycho.weakspots)
            TweakDB:SetFlat(record:GetID() .. ".EquipmentAreas", randomPsycho.EquipmentAreas)
            TweakDB:SetFlat(record:GetID() .. ".archetypeData", randomPsycho.archetypeData)
            TweakDB:SetFlat(record:GetID() .. ".attachmentSlots", randomPsycho.attachmentSlots)
            TweakDB:SetFlat(record:GetID() .. ".objectActions", randomPsycho.objectActions)
            TweakDB:SetFlat(record:GetID() .. ".scannerModulePreset", randomPsycho.scannerModulePreset)
            TweakDB:SetFlat(record:GetID() .. ".statPools", randomPsycho.statPools)
            TweakDB:SetFlat(record:GetID() .. ".statModifiers", randomPsycho.statModifiers)
            TweakDB:SetFlat(record:GetID() .. ".secondaryEquipment", randomPsycho.secondaryEquipment)
            TweakDB:SetFlat(record:GetID() .. ".primaryEquipment", randomPsycho.primaryEquipment)
            TweakDB:SetFlat(record:GetID() .. ".lootDrop", randomPsycho.lootDrop)
            TweakDB:SetFlat(record:GetID() .. ".lootBagEntity", randomPsycho.lootBagEntity)
            TweakDB:SetFlat(record:GetID() .. ".items", randomPsycho.items)
            TweakDB:SetFlat(record:GetID() .. ".itemGroups", randomPsycho.itemGroups)
            TweakDB:SetFlat(record:GetID() .. ".dropsAmmoOnDeath", randomPsycho.dropsAmmoOnDeath)
            TweakDB:SetFlat(record:GetID() .. ".dropsMoneyOnDeath", randomPsycho.dropsMoneyOnDeath)
            TweakDB:SetFlat(record:GetID() .. ".dropsWeaponOnDeath", randomPsycho.dropsWeaponOnDeath)
            TweakDB:SetFlat(record:GetID() .. ".defaultEquipment", randomPsycho.defaultEquipment)
            psychoConverted[tostring(recordID.value)] = true
        elseif not isEnemy then
            goto continue
        end
        ::continue::
    end
    print("[Randomizer2077] NPC to Cyberpyscho randomization complete! Applied to " .. psychoPercentage .. "% of enemies.")
end


function MainBossShuffle()
    local bossCharacterData = {}
    local shuffledData = {}

    if not shuffleBossIDs or #shuffleBossIDs == 0 then
        return
    end

    local allCharacters = TweakDB:GetRecords("gamedataCharacter_Record")
    local tweakDBLookup = {}
    for _, record in ipairs(allCharacters) do
        local id = tostring(record:GetID().value):lower()
        tweakDBLookup[id] = record
    end

    local smasherData = {}

    local function isSmasherVariant(baseName)
        return baseName == "q113_boss_smasher" or baseName == "q116_boss_smasher"
    end

    for _, id in ipairs(shuffleBossIDs) do
        local normalizedID = id:lower()

        for tweakDBID, record in pairs(tweakDBLookup) do
            local baseName = tweakDBID:match("character%.(.+)") or tweakDBID
            if baseName == normalizedID then
                local character = {
                    id = tweakDBID,
                    archetypeName = TweakDB:GetFlat(record:GetID() .. ".archetypeName"),
                    actionMap = TweakDB:GetFlat(record:GetID() .. ".actionMap"),
                    -- baseAttitudeGroup = TweakDB:GetFlat(record:GetID() .. ".baseAttitudeGroup"),
                    objectActions = TweakDB:GetFlat(record:GetID() .. ".objectActions"),
                    entityTemplatePath = TweakDB:GetFlat(record:GetID() .. ".entityTemplatePath"),
                    rarity = TweakDB:GetFlat(record:GetID() .. ".rarity"),
                    -- reactionPreset = TweakDB:GetFlat(record:GetID() .. ".reactionPreset"),
                    secondaryEquip = TweakDB:GetFlat(record:GetID() .. ".secondaryEquipment").value,
                    primaryEquip = TweakDB:GetFlat(record:GetID() .. ".primaryEquipment").value,
                    defaultEquip = TweakDB:GetFlat(record:GetID() .. ".defaultEquipment").value,
                    voiceTag = TweakDB:GetFlat(record:GetID() .. ".voiceTag"),
                    items = TweakDB:GetFlat(record:GetID() .. ".items"),
                    itemGroups = TweakDB:GetFlat(record:GetID() .. ".itemGroups"),
                    weakspots = TweakDB:GetFlat(record:GetID() .. ".weakspots"),
                    EquipmentAreas = TweakDB:GetFlat(record:GetID() .. ".EquipmentAreas"),
                    attachmentSlots = TweakDB:GetFlat(record:GetID() .. ".attachmentSlots"),
                    archetypeData = TweakDB:GetFlat(record:GetID() .. ".archetypeData"),

                }
                if isSmasherVariant(baseName) then
                    table.insert(smasherData, character)
                else
                    table.insert(bossCharacterData, character)
                end
                break
            end
        end
    end

    if #bossCharacterData == 0 then
        return
    end

    shuffledData = ShuffleTable(bossCharacterData)
    if not shuffledData or #shuffledData == 0 then
        return
    end

    for i, character in ipairs(bossCharacterData) do
        local shuffledCharacter = shuffledData[i]
        local record = tweakDBLookup[character.id]
        if record then
            TweakDB:SetFlat(record:GetID() .. ".archetypeName", shuffledCharacter.archetypeName)
            TweakDB:SetFlat(record:GetID() .. ".actionMap", shuffledCharacter.actionMap)
            -- TweakDB:SetFlat(record:GetID() .. ".baseAttitudeGroup", shuffledCharacter.baseAttitudeGroup)
            TweakDB:SetFlat(record:GetID() .. ".objectActions", shuffledCharacter.objectActions)
            TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", shuffledCharacter.entityTemplatePath)
            TweakDB:SetFlat(record:GetID() .. ".rarity", shuffledCharacter.rarity)
            -- TweakDB:SetFlat(record:GetID() .. ".reactionPreset", shuffledCharacter.reactionPreset)
            TweakDB:SetFlat(record:GetID() .. ".secondaryEquipment", shuffledCharacter.secondaryEquip)
            TweakDB:SetFlat(record:GetID() .. ".primaryEquipment", shuffledCharacter.primaryEquip)
            TweakDB:SetFlat(record:GetID() .. ".defaultEquipment", shuffledCharacter.defaultEquip)
            TweakDB:SetFlat(record:GetID() .. ".voiceTag", shuffledCharacter.voiceTag)
            TweakDB:SetFlat(record:GetID() .. ".items", shuffledCharacter.items)
            TweakDB:SetFlat(record:GetID() .. ".itemGroups", shuffledCharacter.itemGroups)
            TweakDB:SetFlat(record:GetID() .. ".weakspots", shuffledCharacter.weakspots)
            TweakDB:SetFlat(record:GetID() .. ".EquipmentAreas", shuffledCharacter.EquipmentAreas)
            TweakDB:SetFlat(record:GetID() .. ".attachmentSlots", shuffledCharacter.attachmentSlots)
            TweakDB:SetFlat(record:GetID() .. ".archetypeData", shuffledCharacter.archetypeData)
        end
    end

    for i, character in ipairs(smasherData) do
        local shuffledCharacter = shuffledData[math.random(#shuffledData)]
        local record = tweakDBLookup[character.id]
        if record then
            TweakDB:SetFlat(record:GetID() .. ".archetypeName", shuffledCharacter.archetypeName)
            TweakDB:SetFlat(record:GetID() .. ".actionMap", shuffledCharacter.actionMap)
            -- TweakDB:SetFlat(record:GetID() .. ".baseAttitudeGroup", shuffledCharacter.baseAttitudeGroup)
            TweakDB:SetFlat(record:GetID() .. ".objectActions", shuffledCharacter.objectActions)
            TweakDB:SetFlat(record:GetID() .. ".entityTemplatePath", shuffledCharacter.entityTemplatePath)
            TweakDB:SetFlat(record:GetID() .. ".rarity", shuffledCharacter.rarity)
            -- TweakDB:SetFlat(record:GetID() .. ".reactionPreset", shuffledCharacter.reactionPreset)
            TweakDB:SetFlat(record:GetID() .. ".secondaryEquipment", shuffledCharacter.secondaryEquip)
            TweakDB:SetFlat(record:GetID() .. ".primaryEquipment", shuffledCharacter.primaryEquip)
            TweakDB:SetFlat(record:GetID() .. ".defaultEquipment", shuffledCharacter.defaultEquip)
            TweakDB:SetFlat(record:GetID() .. ".voiceTag", shuffledCharacter.voiceTag)
            TweakDB:SetFlat(record:GetID() .. ".items", shuffledCharacter.items)
            TweakDB:SetFlat(record:GetID() .. ".itemGroups", shuffledCharacter.itemGroups)
            TweakDB:SetFlat(record:GetID() .. ".weakspots", shuffledCharacter.weakspots)
            TweakDB:SetFlat(record:GetID() .. ".EquipmentAreas", shuffledCharacter.EquipmentAreas)
            TweakDB:SetFlat(record:GetID() .. ".attachmentSlots", shuffledCharacter.attachmentSlots)
            TweakDB:SetFlat(record:GetID() .. ".archetypeData", shuffledCharacter.archetypeData)
        end
    end
    print("[Randomizer2077] Boss character shuffle complete!")
end


------------
--Handlers--
------------


function ReadFile(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end


function SaveFile(path, data)
    local file = io.open(path, "w")
    local jconfig = Json.encode(data)
    file:write(jconfig)
    file:close()
end


function LoadConfig()
    local jsonStr = ReadFile("config.json")
    if jsonStr ~= nil and string.len(jsonStr) > 0 then
        Config = Json.decode(jsonStr)
        print("[Randomizer2077] Config loaded successfully: " .. Json.encode(Config))
    else
        Config.seed = math.random(-1000000000, 1000000000)
        SaveConfig()
        print("[Randomizer2077] Config created with default values.")
    end
end


function SaveConfig()
    SaveFile("config.json", Config)
end


registerForEvent("onInit", function()
    local nativeSettings = GetMod("nativeSettings")
    LoadConfig()

    BackupOriginalNPCData()
    CacheDefaultAttacks()
    BackupPlayerDefaults()
    BackupVehicleDefaults()

    math.randomseed(Config.seed)

    --print("[Randomizer2077] nativeSettings:", nativeSettings)

    print("[Randomizer2077] Randomizer2077 Mod initialized.")

    if Config.IsRandom then
        RevertRandom()
        CharacterRandomizer()
    end
    if Config.IsMainShuffle then
        MainCharacterShuffle()
    end
    if Config.IsMainFullShuffle then
        MainCharacterShuffle()
    end
    if Config.IsBossShuffle then
        MainBossShuffle()
    end
    if Config.IsPsychoShuffle then
        PsychoShuffle()
    end
    if Config.IsEveryonePsycho then
        TurnEveryonePsycho(Config.psychoPercentage)
    end
    if Config.IsLootRandom then
        LootRandomizer()
    end
    if Config.IsComponentRandom then
        LootRandomizer()
    end
    if Config.IsVendorRandom then
        VendorRandomizer()
    end
    if Config.IsAdRandom then
        AdRandomizer()
    end
    if Config.IsVehicleRandom then
        VehicleRandomizer()
    end
    if Config.IsFirearmChaos then
        ChaoticFirearms()
    end

    nativeSettings.addTab("/randomizer", "Randomizer")
    nativeSettings.addSubcategory("/randomizer/seed", "Seed")
    nativeSettings.addSubcategory("/randomizer/rando", "Randomizers")
    nativeSettings.addSubcategory("/randomizer/shuffle", "Shufflers")
    nativeSettings.addSubcategory("/randomizer/chaos", "Chaos")

    nativeSettings.addButton("/randomizer/seed", "Regenerate Seed", "Regenerate current seed. Text does not update.", tostring(Config.seed), 25, function()
        Config.seed = math.random(-1000000000, 1000000000)
        SaveConfig()
        if Config.IsRandom then
            RevertRandom()
            CharacterRandomizer()                
        end
        if Config.IsMainShuffle then
            MainCharacterShuffle()
        end
        if Config.IsMainFullShuffle then
            MainCharacterShuffle()
        end
        if Config.IsBossShuffle then
            MainBossShuffle()
        end
        if Config.IsPsychoShuffle then
            PsychoShuffle()
        end
        if Config.IsEveryonePsycho then
            TurnEveryonePsycho(Config.psychoPercentage)
        end
        if Config.IsStartingRandom then
            StartingInventoryRandomizer()
        end
        if Config.IsLootRandom then
            LootRandomizer()
        end
        if Config.IsComponentRandom then
            LootRandomizer()
        end
        if Config.IsVendorRandom then
            VendorRandomizer()
        end
        if Config.IsAdRandom then
            AdRandomizer()
        end
        if Config.IsVehicleRandom then
            RestoreVehicleDefaults()
            VehicleRandomizer()
        end
        if Config.IsFirearmChaos then
            RestoreDefaultAttacks()
            ChaoticFirearms()
        end
        print("[Randomizer2077] New seed generated: " .. Config.seed)
    end)


    nativeSettings.addSwitch("/randomizer/rando", "Randomize NPCs", "If on, most NPCs will be randomized. Excludes major characters and a few other NPCs necessary to complete main quests.", Config.IsRandom, false, function(state)
        Config.IsRandom = state
        SaveConfig()
        if Config.IsRandom then
            RevertRandom()
            CharacterRandomizer()
        else
            RestorePlayerDefaults()
            RevertRandom()
        end
    end)

    nativeSettings.addSwitch("/randomizer/rando", "Randomize Weapon Stats", "Randomizes weapon stats, crosshairs, and ammo type.", Config.IsFirearmChaos, false, function(state)
        Config.IsFirearmChaos = state
        SaveConfig()
        if Config.IsFirearmChaos then
            CacheDefaultAttacks()
            ChaoticFirearms()
        else
            RestoreDefaultAttacks()
        end
    end)

    nativeSettings.addSwitch("/randomizer/rando", "Randomize Starting Inventory", "If on, the mission 'The Rescue' will start you off with a random weapon and a random set of clothes (wait 1 minute for it to take effect if you skip the intro cutscene).", Config.IsStartingRandom, false, function(state)
        Config.IsStartingRandom = state
        SaveConfig()
        if Config.IsStartingRandom then
            print("[Randomizer2077] Starting Inventory randomization complete!")
            StartingInventoryRandomizer()
        else
            RestoreVehicleDefaults()
        end
    end)

    nativeSettings.addSwitch("/randomizer/rando", "Randomize Player Vehicles", "Randomizes the player's vehicles.", Config.IsVehicleRandom, false, function(state)
        Config.IsVehicleRandom = state
        SaveConfig()
        if Config.IsVehicleRandom then
            VehicleRandomizer()
        else
            RestoreVehicleDefaults()
        end
    end)

    nativeSettings.addSwitch("/randomizer/rando", "Randomize Loot", "If on, loot on NPCs and in the world will be randomized. Loot required to complete quests is excluded.", Config.IsLootRandom, false, function(state)
        Config.IsLootRandom = state
        SaveConfig()
        if Config.IsLootRandom then
            LootRandomizer()
        else
            RestorePlayerDefaults()
        end
    end)

    nativeSettings.addSwitch("/randomizer/rando", "Include Components", "By default, crafting & quickhack components are not randomized to prevent seeing the same item everywhere. Turn this on to randomize them anyway.", Config.IsComponentRandom, false, function(state)
        Config.IsComponentRandom = state
        SaveConfig()
        if Config.IsComponentRandom then
            LootRandomizer()
        else
            RestorePlayerDefaults()
        end
    end)

    nativeSettings.addSwitch("/randomizer/rando", "Randomize Vendors", "If on, vendor inventory will be randomized. Items required to complete quests are excluded.", Config.IsVendorRandom, false, function(state)
        Config.IsVendorRandom = state
        SaveConfig()
        if Config.IsVendorRandom then
            VendorRandomizer()
        else
            RestorePlayerDefaults()
        end
    end)

    nativeSettings.addSwitch("/randomizer/rando", "Randomize Ads", "If on, ads around Night City will be randomized. What for? I didn't think that far.", Config.IsAdRandom, false, function(state)
        Config.IsAdRandom = state
        SaveConfig()
        if Config.IsAdRandom then
            AdRandomizer()
        end
    end)

    nativeSettings.addSwitch("/randomizer/shuffle", "Shuffle Main Characters", "Randomizes main characters between each other, based on body type for a smoother experience.", Config.IsMainShuffle, false, function(state)
        Config.IsMainShuffle = state
        SaveConfig()
        if Config.IsMainShuffle then
            MainCharacterShuffle()
        else
            RestorePlayerDefaults()
            RevertMainShuffle()
        end
    end)

    nativeSettings.addSwitch("/randomizer/shuffle", "Shuffle Main Bosses", "Randomizes main bosses between each other.", Config.IsBossShuffle, false, function(state)
        Config.IsBossShuffle = state
        SaveConfig()
        if Config.IsBossShuffle then
            MainBossShuffle()
        else
            RestorePlayerDefaults()
            RevertRandom()
        end
    end)

    nativeSettings.addSwitch("/randomizer/shuffle", "Shuffle Cyberpyschos", "Randomizes cyberpsychos between each other.", Config.IsPsychoShuffle, false, function(state)
        Config.IsPsychoShuffle = state
        SaveConfig()
        if Config.IsPsychoShuffle then
            PsychoShuffle()
        else
            RestorePlayerDefaults()
            RevertRandom()
        end
    end)

    nativeSettings.addSwitch("/randomizer/chaos", "Full Main Character Shuffle", "Randomizes main characters between each other, regardless of body type - can cause softlocks.", Config.IsMainFullShuffle, false, function(state)
        Config.IsMainFullShuffle = state
        SaveConfig()
        if Config.IsMainFullShuffle then
            MainCharacterShuffle()
        else
            RestorePlayerDefaults()
            RevertMainShuffle()
        end
    end)

    nativeSettings.addRangeInt("/randomizer/chaos", "Cyberpsycho Percentage", "Select the percentage of enemies turned into cyberpsychos (turn off 'Enemies Are Cyberpsychos' to comfortably change the percentage).", 0, 100, 1, Config.psychoPercentage, 0, function(value)
        Config.psychoPercentage = value
        SaveConfig()
        if Config.IsEveryonePsycho then
            TurnEveryonePsycho(value)
        end
    end)

    nativeSettings.addSwitch("/randomizer/chaos", "Enemies Are Cyberpsychos", "If on, enemies will be replaced with random Cyberpsychos based on the selected percentage. For it to work properly in conjunction with the NPC Randomizer, have both turned on and then re-launch the game. Good luck!", Config.IsEveryonePsycho, false, function(state)
        Config.IsEveryonePsycho = state
        SaveConfig()
        if state then
            TurnEveryonePsycho(Config.psychoPercentage)
        else
            RestorePlayerDefaults()
            RevertRandom()
        end
    end)

    nativeSettings.addSwitch("/randomizer/chaos", "Cursed Randomizer", "The original mod. If on, every NPC, including story/quest NPCs, will be randomized. Can cause frequent softlocks, turn on at your own risk!", Config.IsMainRandom, false, function(state)
        Config.IsMainRandom = state
        SaveConfig()
        if Config.IsMainRandom then
            CharacterRandomizer()
        else
            RestorePlayerDefaults()
            RevertRandom()
        end
    end)
end)


inventoryRDM = false

registerForEvent('onUpdate', function(delta)
    Cron.Update(delta)

    if Config.IsStartingRandom and not inventoryRDM then

        local tracked = Game.GetJournalManager():GetTrackedEntry()
        if not tracked then return end

        local parent = Game.GetJournalManager():GetParentEntry(tracked)
        if not parent then return end

        local grandparent = Game.GetJournalManager():GetParentEntry(parent)
        if not grandparent then return end

        local questId = grandparent:GetId()
        if questId == "q001_intro" then
            Cron.After(100, StartingInventoryRandomizer)
            inventoryRDM = true
        end
    end
end)


for id, data in pairs(playerDefaults) do
    print("Player ID: " .. id)
    for key, value in pairs(data) do
        print(key .. ": " .. tostring(value))
    end
end