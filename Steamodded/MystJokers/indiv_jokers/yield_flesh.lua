local joker = {
    name = "Yield My Flesh", slug = "yield_flesh",
    config = {extra = { Xmult = 3, active = false }},
    rarity = 2, cost = 7, 
    blueprint_compat = true, 
    eternal_compat = true
}

joker.localization = {
    name = "Yield My Flesh",
    text = {
        "{X:mult,C:white} X3 {} Mult after first played",
        "hand scores less than",
        "{C:attention}5%{} of required chips"
    }
}

joker.calculate = function(self, context)
    if context.first_hand_drawn then
        local eval = function() return G.GAME.current_round.hands_played == 0 end
        juice_card_until(self, eval, true)
    end

    if context.scored_chips and context.after and not context.blueprint then
        if G.GAME.current_round.hands_played == 0 and context.scored_chips / G.GAME.blind.chips <= 0.05 then
            self.ability.extra.active = true
            return {
                message = localize('k_active_ex'),
                colour = G.C.FILTER
            }
        end
    end

    if context.end_of_round and not context.blueprint then
        self.ability.extra.active = false
    end

    if SMODS.end_calculate_context(context) then
        if self.ability.extra.active then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.extra.Xmult } },
                Xmult_mod = self.ability.extra.Xmult,
            }
        end
    end
end

return joker