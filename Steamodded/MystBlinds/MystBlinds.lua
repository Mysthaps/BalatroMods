--- STEAMODDED HEADER
--- MOD_NAME: Myst's Boss Blinds
--- MOD_ID: MystBlinds
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: A pack of Blinds

local localization = {
    bl_market = {
        name = "The Market",
        text = {
            "Lose 25% of scored chips",
            "after each hand played"
        }
    },
    bl_stone = {
        name = "The Stone",
        text = {
            "All Enhanced cards",
            "are debuffed"
        }
    },
    bl_monster = {
        name = "The Monster",
        text = {
            "Destroy all consumables,",
            "0 consumable slots"
        }
    },
    bl_insect = {
        name = "The Insect",
        text = {
            "Debuff leftmost Joker",
            "whenever cards are drawn"
        }
    },
    bl_noir_silence = {
        name = "Noir Silence",
        text = {
            "-4 Hand Size, +1 Hand Size",
            "after each hand played"
        }
    },
}

local blinds = {
    {
        shorthand = "bl_market",
        name = "The Market", 
        defeated = false, discovered = true, alerted = true, 
        dollars = 5, mult = 2, 
        vars = {}, debuff = {}, 
        pos = {x = 0, y = 0}, atlas = "MystBlinds",
        boss = {min = 3, max = 10},
        boss_colour = HEX('76C860')
    },
    {
        shorthand = "bl_stone",
        name = "The Stone", 
        defeated = false, discovered = true, alerted = true, 
        dollars = 5, mult = 2, 
        vars = {}, debuff = {}, 
        pos = {x = 0, y = 1}, atlas = "MystBlinds",
        boss = {min = 2, max = 10},
        boss_colour = HEX('85898C')
    },
    {
        shorthand = "bl_monster",
        name = "The Monster", 
        defeated = false, discovered = true, alerted = true, 
        dollars = 5, mult = 2, 
        vars = {}, debuff = {}, 
        pos = {x = 0, y = 2}, atlas = "MystBlinds",
        boss = {min = 2, max = 10},
        boss_colour = HEX('3C074D')
    },
    {
        shorthand = "bl_insect",
        name = "The Insect", 
        defeated = false, discovered = true, alerted = true, 
        dollars = 5, mult = 2, 
        vars = {}, debuff = {}, 
        pos = {x = 0, y = 3}, atlas = "MystBlinds",
        boss = {min = 3, max = 10},
        boss_colour = HEX('873E2C')
    },
    {
        shorthand = "bl_noir_silence",
        name = "Noir Silence", 
        defeated = false, discovered = true, alerted = true, 
        dollars = 8, mult = 2, 
        vars = {}, debuff = {}, 
        pos = {x = 0, y = 4}, atlas = "MystBlinds",
        boss = {showdown = true, min = 10, max = 10},
        boss_colour = HEX('404040')
    }
}

function SMODS.INIT.MystBlinds()
    sendDebugMessage("Loaded MystBlinds~")

    -- Localization
    for k, v in pairs(localization) do
        G.localization.descriptions.Blind[k] = v
    end
    init_localization()

    -- Blinds
    for k, v in ipairs(blinds) do
        local blind = v
        blind.key = v.shorthand

        blind.order = 30 + k
        G.P_BLINDS[v.shorthand] = blind
    end

    -- Sprites
    SMODS.Sprite:new("MystBlinds", SMODS.findModByID("MystBlinds").path, "MystBlinds.png", 34, 34, "animation_atli", 21):register()
end

---- Blind:set_blind // The Market, The Monster, Noir Silence
local set_blindref = Blind.set_blind
function Blind.set_blind(self, blind, reset, silent)
    set_blindref(self, blind, reset, silent)
    if not reset then
        if self.name == "The Market" then
            self.prepped = nil
            self.discards_sub = 1
        end
        if self.name == "Noir Silence" then
            self.prepped = nil
            self.discards_sub = 1
            self.hands_sub = math.min(G.hand.config.card_limit - 1, 4)
            G.hand:change_size(-self.hands_sub)
        end
        if self.name == "The Monster" then
            G.GAME.consumeable_buffer = 0
            
            ---- check for Chicot
            local has_chicot = false
            for _, v in ipairs(G.jokers.cards) do
                if v.ability.name == "Chicot" then has_chicot = true end
            end

            if not has_chicot then
                for k, v in ipairs(G.consumeables.cards) do
                    v:start_dissolve(nil, (k ~= 1))
                end

                self.hands_sub = G.consumeables.config.card_limit
                G.consumeables.config.card_limit = G.consumeables.config.card_limit - self.hands_sub
            end
        end
    end
end

---- Blind:press_play // The Market, Noir Silence
local press_playref = Blind.press_play
function Blind.press_play(self)
    press_playref(self)
    if not self.disabled then
        if self.name == "The Market" or self.name == "Noir Silence" then
            self.prepped = true
        end
    end
end

---- Blind:debuff_card // The Stone
local debuff_cardref = Blind.debuff_card
function Blind.debuff_card(self, card, from_blind)
    debuff_cardref(self, card, from_blind)
    if self.debuff and not self.disabled and card.area ~= G.jokers then
        if self.name == "The Stone" and card.config.center ~= G.P_CENTERS.c_base then
            card:set_debuff(true)
            return
        end
    end
end

---- Blind:disable // The Monster, Noir Silence
local disableref = Blind.disable
function Blind.disable(self)
    disableref(self)
    if self.name == "The Monster" then
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + self.hands_sub
    end
    if self.name == "Noir Silence" then
        G.hand:change_size(self.hands_sub)
    end
end

---- Blind:defeat // The Monster, Noir Silence
local defeatref = Blind.defeat
function Blind.defeat(self, silent)
    defeatref(self, silent)
    if self.name == "The Monster" and not self.disabled then
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + self.hands_sub
    end
    if self.name == "Noir Silence" and not self.disabled then
        G.hand:change_size(self.hands_sub)
    end
end

---- Blind:drawn_to_hand // The Market, Noir Silence, The Insect
local drawn_to_handref = Blind.drawn_to_hand
function Blind.drawn_to_hand(self)
    drawn_to_handref(self)
    if not self.disabled then 
        if self.name == "The Market" and G.GAME.current_round.hands_played == self.discards_sub then
            self:wiggle()
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blocking = false,
                ref_table = G.GAME,
                ref_value = 'chips',
                ease_to = G.GAME.chips - math.floor(G.GAME.chips/4),
                delay =  0.5,
                func = (function(t) return math.floor(t) end)
            }))
            self.discards_sub = self.discards_sub + 1
        end
        if self.name == "Noir Silence" and G.GAME.current_round.hands_played == self.discards_sub then
            G.hand:change_size(1)
            self.discards_sub = self.discards_sub + 1 -- hands played
            self.hands_sub = self.hands_sub - 1 -- size removed
            self:wiggle()
        end
        if self.name == "The Insect" then
            if G.jokers and G.jokers.cards[1] and not G.jokers.cards[1].debuffed then
                G.jokers.cards[1]:set_debuff(true)
                G.jokers.cards[1]:juice_up()
                self:wiggle()
            end
        end
    end
end
