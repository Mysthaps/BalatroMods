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
    self.prepped = nil
    self.hands_sub = math.min(G.hand.config.card_limit - 1, 4)
    G.hand:change_size(-self.hands_sub)
end

blind.disable = function(self)
    G.hand:change_size(self.hands_sub)
    G.FUNCS.draw_from_deck_to_hand(self.hands_sub)
    self.hands_sub = 0
end

blind.defeat = function(self, silent)
    G.hand:change_size(self.hands_sub)
end

blind.press_play = function(self)
    self.prepped = true
end

blind.drawn_to_hand = function(self)
    if self.prepped then
        G.hand:change_size(1)
        self.hands_sub = self.hands_sub - 1 -- size removed
        self:wiggle()
    end
end

return blind