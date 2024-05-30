local blind = {
    name = "The Market",
    slug = "market", 
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 2, max = 10},
    boss_colour = HEX('76C860'),
    loc_txt = {
        ['default'] = {
            name = "The Market",
            text = {
                "Lose 25% of scored chips",
                "after each hand played"
            }
        },
        ['tp'] = {
            name = "󱥽󱤋",
            text = {
                "Lose 25% of scored chips",
                "after each hand played"
            }
        }
    }
}

blind.set_blind = function(self, blind, reset, silent)
    blind.prepped = nil
end

blind.press_play = function(self, blind)
    blind.prepped = true
end

blind.drawn_to_hand = function(self, blind)
    if blind.prepped then
        blind:wiggle()
        G.E_MANAGER:add_event(Event({
            trigger = 'ease',
            blocking = false,
            ref_table = G.GAME,
            ref_value = 'chips',
            ease_to = G.GAME.chips - math.floor(G.GAME.chips/4),
            delay =  0.5,
            func = (function(t) return math.floor(t) end)
        }))
    end
end

return blind