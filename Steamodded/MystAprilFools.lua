--- STEAMODDED HEADER
--- MOD_NAME: Better Balatro (Myst's April Fools)
--- MOD_ID: MystAprilFools
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: makes the game actually playable. Thank you to beeks17 for playtesting!

--[[





SPOILERS FROM THIS POINT ONWARDS.
YOU HAVE BEEN WARNED.





]]--


-- Configs
local conf = {
    blind_overwrite_chance = 50, -- int: 0 to 100
    joker_randomization_chance = 10, -- int: 0 to 100
    randomize_eternals = true, -- bool: true/false
    consumable_fail_chance = 10, -- int: 0 to 100
    wheel_always_fails = true, -- bool: true/false
    edition_nerfs = true, -- bool: true/false
}
-- Modifying the configs requires a game reload.

function SMODS.INIT.MystAprilFools()
    sendDebugMessage("Loaded MystAprilFools~ Have fun!")
    if conf.edition_nerfs then
        G.P_CENTERS.e_foil.config.extra = 49
        G.P_CENTERS.e_holo.config.extra = 9.9
        G.P_CENTERS.e_polychrome.config.extra = 1.49
        G.P_CENTERS.e_negative.config.extra = 0.99
    end
end

-- blind_overwrite
local set_blindref = Blind.set_blind
function Blind.set_blind(self, blind, reset, silent)
    if not reset and blind then
        if blind.name == "Small Blind" or blind.name == "Big Blind" then
            if pseudorandom(pseudoseed('blind_overwrite'), 1, 100) <= conf.blind_overwrite_chance then
                local blind_type = blind.name
                local blind_mult = blind.mult

                local keys = {}
                for k in pairs(G.P_BLINDS) do
                    if k ~= "bl_small" and k ~= "bl_big" then
                        table.insert(keys, k)
                    end
                end
                local chosen_blind = pseudorandom_element(keys, pseudoseed('boss_select'))
                blind = copy_table(G.P_BLINDS[chosen_blind])
                blind.is_definitely_not_boss = blind_type
                blind.mult = blind_mult

                if blind_type == "Small Blind" then
                    blind.dollars = 3
                else
                    blind.dollars = 4
                end
                
                if blind.name == "The Wall" then
                    blind.mult = blind.mult * 2
                elseif blind.name == "The Needle" then
                    blind.mult = blind.mult / 2
                elseif blind.name == "Violet Vessel" then
                    blind.mult = blind.mult * 3
                end
            end
        end
    end

    set_blindref(self, blind, reset, silent)
end

local get_typeref = Blind.get_type
function Blind.get_type(self)
    if self.config.blind.is_definitely_not_boss then
        if self.config.blind.is_definitely_not_boss == "Small Blind" then
            return 'Small'
        elseif self.config.blind.is_definitely_not_boss == "Big Blind" then 
            return 'Big'
        end
    end

    return get_typeref(self)
end

-- joker_randomization
local calculate_jokerref = Card.calculate_joker
function Card.calculate_joker(self, context)
    if self.ability.set == "Joker" and not self.debuff then
        local is_eternal = self.ability.eternal
        if not conf.randomize_eternals and is_eternal then
            return calculate_jokerref(self, context)
        end
        if context.first_hand_drawn then
            if pseudorandom(pseudoseed('joker_randomization'), 1, 100) <= conf.joker_randomization_chance then
                local old_joker = self
                self:remove_from_deck()
                local new_joker = pseudorandom_element(G.P_CENTER_POOLS["Joker"], pseudoseed('joker_select'))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.5,
                    func = function()
                        self:juice_up(0.3, 0.3)
                        self.config.card = {}
                        self:set_ability(new_joker, true)
                        if old_joker.edition then self.edition = old_joker.edition end
                        if is_eternal then
                            sendDebugMessage("eternal") 
                            self:set_eternal(true) 
                        end
                        play_sound('generic1', 1.2, 0.8)
                        self:add_to_deck()
                    return true
                    end
                }))
            end
        end
    end

    return calculate_jokerref(self, context)
end

-- wheel_always_fails / consumable_fail
local use_consumeableref = Card.use_consumeable
function Card.use_consumeable(self, area, copier)
    if (conf.wheel_always_fails and self.ability.name == "The Wheel of Fortune") or
       (pseudorandom(pseudoseed('consumable_fail'), 1, 100) <= conf.consumable_fail_chance) then
        stop_use()
        if not copier then set_consumeable_usage(self) end
        if self.debuff then return nil end
        local used_tarot = copier or self

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            attention_text({
                text = localize('k_nope_ex'),
                scale = 1.3, 
                hold = 1.4,
                major = used_tarot,
                backdrop_colour = G.C.SECONDARY_SET.Tarot,
                align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                silent = true
                })
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                used_tarot:juice_up(0.3, 0.5)
        return true end }))
        delay(0.6)
        return
    end

    use_consumeableref(self, area, copier)
end

-- edition_nerfs
local set_editionref = Card.set_edition
function Card.set_edition(self, edition, immediate, silent)
    set_editionref(self, edition, immediate, silent)
    if not edition or not conf.edition_nerfs then return end
    if edition.negative and self.added_to_deck then
        if self.ability.consumeable then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - 0.01
        else
            G.jokers.config.card_limit = G.jokers.config.card_limit - 0.01
        end
    end
end

local add_to_deckref = Card.add_to_deck
function Card.add_to_deck(self, from_debuff)
    if not self.added_to_deck then
        if self.edition and self.edition.negative and not from_debuff and conf.edition_nerfs then
            if self.ability.consumeable then
                G.consumeables.config.card_limit = G.consumeables.config.card_limit - 0.01
            else
                G.jokers.config.card_limit = G.jokers.config.card_limit - 0.01
            end
        end
    end
    add_to_deckref(self, from_debuff)
end

local remove_from_deckref = Card.remove_from_deck
function Card.remove_from_deck(self, from_debuff)
    if self.added_to_deck then
        if self.edition and self.edition.negative and not from_debuff and G.jokers and conf.edition_nerfs then
            if self.ability.consumeable then
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 0.01
            else
                G.jokers.config.card_limit = G.jokers.config.card_limit + 0.01
            end
        end
    end
    remove_from_deckref(self, from_debuff)
end