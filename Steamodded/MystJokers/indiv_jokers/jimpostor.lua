local joker = {
    name = "Suspicious Joker", slug = "jimpostor",
    config = {}, rarity = 2, cost = 7, 
    blueprint_compat = true, 
    eternal_compat = true
}

joker.localization = {
    name = "Suspicious Joker",
    text = {
        "{C:attention}Downgrades{} played hand",
        "to gain {X:mult,C:white} X0.5 {} Mult",
        "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)"
    }
}

joker.calculate = function(self, context)
    if context.cardarea == G.jokers and context.before and not context.blueprint then
        if G.GAME.hands[context.scoring_name].level <= 1 then
            return
        end
        level_up_hand(context.blueprint_card or self, context.scoring_name, nil, -1)
        self.ability.x_mult = self.ability.x_mult + 0.5
        card_eval_status_text((context.blueprint_card or self), 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult}}})
    end
end

joker.loc_def = function(self)
    return { self.ability.x_mult }
end

return joker