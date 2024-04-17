--- STEAMODDED HEADER
--- MOD_NAME: Myst's Jokers
--- MOD_ID: MystJokers
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: A pack of Jokers
--- DISPLAY_NAME: MystJokers
--- BADGE_COLOUR: EDA9D3

-- Blacklist individual Jokers here
local jokerBlacklists = {
    polydactyly = false,
    miracle_milk = false,
    yield_flesh = false,
    autism_creature = false,
    r_key = false,
    lucky_seven = false,
    options = false,
    jimpostor = false, -- Suspicious Joker
    credits = false,
    exploding_fruitcake = false, -- will also disable bobm
    rdcards = false, -- Collectible Card
}

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
            "{C:attention}Undebuff{} all scored cards",
            "This Joker gains {C:chips}+8{} Chips per",
            "{C:attention}undebuffed{} card",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },
    yield_flesh = {
        name = "Yield My Flesh",
        text = {
            "{X:mult,C:white} X3 {} Mult after first played",
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
            "Sell this Joker to",
            "reduce Ante by {C:attention}2{},",
            "down to minimum Ante {C:attention}1{}",
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
    },
    options = {
        name = "Options",
        text = {
            "After playing a hand,",
            "draw {C:attention}two{} extra cards"
        }
    },
    jimpostor = {
        name = "Suspicious Joker",
        text = {
            "Downgrade played hand",
            "to gain {X:mult,C:white} X0.25 {} Mult",
            "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)"
        }
    },
    credits = {
        name = "Credits",
        text = {
            "After discarding,",
            "draw {C:attention}two{} extra cards"
        }
    },
    exploding_fruitcake = {
        name = "Exploding Fruitcake",
        text = {
            "When {C:attention}Small Blind{} begins, give",
            "a random {C:dark_edition}Edition{} to all",
            "Jokers and consumables, then",
            "replace this with a {C:attention}bobm{}"
        }
    },
    bobm = {
        name = "bobm",
        text = {
            "{C:dark_edition}Negative, Eternal{}",
            "Lose the game",
            "after {C:attention}300{} seconds",
            "{C:inactive}(Time left: #1#s)"
        }
    },
    rdcards = {
        name = "Collectible Card",
        text = {
            "Each scored card with same",
            "{C:attention}rank{} as {C:attention}first{} scored card",
            "gives {C:chips}+5{} Chips to all cards",
            "in {C:attention}full deck{} of that rank",
        }
    }
}

