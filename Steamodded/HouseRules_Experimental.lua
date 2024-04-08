--- STEAMODDED HEADER
--- MOD_NAME: House Rules
--- MOD_ID: HouseRules
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: Adds difficulty modifiers for your runs, stackable with stakes

local localization = {
    b_modifiers_cap = "Modifiers",
    m_minus_discard = "-1 hand",
    m_minus_hand = "-1 discard",
    m_minus_hand_size = "-1 hand size",
    m_minus_consumable_slot = "-1 consumable slot",
    m_minus_joker_slot = "-1 Joker slot",
    m_minus_starting_dollars = "-$4 starting dollars",
    m_increased_blind_size = "X2 base Blind size",
    m_increased_reroll_cost = "+$1 reroll cost",
    m_minus_shop_card = "-1 card slot available in shop",
    m_minus_shop_booster = "-1 Booster Pack available in shop",
    m_flipped_cards = "1 in 4 cards are drawn face down",
    m_all_eternal = "All Jokers are Eternal",
    m_no_interest = "Earn no Interest at end of round",
    m_no_extra_hand_money = "Extra Hands no longer earn money",
    m_debuff_played_cards = "All Played cards become debuffed after scoring",
    m_inflation = "Permanently raise prices by $1 on every purchase",
    m_no_shop_jokers = "Jokers no longer appear in the shop",
    m_discard_cost = "Discards each cost $1",
    m_all_perishable = "All Jokers are Perishable",
    m_all_rental = "All Jokers are Rental",
    m_perishable_early = "Perishable debuffs Jokers 2 rounds earlier",
    m_rental_increase = "Rental loses $1 more each round",
    m_booster_ante_scaling = "Booster Packs cost $1 more per Ante",
    m_booster_less_choices = "Booster Packs offer 1 less choice",
}

function SMODS.INIT.HouseRules()
    -- localization
    for k, v in pairs(localization) do
        G.localization.misc.dictionary[k] = v
    end
    init_localization()

    -- default values
    G.modifiers = {
        minus_discard = false,
        minus_hand = false,
        minus_hand_size = false,
        minus_consumable_slot = false,
        minus_joker_slot = false,
        minus_starting_dollars = false,
        increased_blind_size = false,
        increased_reroll_cost = false,
        minus_shop_card = false,
        minus_shop_booster = false,
        flipped_cards = false,
        all_eternal = false,
        no_interest = false,
        no_extra_hand_money = false,
        debuff_played_cards = false,
        inflation = false,
        no_shop_jokers = false,
        discard_cost = false,
        all_perishable = false,
        all_rental = false,
        perishable_early = false,
        rental_increase = false,
        booster_ante_scaling = false,
        booster_less_choices = false,
    }

    sendDebugMessage("Loaded HouseRules~")
end

local run_setup_optionref = G.UIDEF.run_setup_option
function G.UIDEF.run_setup_option(type)
    local t = run_setup_optionref(type)
    local button = 
    {
        n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
            { n = G.UIT.C, config = { align = "cm", minw = 2.4 }, nodes = {} },
            {
                n = G.UIT.C,
                config = { align = "cm", minw = 2.6, minh = 0.6, padding = 0.2, r = 0.1, hover = true, colour = G.C.RED, button = "modifiers", shadow = true },
                nodes = {
                    {
                        n = G.UIT.R, config = { align = "cm", padding = 0 },
                        nodes = {
                            { n = G.UIT.T, config = { text = localize('b_modifiers_cap'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, func = 'set_button_pip', focus_args = { button = 'x', set_button_pip = true } } }
                        }
                    }
                }
            },
            { n = G.UIT.C, config = { align = "cm", minw = 2.5 }, nodes = {} }
        }
    }
    table.insert(t.nodes, 3, button)
    return t
end

function add_modifier_node(modifier_name)
    return 
    { n = G.UIT.R, config = {align = "c", minw = 8, padding = 0, colour = G.C.GREY}, nodes = {
        {n = G.UIT.C, config = { align = "cr", padding = 0.1 }, nodes = {
            create_toggle{ col = true, label = "", w = 0, scale = 0.6, shadow = true, ref_table = G.modifiers, ref_value = modifier_name },
        }},
        {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
            { n = G.UIT.T, config = { text = localize('m_'..modifier_name), scale = 0.3, colour = G.C.UI.TEXT_LIGHT, shadow = true }},
        }},
    }}
