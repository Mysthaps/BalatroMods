--- STEAMODDED HEADER
--- MOD_NAME: R Key
--- MOD_ID: RKeyJoker
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: Adds a basic R Key Joker to the game

----------------------------------------------
------------MOD CODE -------------------------

function table_length(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

function SMODS.INIT.MystJokers()
    local mystJokers = {
        -- R Key - -10 Ante, down to minimum of 1
        j_rkey = {
            order = 0,
            unlocked = true,
            discovered = true,
            blueprint_compat = false,
            eternal_compat = false,
            rarity = 3,
            cost = 99,
            name = "R Key",
            set = "Joker",
            config = { extra = {}},
            pos = { x = 0, y = 16 }
        },
    }

    -- Add Jokers to center
    for k, v in pairs(mystJokers) do
        v.key = k
        v.order = table_length(G.P_CENTER_POOLS['Joker']) + 1
        G.P_CENTERS[k] = v
        table.insert(G.P_CENTER_POOLS['Joker'], v)
    end

    table.sort(G.P_CENTER_POOLS["Joker"], function (a, b) return a.order < b.order end)

    -- Localization
    local jokerLocalization = {
        j_rkey = {
            name = "R Key",
            text = {
                "Sell this Joker to",
                "reduce Ante by {C:attention}10{}, down to {C:attention}1{}",
                "All future {C:attention}R Keys{}",
                "will not work once sold"
            }
        },
    }
    for k, v in pairs(jokerLocalization) do
        G.localization.descriptions.Joker[k] = v
    end

    -- Update localization
    for g_k, group in pairs(G.localization) do
        if g_k == 'descriptions' then
            for _, set in pairs(group) do
                for _, center in pairs(set) do
                    center.text_parsed = {}
                    for _, line in ipairs(center.text) do
                        center.text_parsed[#center.text_parsed + 1] = loc_parse_string(line)
                    end
                    center.name_parsed = {}
                    for _, line in ipairs(type(center.name) == 'table' and center.name or { center.name }) do
                        center.name_parsed[#center.name_parsed + 1] = loc_parse_string(line)
                    end
                    if center.unlock then
                        center.unlock_parsed = {}
                        for _, line in ipairs(center.unlock) do
                            center.unlock_parsed[#center.unlock_parsed + 1] = loc_parse_string(line)
                        end
                    end
                end
            end
        end
    end

    -- Add sprites
    local rkey_mod = SMODS.findModByID("RKeyJoker")
    local sprite_rkey = SMODS.Sprite:new("Joker", rkey_mod.path, "Jokers_rkey.png", 71, 95, "asset_atli")

    sprite_rkey:register()
end

-- Init variables
local init_game_objectobjref = Game.init_game_object;
function Game.init_game_object(self)
	local gameObj = init_game_objectobjref(self)

    gameObj.used_rkey = false

    return gameObj
end

-- Joker abilities
local set_abilityref = Card.set_ability
function Card.set_ability(self, center, initial, delay_sprites)
    set_abilityref(self, center, initial, delay_sprites)

    if self.ability.name == "R Key" then
        if self.area == G.joker then self.base_cost = 7 end
        self.sell_cost = 4
        --if G.GAME.used_rkey then sendDebugMessage("r key used") end
    end
end

local calculate_jokerref = Card.calculate_joker
function Card.calculate_joker(self, context)
    local calc_ref = calculate_jokerref(self, context)

    if self.ability.set == "Joker" and not self.debuff then
        if context.selling_self then
            if self.ability.name == "R Key" then
                -- visual
                if G.GAME.used_rkey then
                    self:set_debuff(true)
                else
                    G.GAME.used_rkey = true

                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            for _ = 1, 10 do
                                sendDebugMessage(G.GAME.round_resets.blind_ante)
                                sendDebugMessage(G.GAME.round_resets.ante)

                                if G.GAME.round_resets.blind_ante <= 0 or G.GAME.round_resets.ante <= 0 then break end

                                ease_ante(-1)
                                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - 1
                                delay(0.2)
                            end
                            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                            return true
                        end)
                    }))
                end
            end
        end
    end

    return calc_ref
end
----------------------------------------------
------------MOD CODE END----------------------
