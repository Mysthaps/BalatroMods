local joker = {
    name = "Credits", slug = "credits",
    config = {extra = 1}, rarity = 2, cost = 5, 
    blueprint_compat = false, 
    eternal_compat = true
}

joker.localization = {
    name = "Credits",
    text = {
        "After discarding,",
        "draw {C:attention}two{} extra cards"
    }
}

joker.set_ability = function(self, center, initial, delay_sprites)
    self.ability.extra = G.GAME.current_round.discards_used + 1
end

joker.calculate = function(self, context)
    if context.setting_blind and not self.getting_sliced and not context.blueprint then
        self.ability.extra = 1
    end
end

return joker