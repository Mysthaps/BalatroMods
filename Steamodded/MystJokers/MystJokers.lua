--- STEAMODDED HEADER
--- MOD_NAME: Myst's Jokers
--- MOD_ID: MystJokers
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: A pack of Jokers

----------------------------------------------
------------MOD CODE -------------------------

local localization = {
    polydactyly = {
        name = "Polydactyly",
        text = {
            "Choose an extra card",
            "from {C:attention}Booster Packs{}",
        }
    },
    miracle_milk = {
        name = "Miracle Milk",
        text = {
            "{C:attention}Debuffed{} cards count",
            "for scoring"
        }
    },
    yield_flesh = {
        name = "Yield My Flesh",
        text = {
            "{X:mult,C:white} X2.5 {} Mult after first played",
            "hand scores less than",
            "{C:attention}5%{} of required chips"
        }
    },
    autism_creature = {
        name = "Autism Creature",
        text = {
            "{C:mult}+6{} Mult for each",
            "empty {C:attention}Joker{} slot",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },
    r_key = {
        name = "R Key",
        text = {
            "Sell this Joker to reduce Ante",
            "by {C:attention}3{}, down to minimum Ante {C:attention}1{}",
            "All future {C:attention}R Keys{}",
            "will not work once sold"
        }
    },
    lucky_seven = {
        name = "Lucky Seven",
        text = {
            "When {C:attention}Blind{} is selected,",
            "lose {C:money}$3{} and use",
            "{C:attention}The Wheel of Fortune{}",
            "{s:0.8}(if possible){}",
        }
    }
}

--[[SMODS.Joker:new(
    name, slug,
    config,
    spritePos, loc_txt,
    rarity, cost, unlocked, discovered, blueprint_compat, eternal_compat
)
]]
local jokers = {
    polydactyly = SMODS.Joker:new(
        "Polydactyly", "",
        {},
        {}, "",
        2, 6, true, true, false, true
    ),
    miracle_milk = SMODS.Joker:new(
        "Miracle Milk", "",
        {},
        {}, "",
        1, 5, true, true, false, true
    ),
    yield_flesh = SMODS.Joker:new(
        "Yield My Flesh", "",
        { extra = { Xmult = 2.5, active = false } },
        {}, "",
        2, 7, true, true, true, true
    ),
    autism_creature = SMODS.Joker:new(
        "Autism Creature", "",
        { extra = 0 },
        {}, "",
        1, 5, true, true, true, true
    ),
    r_key = SMODS.Joker:new(
        "R Key", "",
        {},
        {}, "",
        3, 15, true, true, false, false
    ),
    lucky_seven = SMODS.Joker:new(
        "Lucky Seven", "",
        {},
        {}, "",
        1, 4, true, true, false, true
    )
}

-- Blacklist individual Jokers here
local jokerBlacklists = {
    polydactyly = false,
    miracle_milk = false,
    yield_flesh = false,
    autism_creature = false,
    r_key = false,
    lucky_seven = false
}

function SMODS.INIT.MystJokers()
    sendDebugMessage("Loaded MystJokers~")

    -- Localization
    G.localization.misc.dictionary.k_cleansed = "Cleansed!"
    G.localization.misc.dictionary.k_wheel = "Wheel!"
    G.localization.descriptions.Joker.j_claim_bones = {
        name = "To Claim Their Bones",
        text = {
            "{X:mult,C:white} X2.5 {} Mult after first played",
            "hand scores less than",
            "{C:attention}5%{} of required chips"
        }
    }
    init_localization()

    -- Add Jokers to center
    for k, v in pairs(jokers) do
        if not jokerBlacklists[k] then
            v.slug = "j_" .. k
            v.loc_txt = localization[k]
            v.spritePos = { x = 0, y = 0 }
            v:register()
            SMODS.Sprite:new(v.slug, SMODS.findModByID("MystJokers").path, v.slug..".png", 71, 95, "asset_atli"):register()
        end
    end

    --- Lame joker abilities ---
    -- Miracle Milk
    SMODS.Jokers.j_miracle_milk.calculate = function(self, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            for _, v in ipairs(context.full_hand) do
                local cleanses = 0
                if v.debuff then
                    cleanses = cleanses + 1
                    v.debuff = false
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    }))
                end

                if cleanses > 0 then
                    return {
                        message = localize('k_cleansed'),
                        colour = G.C.JOKER_GREY,
                        card = self
                    }
                end
            end
        end
    end

    -- Yield My Flesh
    SMODS.Jokers.j_yield_flesh.calculate = function(self, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.hands_played == 0 end
            juice_card_until(self, eval, true)
        end

        if context.scored_chips and context.after and not context.blueprint then
            if G.GAME.current_round.hands_played == 0 and context.scored_chips / G.GAME.blind.chips <= 0.05 then
                self.ability.extra.active = true
                return {
                    message = localize('k_active_ex'),
                    colour = G.C.FILTER
                }
            end
        end

        if context.end_of_round and not context.blueprint then
            self.ability.extra.active = false
        end

        if SMODS.end_calculate_context(context) then
            if self.ability.extra.active then
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.extra.Xmult } },
                    Xmult_mod = self.ability.extra.Xmult,
                }
            end
        end
    end

    -- Autism Creature
    SMODS.Jokers.j_autism_creature.calculate = function(self, context)
        if SMODS.end_calculate_context(context) then
            if self.ability.extra > 0 then
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = { self.ability.extra } },
                    mult_mod = self.ability.extra,
                }
            end
        end
    end

    -- R Key
    SMODS.Jokers.j_r_key.effect = function(self, context)
        self.ability.extra_cost = (self.ability.extra_cost or 0) + 84
    end

    SMODS.Jokers.j_r_key.calculate = function(self, context)
        if context.selling_self then
            if G.GAME.used_rkey then
                self:set_debuff(true)
            else
                G.GAME.used_rkey = true

                G.E_MANAGER:add_event(Event({
                    func = (function()
                        for _ = 1, 3 do
                            if G.GAME.round_resets.blind_ante <= 1 or G.GAME.round_resets.ante <= 1 then break end

                            ease_ante(-1)
                            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - 1
                            delay(0.2)
                        end
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        return true
                    end)
                }))
            end
        end
    end

    -- Lucky Seven
    SMODS.Jokers.j_lucky_seven.calculate = function(self, context)
        if context.setting_blind and not self.getting_sliced and not context.blueprint then
            local can_trigger = false
            for _, v in pairs(G.jokers.cards) do
                if v.ability.set == "Joker" and not v.edition then
                    can_trigger = true
                end
            end

            if can_trigger then
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W/2, G.play.T.y + G.play.T.h/2-G.CARD_H/2, G.CARD_W, G.CARD_H, 
                G.P_CARDS.empty, G.P_CENTERS["c_wheel_of_fortune"], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                card:update()
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()

                ease_dollars(-3)
            end
        end
    end