end

function create_UIBox_modifiers()
    local t = create_UIBox_generic_options({ back_id = G.STATE == G.STATES.GAME_OVER and 'from_game_over', back_func = 'setup_run', contents = {
        { n = G.UIT.C, config = { align = "cm", padding = 0 }, nodes = {
            add_modifier_node('minus_hand'),
            add_modifier_node('minus_hand_size'),
            add_modifier_node('minus_joker_slot'),
            add_modifier_node('increased_blind_size'),
            add_modifier_node('minus_shop_card'),
            add_modifier_node('flipped_cards'),
            add_modifier_node('all_perishable'),
            add_modifier_node('no_interest'),
            add_modifier_node('debuff_played_cards'),
            add_modifier_node('no_shop_jokers'),
            add_modifier_node('perishable_early'),
            add_modifier_node('booster_ante_scaling'),
        }},
        { n = G.UIT.C, config = { align = "cm", padding = 0 }, nodes = {
            add_modifier_node('minus_discard'),
            add_modifier_node('minus_consumable_slot'),
            add_modifier_node('minus_starting_dollars'),
            add_modifier_node('increased_reroll_cost'),
            add_modifier_node('minus_shop_booster'),
            add_modifier_node('all_eternal'),
            add_modifier_node('all_rental'),
            add_modifier_node('no_extra_hand_money'),
            add_modifier_node('inflation'),
            add_modifier_node('discard_cost'),
            add_modifier_node('rental_increase'),
            add_modifier_node('booster_less_choices'),
        }},
    }})
    return t
end

G.FUNCS.modifiers = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_modifiers(),
    }
end

-- Apply Modifiers to run
local start_runref = Game.start_run
function Game.start_run(self, args)
    if args.savetext then
        start_runref(self, args)
        return
    end

    args.challenge = args.challenge or {
        rules = {
            custom = {},
            modifiers = {},
        }
    }

    -- hmst
    if G.modifiers.flipped_cards then table.insert(args.challenge.rules.custom, {id = 'flipped_cards', value = 4}) end
    if G.modifiers.all_eternal then table.insert(args.challenge.rules.custom, {id = 'all_eternal'}) end
    if G.modifiers.no_interest then table.insert(args.challenge.rules.custom, {id = 'no_interest'}) end
    if G.modifiers.no_extra_hand_money then table.insert(args.challenge.rules.custom, {id = 'no_extra_hand_money'}) end
    if G.modifiers.debuff_played_cards then table.insert(args.challenge.rules.custom, {id = 'debuff_played_cards'}) end
    if G.modifiers.inflation then table.insert(args.challenge.rules.custom, {id = 'inflation'}) end
    if G.modifiers.no_shop_jokers then table.insert(args.challenge.rules.custom, {id = 'no_shop_jokers'}) end
    if G.modifiers.discard_cost then table.insert(args.challenge.rules.custom, {id = 'discard_cost', value = 1}) end
    if G.modifiers.minus_shop_card then table.insert(args.challenge.rules.custom, {id = 'minus_shop_card'}) end
    if G.modifiers.minus_shop_booster then table.insert(args.challenge.rules.custom, {id = 'minus_shop_booster'}) end
    if G.modifiers.all_perishable then table.insert(args.challenge.rules.custom, {id = 'all_perishable'}) end
    if G.modifiers.all_rental then table.insert(args.challenge.rules.custom, {id = 'all_rental'}) end
    if G.modifiers.perishable_early then table.insert(args.challenge.rules.custom, {id = 'perishable_early'}) end
    if G.modifiers.rental_increase then table.insert(args.challenge.rules.custom, {id = 'rental_increase'}) end
    if G.modifiers.booster_ante_scaling then table.insert(args.challenge.rules.custom, {id = 'booster_ante_scaling'}) end
    if G.modifiers.booster_less_choices then table.insert(args.challenge.rules.custom, {id = 'booster_less_choices'}) end

    start_runref(self, args)

    if G.modifiers.minus_discard then 
        self.GAME.starting_params.discards = self.GAME.starting_params.discards - 1 
        self.GAME.round_resets.discards = self.GAME.starting_params.discards
        self.GAME.current_round.discards_left = self.GAME.starting_params.discards
    end
    if G.modifiers.minus_hand then 
        self.GAME.starting_params.hands = self.GAME.starting_params.hands - 1 
        self.GAME.round_resets.hands = self.GAME.starting_params.hands
        self.GAME.current_round.hands_left = self.GAME.starting_params.hands
    end
    if G.modifiers.minus_consumable_slot then 
        self.GAME.starting_params.consumable_slots = self.GAME.starting_params.consumable_slots - 1
        G.consumeables.config.card_limit = self.GAME.starting_params.consumable_slots
    end
    if G.modifiers.minus_hand_size then 
        self.GAME.starting_params.hand_size = self.GAME.starting_params.hand_size - 1 
        G.hand.config.card_limit = self.GAME.starting_params.hand_size
    end
    if G.modifiers.minus_joker_slot then 
        self.GAME.starting_params.joker_slots = self.GAME.starting_params.joker_slots - 1
        G.jokers.config.card_limit = self.GAME.starting_params.joker_slots
    end
    if G.modifiers.minus_starting_dollars then 
        self.GAME.starting_params.dollars = self.GAME.starting_params.dollars - 4
        self.GAME.dollars = self.GAME.starting_params.dollars
    end
    if G.modifiers.increased_reroll_cost then 
        self.GAME.starting_params.reroll_cost = self.GAME.starting_params.reroll_cost + 1 
        self.GAME.round_resets.reroll_cost = self.GAME.starting_params.reroll_cost
        self.GAME.base_reroll_cost = self.GAME.starting_params.reroll_cost
        self.GAME.round_resets.reroll_cost = self.GAME.base_reroll_cost
        self.GAME.current_round.reroll_cost = self.GAME.base_reroll_cost
    end
    if G.modifiers.increased_blind_size then
        self.GAME.starting_params.ante_scaling = self.GAME.starting_params.ante_scaling * 2
    end
    if G.modifiers.minus_shop_card then G.GAME.shop.joker_max = G.GAME.shop.joker_max - 1 end
    if G.modifiers.perishable_early then G.GAME.perishable_rounds = G.GAME.perishable_rounds - 2 end
    if G.modifiers.rental_increase then G.GAME.rental_rate = G.GAME.rental_rate + 1 end
