--- STEAMODDED HEADER
--- MOD_NAME: R Key
--- MOD_ID: RKeyJoker
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: Adds a basic R Key Joker to the game

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.RKeyJoker()
    local jokers = {
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
            pos = { x = 0, y = 0 },
            atlas = "RKeyJoker"
        },
    }

    -- Add Jokers to center
    for k, v in pairs(jokers) do
        v.key = k
        v.order = #G.P_CENTER_POOLS['Joker'] + 1
        G.P_CENTERS[k] = v
        table.insert(G.P_CENTER_POOLS['Joker'], v)
        table.insert(G.P_JOKER_RARITY_POOLS[v.rarity], v)
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
    init_localization()

    -- Add sprites
    local rkey_mod = SMODS.findModByID("RKeyJoker")
    local sprite_rkey = SMODS.Sprite:new("RKeyJoker", rkey_mod.path, "Joker_rkey.png", 71, 95, "asset_atli")

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
        self.ability.extra_value = -94
        self:set_sprites(center)
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