end

--- the good shit ---

-- Init variables
local init_game_objectobjref = Game.init_game_object
function Game.init_game_object(self)
    local gameObj = init_game_objectobjref(self)

    gameObj.extra_gacha_pulls = 0
    gameObj.used_rkey = false

    return gameObj
end

-- UIBox garbage / Copied from LushMod. Thanks luscious!
local generate_UIBox_ability_tableref = Card.generate_UIBox_ability_table
function Card.generate_UIBox_ability_table(self)
    local card_type, hide_desc = self.ability.set or "None", nil
    local loc_vars = nil
    local main_start, main_end = nil, nil
    local no_badge = nil

    if self.config.center.unlocked == false and not self.bypass_lock then    -- For everyting that is locked
    elseif card_type == 'Undiscovered' and not self.bypass_discovery_ui then -- Any Joker or tarot/planet/voucher that is not yet discovered
    elseif self.debuff then
    elseif card_type == 'Default' or card_type == 'Enhanced' then
    elseif self.ability.set == 'Joker' then
        local customJoker = false

        if self.ability.name == 'Polydactyly' then
            customJoker = true
        elseif self.ability.name == 'Miracle Milk' then
            customJoker = true
        elseif self.ability.name == 'Yield My Flesh' then
            customJoker = true
        elseif self.ability.name == 'Autism Creature' then
            loc_vars = { self.ability.extra }
            customJoker = true
        end

        if customJoker then
            local badges = {}
            if (card_type ~= 'Locked' and card_type ~= 'Undiscovered' and card_type ~= 'Default') or self.debuff then
                badges.card_type = card_type
            end
            if self.ability.set == 'Joker' and self.bypass_discovery_ui and (not no_badge) then
                badges.force_rarity = true
            end
            if self.edition then
                if self.edition.type == 'negative' and self.ability.consumeable then
                    badges[#badges + 1] = 'negative_consumable'
                else
                    badges[#badges + 1] = (self.edition.type == 'holo' and 'holographic' or self.edition.type)
                end
            end
            if self.seal then
                badges[#badges + 1] = string.lower(self.seal) .. '_seal'
            end
            if self.ability.eternal then
                badges[#badges + 1] = 'eternal'
            end
            if self.pinned then
                badges[#badges + 1] = 'pinned_left'
            end

            if self.sticker then
                loc_vars = loc_vars or {};
                loc_vars.sticker = self.sticker
            end

            local center = self.config.center
            if self.ability.name == "Yield My Flesh" or self.ability.name == "To Claim Their Bones" then
                center.key = self.ability.extra.active and 'j_claim_bones' or 'j_yield_flesh'
                sendDebugMessage("pong")
            end
            return generate_card_ui(center, nil, loc_vars, card_type, badges, hide_desc, main_start, main_end)
        end
    end
    return generate_UIBox_ability_tableref(self)
end

-- Card updates
local card_updateref = Card.update
function Card.update(self, dt)
    if G.STAGE == G.STAGES.RUN then
        if self.ability.name == "Autism Creature" then
            self.ability.extra = (G.jokers.config.card_limit - #G.jokers.cards) * 6
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == 'Joker Stencil' then self.ability.extra = self.ability.extra + 6 end
            end
        end
    end
    card_updateref(self, dt)
end

-- Polydactyly
local add_to_deckref = Card.add_to_deck
function Card.add_to_deck(self, from_debuff)
    if not self.added_to_deck then
        if self.ability.name == "Polydactyly" then
            G.GAME.extra_gacha_pulls = (G.GAME.extra_gacha_pulls or 0)
            G.GAME.extra_gacha_pulls = G.GAME.extra_gacha_pulls + 1
        end
    end
    add_to_deckref(self, from_debuff)
end

local remove_from_deckref = Card.remove_from_deck
function Card.remove_from_deck(self, from_debuff)
    if self.added_to_deck then
        if self.ability.name == "Polydactyly" then
            G.GAME.extra_gacha_pulls = (G.GAME.extra_gacha_pulls or 0)
            G.GAME.extra_gacha_pulls = G.GAME.extra_gacha_pulls - 1
        end
    end
    remove_from_deckref(self, from_debuff)
end

local openref = Card.open
function Card.open(self)
    local temp = 0
    if self.ability.set == "Booster" then
        self.config.center.config.choose = self.config.center.config.choose or 1
        temp = self.config.center.config.choose
        self.config.center.config.choose = math.min(self.config.center.config.choose + G.GAME.extra_gacha_pulls,
            self.ability.extra)
    end
    openref(self)
    if self.ability.set == "Booster" then
        self.config.center.config.choose = temp
    end
end

-- Yield My Flesh
local evaluate_playref = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(self, e)
    evaluate_playref(self, e)

    for i = 1, #G.jokers.cards do
        local effects = eval_card(G.jokers.cards[i],
            { card = G.consumeables, after = true, scored_chips = hand_chips * mult })
        if effects.jokers then
            card_eval_status_text(G.jokers.cards[i], 'jokers', nil, 0.3, nil, effects.jokers)
        end
    end
end

----------------------------------------------
------------MOD CODE END----------------------
