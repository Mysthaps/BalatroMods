local blind = {
    name = "The Symbol",
    slug = "symbol", 
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 4, max = 10},
    boss_colour = HEX('5865F2'),
    loc_txt = {
        ['default'] = {
            name = "The Symbol",
            text = {
                "Destroy a random card",
                "in deck per scored card"
            }
        },
        ['tp'] = {
            name = "󱥽󱥠",
            text = {
                "Destroy a random card",
                "in deck per scored card"
            }
        }
    }
}

blind.press_play = function(self, blind)
    local available_cards = {}
    for _, v in ipairs(G.deck.cards) do
        available_cards[#available_cards+1] = v
    end

    if #available_cards > 0 then
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            for i = 1, #G.play.cards do
                -- double check if deck still exists
                if #available_cards > 0 then
                    G.E_MANAGER:add_event(Event({func = function() G.play.cards[i]:juice_up(); return true end })) 
                    local selected_card, card_key = pseudorandom_element(available_cards, pseudoseed('symbol'))
                    selected_card:start_dissolve()
                    table.remove(available_cards, card_key)
                end
            end
        return true end }))

        blind.triggered = true
        return true
    end
end

return blind