end

local shopref = G.UIDEF.shop
function G.UIDEF.shop()
    local t = shopref()
    if G.GAME.modifiers["minus_shop_booster"] then
        if G.modifiers.minus_shop_booster then 
            G.shop_booster.config.card_limit = G.shop_booster.config.card_limit - 1
            t.nodes[1].nodes[1].nodes[1].nodes[1].nodes[3].nodes[2].nodes[1].config = { object = G.shop_booster }
        end
    end
    return t
end

-- this will destroy every booster generated over the limit every frame. will not fix
local update_shopref = Game.update_shop
function Game.update_shop(self, dt)
    update_shopref(self, dt)
    if G.GAME.modifiers["minus_shop_booster"] then
        if #G.shop_booster.cards > G.shop_booster.config.card_limit then
            G.shop_booster.cards[#G.shop_booster.cards]:remove()
        end
    end
end

local create_cardref = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    local card = create_cardref(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if _type == "Joker" then
        if G.GAME.modifiers.all_perishable then
            card:set_perishable(true)
        end
        if G.GAME.modifiers.all_rental then
            card:set_rental(true)
        end
    end
    return card
end

local set_perishableref = Card.set_perishable
function Card.set_perishable(self)
    set_perishableref(self)
    if G.GAME.modifiers.all_perishable then
        self.ability.perishable = true
        self.ability.perish_tally = G.GAME.perishable_rounds
    end
end

local set_abilityref = Card.set_ability
function Card.set_ability(self, center, initial, delay_sprites)
    set_abilityref(self, center, initial, delay_sprites)
    if G.GAME.modifiers.booster_less_choices then
        if self.ability.set == "Booster" then
            self.ability.extra = self.ability.extra - 1
        end
    end
end

local generate_card_uiref = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end)
    if G.GAME.modifiers.booster_less_choices then
        if _c.set == "Booster" then
            _c.config.extra = _c.config.extra - 1
        end
    end
    local obj = generate_card_uiref(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end)
    if G.GAME.modifiers.booster_less_choices then
        if _c.set == "Booster" then
            _c.config.extra = _c.config.extra + 1
        end
    end
    return obj
end