--- STEAMODDED HEADER
--- MOD_NAME: House Rules
--- MOD_ID: HouseRules
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: Adds difficulty modifiers for your runs, stackable with stakes

-- default values

local localization = {
    b_modifiers_cap = "Modifiers",
    m_minus_discard = "-1 hand",
    m_minus_hand = "-1 discard",
    m_minus_hand_size = "-1 hand size",
    m_minus_consumable_slot = "-1 consumable slot",
    m_minus_joker_slot = "-1 Joker slot",
    m_minus_starting_dollars = "-4 starting dollars",
    m_increased_blind_size = "X2 base Blind size",
    m_increased_reroll_cost = "+1 reroll cost",
    m_flipped_cards = "1 in 4 cards are drawn face down",
    m_all_eternal = "All Jokers are Eternal",
    m_no_interest = "Earn no Interest at end of round",
    m_no_extra_hand_money = "Extra Hands no longer earn money",
    m_debuff_played_cards = "All Played cards become debuffed after scoring",
    m_inflation = "Permanently raise prices by $1 on every purchase",
    m_no_shop_jokers = "Jokers no longer appear in the shop",
    m_discard_cost = "Discards each cost $1"
}

function SMODS.INIT.HouseRules()
    for k, v in pairs(localization) do
        G.localization.misc.dictionary[k] = v
    end

    G.modifiers = {
        minus_discard = false,
        minus_hand = false,
        minus_hand_size = false,
        minus_consumable_slot = false,
        minus_joker_slot = false,
        minus_starting_dollars = false,
        increased_blind_size = false,
        increased_reroll_cost = false,
        flipped_cards = false,
        all_eternal = false,
        no_interest = false,
        no_extra_hand_money = false,
        debuff_played_cards = false,
        inflation = false,
        no_shop_jokers = false,
        discard_cost = false,
    }
    init_localization()

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
                config = type == "Continue" and 
                { align = "cm", minw = 2.6, minh = 0.6, padding = 0.2, r = 0.1, hover = true, colour = G.C.UI.BACKGROUND_INACTIVE, shadow = true} or--, button = "start_setup_run", shadow = true, func = 'can_start_run' },
                { align = "cm", minw = 2.6, minh = 0.6, padding = 0.2, r = 0.1, hover = true, colour = G.C.RED, button = "modifiers", shadow = true },
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
            add_modifier_node('flipped_cards'),
            add_modifier_node('no_interest'),
            add_modifier_node('debuff_played_cards'),
            add_modifier_node('no_shop_jokers'),
        }},
        { n = G.UIT.C, config = { align = "cm", padding = 0 }, nodes = {
            add_modifier_node('minus_discard'),
            add_modifier_node('minus_consumable_slot'),
            add_modifier_node('minus_starting_dollars'),
            add_modifier_node('increased_reroll_cost'),
            add_modifier_node('all_eternal'),
            add_modifier_node('no_extra_hand_money'),
            add_modifier_node('inflation'),
            add_modifier_node('discard_cost'),
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

    if G.modifiers.flipped_cards then table.insert(args.challenge.rules.custom, {id = 'flipped_cards', value = 4}) end
    if G.modifiers.all_eternal then table.insert(args.challenge.rules.custom, {id = 'all_eternal'}) end
    if G.modifiers.no_interest then table.insert(args.challenge.rules.custom, {id = 'no_interest'}) end
    if G.modifiers.no_extra_hand_money then table.insert(args.challenge.rules.custom, {id = 'no_extra_hand_money'}) end
    if G.modifiers.debuff_played_cards then table.insert(args.challenge.rules.custom, {id = 'debuff_played_cards'}) end
    if G.modifiers.inflation then table.insert(args.challenge.rules.custom, {id = 'inflation'}) end
    if G.modifiers.no_shop_jokers then table.insert(args.challenge.rules.custom, {id = 'no_shop_jokers'}) end
    if G.modifiers.discard_cost then table.insert(args.challenge.rules.custom, {id = 'discard_cost', value = 1}) end


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
end

-- left for later wink wink
local set_blindref = Blind.set_blind
function Blind.set_blind(self, blind, reset, silent)
    if not reset and blind then
        
    end

    set_blindref(self, blind, reset, silent)
end