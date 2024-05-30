local blind = {
    name = "Noir Silence",
    slug = "final_silence", 
    dollars = 8, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('404040'),
    loc_txt = {
        name = "Noir Silence",
        text = {
            "-4 Hand Size, +1 Hand Size",
            "after each hand played"
        }
    }
}

blind.set_blind = function(self, blind, reset, silent)
    blind.prepped = nil
    blind.hands_sub = math.min(G.hand.config.card_limit - 1, 4)
    G.hand:change_size(-blind.hands_sub)
end

blind.disable = function(self, blind)
    G.hand:change_size(blind.hands_sub)
    G.FUNCS.draw_from_deck_to_hand(blind.hands_sub)
    blind.hands_sub = 0
end

blind.defeat = function(self, blind, silent)
    G.hand:change_size(blind.hands_sub)
end

blind.press_play = function(self, blind)
    blind.prepped = true
end

blind.drawn_to_hand = function(self, blind)
    if blind.prepped then
        G.hand:change_size(1)
        blind.hands_sub = blind.hands_sub - 1 -- size removed
        blind:wiggle()
    end
end

return blind