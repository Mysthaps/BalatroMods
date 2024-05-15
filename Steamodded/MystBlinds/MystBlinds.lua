--- STEAMODDED HEADER
--- MOD_NAME: Myst's Boss Blinds
--- MOD_ID: MystBlinds
--- PREFIX: myst
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
}

local mod_path = SMODS.current_mod.path
SMODS.Sprite({ key = "MystBlinds", atlas = "ANIMATION_ATLAS", path = "MystBlinds.png", px = 34, py = 34, frames = 21 })

-- basically taken from 5CEBalatro lol
for k, v in ipairs(blind_list) do
    local blind = NFS.load(mod_path .. "indiv_blinds/" .. v .. ".lua")()

    -- don't fuck up the mod
    if not blind then
        sendErrorMessage("[MystBlinds] Cannot find blind with shorthand: " .. v)
    else
        blind.key = v
        blind.atlas = "MystBlinds"
        blind.pos = { x = 0, y = k - 1 }
        blind.defeated = true

        local blind_obj = SMODS.Blind(blind)

        for k_, v_ in pairs(blind) do
            if type(v_) == 'function' then
                blind_obj[k_] = blind[k_]
            end
        end
    end
end

sendInfoMessage("Loaded MystBlinds~")

---- Other functions ----
