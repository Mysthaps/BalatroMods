local blind = {
    name = "The Monster",
    slug = "monster", 
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 2, max = 10},
    boss_colour = HEX('3C074D'),
    loc_txt = {
        ['default'] = {
            name = "The Monster",
            text = {
                "Destroy all consumables,",
                "0 consumable slots"
            }
        },
        ['tp'] = {
            name = "󱥽󱥽",
            text = {
                "Destroy all consumables,",
                "0 consumable slots"
            }
        }
    }
}


blind.set_blind = function(self, blind, reset, silent)
    G.GAME.consumeable_buffer = 0
    blind.hands_sub = 0

    ---- check for Chicot
    if not next(find_joker("Chicot")) then
        for k, v in ipairs(G.consumeables.cards) do
            v:start_dissolve(nil, (k ~= 1))
        end

        G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
            blind.hands_sub = G.consumeables.config.card_limit
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - blind.hands_sub
            return true
        end}))
    end
end

blind.disable = function(self, blind)
    G.consumeables.config.card_limit = G.consumeables.config.card_limit + blind.hands_sub
end

blind.defeat = function(self, blind)
    sendDebugMessage("defeated")
    G.consumeables.config.card_limit = G.consumeables.config.card_limit + blind.hands_sub
end

return blind