function SMODS.INIT.MystJokers()
    local jokers = {
        {
            name = "Polydactyly", slug = "polydactyly",
            config = {}, rarity = 2, cost = 6, 
            blueprint_compat = false, 
            eternal_compat = true
        },
        {
            name = "Miracle Milk", slug = "miracle_milk",
            config = {extra = 8}, rarity = 1, cost = 4, 
            blueprint_compat = true, 
            eternal_compat = true
        },
        {
            name = "Yield My Flesh", slug = "yield_flesh",
            config = {extra = { Xmult = 3, active = false }},
            rarity = 2, cost = 7, 
            blueprint_compat = true, 
            eternal_compat = true
        },
        {
            name = "R Key", slug = "r_key",
            config = {}, rarity = 3, cost = 40, 
            blueprint_compat = false, 
            eternal_compat = false
        },
        {
            name = "Lucky Seven", slug = "lucky_seven",
            config = {}, rarity = 1, cost = 3, 
            blueprint_compat = true, 
            eternal_compat = true
        },
        {
            name = "Options", slug = "options",
            config = {extra = 1}, rarity = 2, cost = 5, 
            blueprint_compat = false, 
            eternal_compat = true
        },
        {
            name = "Credits", slug = "credits",
            config = {extra = 1}, rarity = 2, cost = 5, 
            blueprint_compat = false, 
            eternal_compat = true
        },
        {
            name = "Autism Creature", slug = "autism_creature",
            config = {extra = 0}, rarity = 1, cost = 4, 
            blueprint_compat = true, 
            eternal_compat = true
        },
        {
            name = "Suspicious Joker", slug = "jimpostor",
            config = {}, rarity = 2, cost = 7, 
            blueprint_compat = true, 
            eternal_compat = true
        },
        {
            name = "Exploding Fruitcake", slug = "exploding_fruitcake",
            config = {}, rarity = 3, cost = 7, 
            blueprint_compat = true, -- yes this is literally just bait you get two bobms
            eternal_compat = false
        },
        {
            name = "bobm", slug = "bobm",
            config = { extra = 300 }, rarity = 1, cost = -4, 
            blueprint_compat = false, 
            eternal_compat = true
        },
        {
            name = "Collectible Card", slug = "rdcards",
            config = {}, rarity = 3, cost = 8,
            blueprint_compat = true,
            eternal_compat = true
        },
    }

    -- Localization
    G.localization.misc.dictionary.k_cleansed = "Cleansed!"
    G.localization.misc.dictionary.k_wheel = "Wheel!"
    G.localization.descriptions.Joker.j_bobm_tooltip = {
        name = "bobm",
        text = {
            "{C:dark_edition}Negative, Eternal{}",
            "Lose the game",
            "after {C:attention}300{} seconds",
            "{C:inactive}(Time left: 300s)"
        }
    }
    init_localization()

    -- Add Jokers to center
    for _, v in ipairs(jokers) do
        if not jokerBlacklists[v.slug] then
            SMODS.Joker:new(v.name, 'myst_'..v.slug, v.config, {x = 0, y = 0}, localization[v.slug], v.rarity, v.cost, true, true, v.blueprint_compat, v.eternal_compat, "", "j_"..v.slug):register()
            SMODS.Sprite:new('j_'..v.slug, SMODS.findModByID("MystJokers").path, "j_"..v.slug..".png", 71, 95, "asset_atli"):register()
        end
    end

    --- Lame joker abilities ---
    -- Miracle Milk
    if not jokerBlacklists.miracle_milk then
        SMODS.Jokers.j_myst_miracle_milk.calculate = function(self, context)
            if context.cardarea == G.jokers and context.before and context.scoring_hand and not context.blueprint then
                local cleanses = 0
                for _, v in ipairs(context.scoring_hand) do
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
                end

                if cleanses > 0 then
                    self.ability.extra = self.ability.extra + 8 * cleanses
                    return {
                        message = localize('k_cleansed'),
                        colour = G.C.JOKER_GREY,
                        card = self
                    }
                end
            end

            if SMODS.end_calculate_context(context) then
                return {
                    message = localize{type='variable',key='a_chips',vars={self.ability.extra}},
                    chip_mod = self.ability.extra, 
                    colour = G.C.CHIPS
                }
            end
        end

        SMODS.Jokers.j_myst_miracle_milk.loc_def = function(self)
            return { self.ability.extra }
        end
    end

    -- Yield My Flesh
    if not jokerBlacklists.yield_flesh then 
        SMODS.Jokers.j_myst_yield_flesh.calculate = function(self, context)
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
    end

    -- Autism Creature
    if not jokerBlacklists.autism_creature then
        SMODS.Jokers.j_myst_autism_creature.calculate = function(self, context)
            if SMODS.end_calculate_context(context) then
                if self.ability.extra > 0 then
                    return {
                        message = localize { type = 'variable', key = 'a_mult', vars = { self.ability.extra } },
                        mult_mod = self.ability.extra,
                    }
                end
            end
        end

        SMODS.Jokers.j_myst_autism_creature.loc_def = function(self)
            return { self.ability.extra }
        end
    end

    -- R Key
    if not jokerBlacklists.r_key then
        SMODS.Jokers.j_myst_r_key.set_ability = function(self, center, initial, delay_sprites)
            self.sell_cost = 0
        end

        SMODS.Jokers.j_myst_r_key.calculate = function(self, context)
            if context.selling_self then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        for _ = 1, 2 do
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
    if not jokerBlacklists.lucky_seven then
        SMODS.Jokers.j_myst_lucky_seven.calculate = function(self, context)
            if context.setting_blind and not self.getting_sliced then
                local can_trigger = false
                for _, v in pairs(G.jokers.cards) do
                    if v.ability.set == "Joker" and not v.edition then
                        can_trigger = true
                    end
                end

                if can_trigger then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()
                            local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W/2, G.play.T.y + G.play.T.h/2-G.CARD_H/2, G.CARD_W, G.CARD_H, 
                            G.P_CARDS.empty, G.P_CENTERS["c_wheel_of_fortune"], {bypass_discovery_center = true, bypass_discovery_ui = true})
                            card.cost = 0
                            card:update()
                            G.FUNCS.use_card({config = {ref_table = card}})
                            card:start_materialize()

                            ease_dollars(-3)
                        return true
                        end
                    }))
                end
            end
        end

        SMODS.Jokers.j_myst_lucky_seven.tooltip = function(self, info_queue)
            info_queue[#info_queue+1] = G.P_CENTERS.c_wheel_of_fortune
        end
    end

    -- Options
    if not jokerBlacklists.options then
        SMODS.Jokers.j_myst_options.set_ability = function(self, center, initial, delay_sprites)
            self.ability.extra = G.GAME.current_round.hands_played + 1
        end

        SMODS.Jokers.j_myst_options.calculate = function(self, context)
            if context.setting_blind and not self.getting_sliced and not context.blueprint then
                self.ability.extra = 1
            end
        end
    end

    -- Suspicious Joker sussy baka
    if not jokerBlacklists.jimpostor then
        SMODS.Jokers.j_myst_jimpostor.calculate = function(self, context)
            if context.cardarea == G.jokers and context.before and not context.blueprint then
                if G.GAME.hands[context.scoring_name].level <= 1 then
                    return
                end
                level_up_hand(context.blueprint_card or self, context.scoring_name, nil, -1)
                self.ability.x_mult = self.ability.x_mult + 0.25
                card_eval_status_text((context.blueprint_card or self), 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult}}})
            end
        end

        SMODS.Jokers.j_myst_jimpostor.loc_def = function(self)
            return { self.ability.x_mult }
        end
    end

    -- Credits
    if not jokerBlacklists.credits then
        SMODS.Jokers.j_myst_credits.set_ability = function(self, center, initial, delay_sprites)
            self.ability.extra = G.GAME.current_round.discards_used + 1
        end

        SMODS.Jokers.j_myst_credits.calculate = function(self, context)
            if context.setting_blind and not self.getting_sliced and not context.blueprint then
                self.ability.extra = 1
            end
        end
    end

    -- Exploding Fruitcake
    if not jokerBlacklists.exploding_fruitcake then
        SMODS.Jokers.j_myst_exploding_fruitcake.calculate = function(self, context)
            if context.first_hand_drawn then
                if G.GAME.blind and G.GAME.blind:get_type() == 'Small' then
                    -- Editions
                    for _, v in ipairs(G.jokers.cards) do
                        if v ~= self and not v.edition then
                            local edition = poll_edition('exploding_fruitcake_jokers', nil, false, true)
                            v:set_edition(edition)
                        end
                    end

                    for _, v in ipairs(G.consumeables.cards) do
                        if not v.edition then
                            local edition = poll_edition('exploding_fruitcake_consumeables', nil, false, true)
                            v:set_edition(edition)
                        end
                    end

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()    
                            self:flip()
                            self:set_ability(G.P_CENTERS['j_bobm'], false, true)
                            play_sound('card1', 1.1)
                            return true
                        end
                    }))

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()
                            delay(1.2)  
                            self:flip()
                            return true
                        end
                    }))
                end
            end
        end

        SMODS.Jokers.j_myst_exploding_fruitcake.tooltip = function(self, info_queue)
            info_queue[#info_queue+1] = {key = 'j_bobm_tooltip', set = 'Joker', vars = {300}}
        end

        SMODS.Jokers.j_myst_exploding_fruitcake.loc_def = function(self)
            return {}
        end

        -- bobm
        -- remove bobm from pools
        SMODS.Jokers.j_myst_bobm.yes_pool_flag = "this_flag_will_never_be_added_to_pools"

        SMODS.Jokers.j_myst_bobm.set_ability = function(self, center, initial, delay_sprites)
            self:set_edition({negative = true})
            self.ability.eternal = true
        end
        
        SMODS.Jokers.j_myst_bobm.loc_def = function(self)
            if not self.ability.extra then return { 300 } end
            return { math.floor(self.ability.extra) }
        end
    end

    -- Collectible Card
    if not jokerBlacklists.rdcards then
        SMODS.Jokers.j_myst_rdcards.set_ability = function(self, center, initial, delay_sprites)
            self.T.h = self.T.h / 1.33333
        end

        SMODS.Jokers.j_myst_rdcards.calculate = function(self, context)
            if context.individual and context.cardarea == G.play then
                local id = context.scoring_hand[1]:get_id()
                    if context.other_card:get_id() == id then
                    for _, v in ipairs(G.playing_cards) do
                        if v:get_id() == id then
                            v.ability.perma_bonus = v.ability.perma_bonus or 0
                            v.ability.perma_bonus = v.ability.perma_bonus + 5
                        end
                    end

                    return {
                        extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
                        colour = G.C.CHIPS,
                        card = self
                    }
                end
            end
        end
    end
    
    sendDebugMessage("Loaded MystJokers~")
end

--- the good shit ---
-- Game variables
local init_game_objectref = Game.init_game_object
function Game.init_game_object(self)
    local t = init_game_objectref(self)

    return t
end

-- Card updates
local card_updateref = Card.update
function Card.update(self, dt)
    if G.STAGE == G.STAGES.RUN then
        if self.config.center.key == "j_myst_autism_creature" then
            self.ability.extra = (G.jokers.config.card_limit - #G.jokers.cards) * 6
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == 'Joker Stencil' then self.ability.extra = self.ability.extra + 6 end
            end
        end
        if self.config.center.key == "j_myst_bobm" and not self.debuff then
            self.ability.extra = self.ability.extra - (dt / G.SETTINGS.GAMESPEED)
            if self.ability.extra <= 0 and G.STATE ~= G.STATES.GAME_OVER then
                G.STATE = G.STATES.GAME_OVER
                if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
                    G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                end
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
            end
        end
    end
    card_updateref(self, dt)
end

-- Set sprites
local card_set_spritesref = Card.set_sprites
function Card.set_sprites(self, _center, _front)
    card_set_spritesref(self, _center, _front)
    if _center and _center.set then
        if _center.key == 'j_myst_rdcards' and (_center.discovered or self.bypass_discovery_center) then 
            self.children.center.scale.y = self.children.center.scale.y/1.33333
        end
    end
end

-- Load sprites
local card_loadref = Card.load
function Card.load(self, cardTable, other_card)
    card_loadref(self, cardTable, other_card)

    local scale = 1
    local H = G.CARD_H
    local W = G.CARD_W

    if self.config.center.key == "j_myst_rdcards" then 
        self.T.h = H*scale/1.33333*scale
        self.T.w = W*scale
    end
end

-- Polydactyly
local openref = Card.open
function Card.open(self)
    local temp = 0
    local extra_pulls = 0
    if self.ability.set == "Booster" then
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == "j_myst_polydactyly" and not v.debuff then
                extra_pulls = extra_pulls + 1
            end
        end
        self.config.center.config.choose = self.config.center.config.choose or 1
        temp = self.config.center.config.choose
        self.config.center.config.choose = math.min(self.config.center.config.choose + extra_pulls,
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

-- Options / Credits
local draw_from_deck_to_handref = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS.draw_from_deck_to_hand(self, e)
    draw_from_deck_to_handref(self, e)

    for _, v in ipairs(G.jokers.cards) do
        if G.STATE == G.STATES.DRAW_TO_HAND then
            if v.config.center.key == "j_myst_options" and G.GAME.current_round.hands_played == v.ability.extra or 
            v.config.center.key == "j_myst_credits" and G.GAME.current_round.discards_used == v.ability.extra and not v.debuff then
                for i = 1, 2 do draw_card(G.deck, G.hand, i*100/2, 'up', true) end
                v.ability.extra = v.ability.extra + 1
            end
        end
    end
end

-- R Key
local set_costref = Card.set_cost
function Card.set_cost(self)
    set_costref(self)
    if self.config.center.key == "j_myst_r_key" then
        self.sell_cost = 0
    end
end