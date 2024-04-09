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
    m_rental_increase = "Rental Jokers take $1 more each round",
    m_booster_ante_scaling = "Booster Packs cost $1 more per Ante",
    m_booster_less_choices = "Booster Packs offer 1 less choice",
    m_old_ante_scaling = "1.0.0 Ante scaling",
    m_minus_hand_size_per_X_dollar = "-1 hand size for every $5 you have",
    m_debuff_common = "All Common Jokers are debuffed",
    m_debuff_uncommon = "All Uncommon Jokers are debuffed",
    m_debuff_rare = "All Rare Jokers are debuffed",
    m_set_eternal_ante = "When Ante 4 boss is defeated, all Jokers become Eternal",
    m_set_joker_slots_ante = "When Ante 4 boss is defeated, set Joker slots to 0",
    m_chips_dollar_cap = "Chips cannot exceed the current $",
}

local all_modifiers = {
    -- Basic
    "minus_discard",
    "minus_hand",
    "minus_hand_size",
    "minus_consumable_slot",
    "minus_joker_slot",
    "minus_starting_dollars",
    "increased_blind_size",
    "increased_reroll_cost",
    "minus_shop_card",
    "minus_shop_booster",
    "booster_less_choices", 
    "",

    -- Challenges
    "flipped_cards",
    "no_shop_jokers",
    "no_interest",
    "no_extra_hand_money",
    "debuff_played_cards",
    "inflation",
    "discard_cost",
    "minus_hand_size_per_X_dollar",
    "set_eternal_ante",
    "set_joker_slots_ante",
    "chips_dollar_cap",
    "",

    -- Jokers
    "all_eternal",
    "all_perishable",
    "all_rental",
    "perishable_early",
    "rental_increase",
    "debuff_common",
    "debuff_uncommon",
    "debuff_rare",
    "",
    "",
    "",
    "",

    -- Legacy
    "booster_ante_scaling",
    "old_ante_scaling",
    "",
    "",
    "",
    "",
    "",
    "",
    "", 
    "", 
    "", 
    "", 
}

function SMODS.INIT.HouseRules()
    -- localization
    for k, v in pairs(localization) do
        G.localization.misc.dictionary[k] = v
    end
    init_localization()

    -- default values
    G.HouseRules_modifiers = {}
    for _, v in ipairs(all_modifiers) do 
        if v ~= "" then G.HouseRules_modifiers[v] = false end 
    end

    sendDebugMessage("Loaded HouseRules~")
end

---- HouseRules UI

-- Add "Modifiers" button
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
    if not modifier_name or modifier_name == "" then
        return 
        { n = G.UIT.R, config = {align = "c", minw = 8, padding = 0, colour = G.C.CLEAR}, nodes = {
            {n = G.UIT.C, config = { align = "cr", padding = 0.1 }, nodes = {}},
            {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
                { n = G.UIT.T, config = { text = "", scale = 0.9175, colour = G.C.UI.TEXT_LIGHT, shadow = true }},
            }},
        }}
    end
    return 
    { n = G.UIT.R, config = {align = "c", minw = 8, padding = 0, colour = G.C.CLEAR}, nodes = {
        {n = G.UIT.C, config = { align = "cr", padding = 0.1 }, nodes = {
            create_toggle{ col = true, label = "", w = 0, scale = 0.6, shadow = true, ref_table = G.HouseRules_modifiers, ref_value = modifier_name },
        }},
        {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
            { n = G.UIT.T, config = { text = localize('m_'..modifier_name), scale = 0.3, colour = G.C.UI.TEXT_LIGHT, shadow = true }},
        }},
    }}
end

