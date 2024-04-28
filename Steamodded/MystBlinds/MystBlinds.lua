--- STEAMODDED HEADER
--- MOD_NAME: Myst's Boss Blinds
--- MOD_ID: MystBlinds
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: A pack of Blinds
--- DISPLAY_NAME: MystBlinds
--- BADGE_COLOUR: EDA9D3

local blind_list = {
    "market",
    "stone",
    "monster",
    "insect",
    "final_silence",
    "bird",
    "ancestor",
    "final_mist",

    -- The Monster and Noir Silence are disabled until the next Steamodded release
}

function SMODS.INIT.MystBlinds()
    local mod_path = SMODS.findModByID("MystBlinds").path
    SMODS.Sprite:new("MystBlinds", SMODS.findModByID("MystBlinds").path, "MystBlinds.png", 34, 34, "animation_atli", 21):register()

    G.localization.misc.dictionary.ph_ancestor = "(Round * 1.5)"

    -- basically taken from 5CEBalatro lol
    for k, v in ipairs(blind_list) do
        local blind = NFS.load(mod_path.."indiv_blinds/"..v..".lua")()

        -- don't fuck up the mod
        if not blind then
            sendErrorMessage("[MystBlinds] Cannot find blind with shorthand: "..v)
        else
            SMODS.Blind:new(blind.name, 'myst_'..blind.slug, blind.localization, blind.dollars, blind.mult, blind.vars, blind.debuff, {x = 0, y = k-1}, blind.boss, blind.color, true, "MystBlinds"):register()

            if blind.set_blind then SMODS.Blinds['bl_myst_'..v].set_blind = blind.set_blind end
            if blind.disable then SMODS.Blinds['bl_myst_'..v].disable = blind.disable end
            if blind.defeat then SMODS.Blinds['bl_myst_'..v].defeat = blind.defeat end
            if blind.debuff_card then SMODS.Blinds['bl_myst_'..v].debuff_card = blind.debuff_card end
            if blind.stay_flipped then SMODS.Blinds['bl_myst_'..v].stay_flipped = blind.stay_flipped end
            if blind.drawn_to_hand then SMODS.Blinds['bl_myst_'..v].drawn_to_hand = blind.drawn_to_hand end
            if blind.debuff_hand then SMODS.Blinds['bl_myst_'..v].debuff_hand = blind.debuff_hand end
            if blind.modify_hand then SMODS.Blinds['bl_myst_'..v].modify_hand = blind.modify_hand end
            if blind.press_play then SMODS.Blinds['bl_myst_'..v].press_play = blind.press_play end
            if blind.get_loc_debuff_text then SMODS.Blinds['bl_myst_'..v].get_loc_debuff_text = blind.get_loc_debuff_text end
            if blind.loc_def then SMODS.Blinds['bl_myst_'..v].loc_def = blind.loc_def end
        end
    end

    sendInfoMessage("Loaded MystBlinds~")
end

---- Other functions ----