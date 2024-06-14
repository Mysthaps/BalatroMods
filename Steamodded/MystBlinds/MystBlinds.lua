--- STEAMODDED HEADER
--- MOD_NAME: Myst's Boss Blinds
--- MOD_ID: MystBlinds
--- PREFIX: myst
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: A pack of Blinds
--- DISPLAY_NAME: MystBlinds
--- BADGE_COLOUR: EDA9D3
--- VERSION: 1.2.3

local blind_list = {
    "market",
    "stone",
    "monster",
    "insect",
    "final_silence",
    "bird",
    "ancestor",
    "final_mist",
    "fruit",
    "food",
    "center",
    "symbol",
}

local mod_path = SMODS.current_mod.path
SMODS.Atlas({ 
    key = "MystBlinds", 
    atlas_table = "ANIMATION_ATLAS", 
    path = "MystBlinds.png", 
    px = 34, 
    py = 34, 
    frames = 21 
})

-- basically taken from 5CEBalatro lol
for k, v in ipairs(blind_list) do
    local blind = NFS.load(mod_path .. "indiv_blinds/" .. v .. ".lua")()

    -- don't fuck up the mod
    if not blind then
        sendErrorMessage("[MystBlinds] Cannot find blind with shorthand: " .. v)
    else
        blind.key = v
        blind.atlas = "MystBlinds"
        -- very hardcoded but w/e
        blind.pos = { x = 0, y = k - 1 }

        local blind_obj = SMODS.Blind(blind)

        for k_, v_ in pairs(blind) do
            if type(v_) == 'function' then
                blind_obj[k_] = blind[k_]
            end
        end
    end
end

-- Add mod's icon
SMODS.Atlas({
    key = "modicon",
    path = "mystblinds_icon.png",
    px = 34,
    py = 34
}):register()

sendInfoMessage("Loaded MystBlinds~")

---- Other functions ----

-- Blacklist The Stone on Cryptid's enhanced decks
local apply_to_runref = Back.apply_to_run
function Back.apply_to_run(self)
    apply_to_runref(self)

    if self.effect.config.cry_force_enhancement then
        G.GAME.bosses_used["bl_myst_stone"] = 1e308
    end
end