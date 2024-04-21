local joker = {
    name = "Autism Creature", slug = "autism_creature",
    config = {extra = 0}, rarity = 1, cost = 4, 
    blueprint_compat = true, 
    eternal_compat = true
}

joker.localization = {
    name = "Autism Creature",
    text = {
        "{C:mult}+6{} Mult for each",
        "empty {C:attention}Joker{} slot",
        "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
    }
}

joker.calculate = function(self, context)
    if SMODS.end_calculate_context(context) then
        if self.ability.extra > 0 then
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { self.ability.extra } },
                mult_mod = self.ability.extra,
            }
        end
    end
end

joker.loc_def = function(self)
    return { self.ability.extra }
end

return joker