function create_UIBox_modifiers()
    local page_options = {
        "Basic",
        "Challenges",
        "Jokers",
        "Legacy"
    }

    G.E_MANAGER:add_event(Event({func = (function()
        G.FUNCS.modifiers_change_page{cycle_config = {current_option = 1}}
    return true end)}))

    local t = create_UIBox_generic_options({ back_id = G.STATE == G.STATES.GAME_OVER and 'from_game_over', back_func = 'setup_run', contents = {
        { n = G.UIT.R, config = { align = "cm", padding = 0.1, minh = 9, minw = 4.2 }, nodes = {
            { n = G.UIT.O, config = { id = 'modifiers_list', object = Moveable() }},
        }},
        { n = G.UIT.R, config = { align = "cm" }, nodes = {
            create_option_cycle({options = page_options, w = 4.5, cycle_shoulders = true, opt_callback = 'modifiers_change_page', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
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

G.FUNCS.modifiers_change_page = function(args)
    if not args or not args.cycle_config then return end
    if G.OVERLAY_MENU then
        local m_list = G.OVERLAY_MENU:get_UIE_by_ID('modifiers_list')
        if m_list then
            if m_list.config.object then
                m_list.config.object:remove()
            end
            m_list.config.object = UIBox {
                definition = modifiers_page(args.cycle_config.current_option - 1),
                config = { offset = { x = 0, y = 0 }, align = 'cm', parent = m_list }
            }
        end
    end
end

function modifiers_page(_page)
    local modifiers_list = {}
    for k, v in ipairs(all_modifiers) do
        if k > 12 * (_page or 0) and k <= 12 * ((_page or 0) + 1) then
            modifiers_list[#modifiers_list + 1] = add_modifier_node(v)
        end
    end

    for _ = #modifiers_list+1, 12 do
        modifiers_list[#modifiers_list + 1] = add_modifier_node()
    end
  
    return {n=G.UIT.ROOT, config={align = "c", padding = 0, colour = G.C.CLEAR}, nodes = modifiers_list}
end

---- Apply Modifiers to run
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
    if G.HouseRules_modifiers.flipped_cards then table.insert(args.challenge.rules.custom, {id = 'flipped_cards', value = 4}) end
    if G.HouseRules_modifiers.all_eternal then table.insert(args.challenge.rules.custom, {id = 'all_eternal'}) end
    if G.HouseRules_modifiers.no_interest then table.insert(args.challenge.rules.custom, {id = 'no_interest'}) end
    if G.HouseRules_modifiers.no_extra_hand_money then table.insert(args.challenge.rules.custom, {id = 'no_extra_hand_money'}) end
    if G.HouseRules_modifiers.debuff_played_cards then table.insert(args.challenge.rules.custom, {id = 'debuff_played_cards'}) end
    if G.HouseRules_modifiers.inflation then table.insert(args.challenge.rules.custom, {id = 'inflation'}) end
    if G.HouseRules_modifiers.no_shop_jokers then table.insert(args.challenge.rules.custom, {id = 'no_shop_jokers'}) end
    if G.HouseRules_modifiers.discard_cost then table.insert(args.challenge.rules.custom, {id = 'discard_cost', value = 1}) end
    if G.HouseRules_modifiers.minus_shop_card then table.insert(args.challenge.rules.custom, {id = 'minus_shop_card'}) end
    if G.HouseRules_modifiers.minus_shop_booster then table.insert(args.challenge.rules.custom, {id = 'minus_shop_booster'}) end
    if G.HouseRules_modifiers.all_perishable then table.insert(args.challenge.rules.custom, {id = 'all_perishable'}) end
    if G.HouseRules_modifiers.all_rental then table.insert(args.challenge.rules.custom, {id = 'all_rental'}) end
    if G.HouseRules_modifiers.perishable_early then table.insert(args.challenge.rules.custom, {id = 'perishable_early'}) end
    if G.HouseRules_modifiers.rental_increase then table.insert(args.challenge.rules.custom, {id = 'rental_increase'}) end
    if G.HouseRules_modifiers.booster_ante_scaling then table.insert(args.challenge.rules.custom, {id = 'booster_ante_scaling'}) end
    if G.HouseRules_modifiers.booster_less_choices then table.insert(args.challenge.rules.custom, {id = 'booster_less_choices'}) end
    if G.HouseRules_modifiers.old_ante_scaling then table.insert(args.challenge.rules.custom, {id = 'old_ante_scaling'}) end
    if G.HouseRules_modifiers.minus_hand_size_per_X_dollar then table.insert(args.challenge.rules.custom, {id = 'minus_hand_size_per_X_dollar', value = 5}) end
    if G.HouseRules_modifiers.debuff_common then table.insert(args.challenge.rules.custom, {id = 'debuff_common'}) end
    if G.HouseRules_modifiers.debuff_uncommon then table.insert(args.challenge.rules.custom, {id = 'debuff_uncommon'}) end
    if G.HouseRules_modifiers.debuff_rare then table.insert(args.challenge.rules.custom, {id = 'debuff_rare'}) end
    if G.HouseRules_modifiers.set_eternal_ante then table.insert(args.challenge.rules.custom, {id = 'set_eternal_ante', value = 4}) end
    if G.HouseRules_modifiers.set_joker_slots_ante then table.insert(args.challenge.rules.custom, {id = 'set_joker_slots_ante', value = 4}) end
    if G.HouseRules_modifiers.chips_dollar_cap then table.insert(args.challenge.rules.custom, {id = 'chips_dollar_cap'}) end

    start_runref(self, args)

    if G.HouseRules_modifiers.minus_discard then 
        self.GAME.starting_params.discards = self.GAME.starting_params.discards - 1 
        self.GAME.round_resets.discards = self.GAME.starting_params.discards
        self.GAME.current_round.discards_left = self.GAME.starting_params.discards
    end
    if G.HouseRules_modifiers.minus_hand then 
        self.GAME.starting_params.hands = self.GAME.starting_params.hands - 1 
        self.GAME.round_resets.hands = self.GAME.starting_params.hands
        self.GAME.current_round.hands_left = self.GAME.starting_params.hands
    end
    if G.HouseRules_modifiers.minus_consumable_slot then 
        self.GAME.starting_params.consumable_slots = self.GAME.starting_params.consumable_slots - 1
        G.consumeables.config.card_limit = self.GAME.starting_params.consumable_slots
    end
    if G.HouseRules_modifiers.minus_hand_size then 
        self.GAME.starting_params.hand_size = self.GAME.starting_params.hand_size - 1 
        G.hand.config.card_limit = self.GAME.starting_params.hand_size
    end
    if G.HouseRules_modifiers.minus_joker_slot then 
        self.GAME.starting_params.joker_slots = self.GAME.starting_params.joker_slots - 1
        G.jokers.config.card_limit = self.GAME.starting_params.joker_slots
    end
    if G.HouseRules_modifiers.minus_starting_dollars then 
        self.GAME.starting_params.dollars = self.GAME.starting_params.dollars - 4
        self.GAME.dollars = self.GAME.starting_params.dollars
    end
    if G.HouseRules_modifiers.increased_reroll_cost then 
        self.GAME.starting_params.reroll_cost = self.GAME.starting_params.reroll_cost + 1 
        self.GAME.round_resets.reroll_cost = self.GAME.starting_params.reroll_cost
        self.GAME.base_reroll_cost = self.GAME.starting_params.reroll_cost
        self.GAME.round_resets.reroll_cost = self.GAME.base_reroll_cost
        self.GAME.current_round.reroll_cost = self.GAME.base_reroll_cost
    end
    if G.HouseRules_modifiers.increased_blind_size then
        self.GAME.starting_params.ante_scaling = self.GAME.starting_params.ante_scaling * 2
    end
    if G.HouseRules_modifiers.minus_shop_card then G.GAME.shop.joker_max = G.GAME.shop.joker_max - 1 end
    if G.HouseRules_modifiers.perishable_early then G.GAME.perishable_rounds = G.GAME.perishable_rounds - 2 end
    if G.HouseRules_modifiers.rental_increase then G.GAME.rental_rate = G.GAME.rental_rate + 1 end
end

local shopref = G.UIDEF.shop
function G.UIDEF.shop()
    local t = shopref()
    if G.GAME.modifiers["minus_shop_booster"] then
        if G.HouseRules_modifiers.minus_shop_booster then 
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
    if self.ability.set == "Joker" then
        if G.GAME.modifiers.debuff_common and self.config.center.rarity == 1 or
        G.GAME.modifiers.debuff_uncommon and self.config.center.rarity == 2 or
        G.GAME.modifiers.debuff_rare and self.config.center.rarity == 3 then
            self.ability.perma_debuff = true
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

local get_blind_amountref = get_blind_amount
function get_blind_amount(ante)
    if not G.GAME.modifiers.old_ante_scaling then return get_blind_amountref(ante) end
    local k = 0.75
    local amounts = {}
    if not G.GAME.modifiers.scaling or G.GAME.modifiers.scaling == 1 then
        amounts = { 300, 800, 2800, 6000, 11000, 20000, 35000, 50000 }
    elseif G.GAME.modifiers.scaling == 2 then
        amounts = { 300, 1000, 3200, 9000, 18000, 32000, 56000, 90000 }
    elseif G.GAME.modifiers.scaling == 3 then
        amounts = { 300, 1200, 3600, 10000, 25000, 50000, 90000, 180000 }
    end
    if ante < 1 then return 100 end
    if ante <= 8 then return amounts[ante] end
    local a, b, c, d = amounts[8], 1.6, ante - 8, 1 + 0.2 * (ante - 8)
    local amount = math.floor(a * (b + (k * c) ^ d) ^ c)
    amount = amount - amount % (10 ^ math.floor(math.log10(amount) - 1))
    return amount
end