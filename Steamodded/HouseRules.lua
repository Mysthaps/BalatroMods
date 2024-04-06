--- STEAMODDED HEADER
--- MOD_NAME: House Rules
--- MOD_ID: HouseRules
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: Adds difficulty modifiers to your runs

-- default values

function SMODS.INIT.HouseRules()
    G.localization.misc.dictionary.b_modifiers_cap = "Modifiers"

    G.localization.misc.dictionary.m_minus_discard = "-1 hand"
    G.localization.misc.dictionary.m_minus_hand = "-1 discard"
    G.localization.misc.dictionary.m_minus_hand_size = "-1 hand size"
    G.localization.misc.dictionary.m_minus_consumable_slot = "-1 consumable slot"
    G.localization.misc.dictionary.m_minus_joker_slot = "-1 Joker slot"
    G.localization.misc.dictionary.m_minus_starting_dollars = "-4 starting dollars"
    G.localization.misc.dictionary.m_increased_blind_size = "X2 base Blind size"
    G.localization.misc.dictionary.m_increased_reroll_cost = "+1 reroll cost"

    G.modifiers = {
        minus_discard = false,
        minus_hand = false,
        minus_hand_size = false,
        minus_consumable_slot = false,
        minus_joker_slot = false,
        minus_starting_dollars = false,
        increased_blind_size = false,
        increased_reroll_cost = false,
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
    { n = G.UIT.R, config = {align = "cr", minw = 6, padding = 0, colour = G.C.GREY}, nodes = {
        {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
            { n = G.UIT.T, config = { text = localize('m_'..modifier_name), scale = 0.3, colour = G.C.UI.TEXT_LIGHT, shadow = true }},
        }},
        {n = G.UIT.C, config = { align = "cr", padding = 0.1 }, nodes = {
            create_toggle{ col = true, label = "", w = 0, scale = 0.6, shadow = true, ref_table = G.modifiers, ref_value = modifier_name },
        }}
    }}
end

function create_UIBox_modifiers()
    local t = create_UIBox_generic_options({ back_id = G.STATE == G.STATES.GAME_OVER and 'from_game_over', back_func = 'setup_run', contents = {
        { n = G.UIT.C, config = { align = "cm", padding = 0 }, nodes = {
            add_modifier_node('minus_hand'),
            add_modifier_node('minus_hand_size'),
            add_modifier_node('minus_joker_slot'),
            add_modifier_node('increased_blind_size'),
        }},
        { n = G.UIT.C, config = { align = "cm", padding = 0 }, nodes = {
            add_modifier_node('minus_discard'),
            add_modifier_node('minus_consumable_slot'),
            add_modifier_node('minus_starting_dollars'),
            add_modifier_node('increased_reroll_cost'),
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

local start_runref = Game.start_run
function Game.start_run(self, args)
    start_runref(self, args)

    if not args.savetext then
        if G.modifiers.minus_discard then 
            sendDebugMessage("yay")
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
end

-- left for later wink wink
local set_blindref = Blind.set_blind
function Blind.set_blind(self, blind, reset, silent)
    if not reset and blind then
        
    end

    set_blindref(self, blind, reset, silent)
end