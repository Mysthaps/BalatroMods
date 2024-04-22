local joker = {
    name = "Collectible Card", slug = "rdcards",
    config = {}, rarity = 3, cost = 8,
    blueprint_compat = true,
    eternal_compat = true
}

joker.localization = {
    name = "Collectible Card",
    text = {
        "Each scored card with same",
        "{C:attention}rank{} as {C:attention}first{} scored card",
        "gives {C:chips}+5{} Chips to all cards",
        "in {C:attention}full deck{} of that rank",
    }
}

joker.set_ability = function(self, center, initial, delay_sprites)
    self.T.h = self.T.h / 1.33333
end

joker.calculate = function(self, context)
    if context.individual and context.cardarea == G.play then
        local id = context.scoring_hand[1]:get_id()
            if context.other_card:get_id() == id then
            for _, v in ipairs(G.playing_cards) do
                if v:get_id() == id then
                    v.ability.perma_bonus = v.ability.perma_bonus or 0
                    v.ability.perma_bonus = v.ability.perma_bonus + 5
                end
            end

            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
                colour = G.C.CHIPS,
                card = self
            }
        end
    end
end

return joker