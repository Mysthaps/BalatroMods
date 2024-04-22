local joker = {
    name = "Pictured as Perfect", slug = "pap",
    config = {extra = 1}, rarity = 5, cost = 11, 
    blueprint_compat = false, 
    eternal_compat = true
}

joker.localization = {
    name = "Pictured as Perfect",
    text = {
        "After playing a hand,",
        "{C:red}+1{} discard this blind",
        "After discarding,",
        "draw {C:attention}three{} extra cards"
    }
}

joker.set_ability = function(self, center, initial, delay_sprites)
    self.ability.extra = G.GAME.current_round.discards_used + 1
end

joker.calculate = function(self, context)
    if context.setting_blind and not self.getting_sliced and not context.blueprint then
        self.ability.extra = 1
    end
    if context.cardarea == G.jokers and context.after and not context.blueprint then
        ease_discard(1)
    end
end

joker.fusion = {
    joker1 = "j_myst_options",
    stat1 = nil,
    extra1 = false,
    joker2 = "j_myst_credits",
    stat2 = "extra",
    extra2 = false,
}

return joker