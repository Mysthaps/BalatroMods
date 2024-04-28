local blind = {
    name = "Noir Silence",
    slug = "final_silence", 
    dollars = 8, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {showdown = true, min = 10, max = 10},
    color = HEX('404040')
}

blind.localization = {
    name = "Noir Silence",
    text = {
        "-4 Hand Size, +1 Hand Size",
        "after each hand played"
    }
}

blind.set_blind = function(self, blind, reset, silent)
    self.prepped = nil
    self.discards_sub = 1
    self.hands_sub = math.min(G.hand.config.card_limit - 1, 4)
    G.hand:change_size(-self.hands_sub)
end

blind.disable = function(self)
    G.hand:change_size(self.hands_sub)
end

blind.defeat = function(self, silent)
    G.hand:change_size(self.hands_sub)
end

blind.press_play = function(self)
    self.prepped = true
end

blind.drawn_to_hand = function(self)
    if G.GAME.current_round.hands_played == self.discards_sub then
        G.hand:change_size(1)
        self.discards_sub = self.discards_sub + 1 -- hands played
        self.hands_sub = self.hands_sub - 1 -- size removed
        self:wiggle()
    end
end

return blind