local joker = {
    name = "Jimbo's Prowess", slug = "prowess",
    config = { extra = {last_nominal = nil, last_rank = nil, last_id = nil }}, rarity = 3, cost = 8,
    blueprint_compat = true,
    eternal_compat = true
}

joker.localization = {
    name = "Jimbo's Prowess",
    text = {
        "{X:mult,C:white} X1 {} Mult, plus {X:mult,C:white} X0.75 {} Mult per",
        "difference between ranks of highest",
        "ranked card of {C:attention}Straight{}",
        "played and last {C:attention}Straight{} played",
        "{C:inactive}(Last highest: {}{C:attention}#1#{} {C:inactive}(#2#)){}"
    }
}

joker.loc_def = function(self)
    if not self.ability.extra.last_nominal or not self.ability.extra.last_rank then 
        return {localize('k_none'), localize('k_none')}
    end
    return {localize(self.ability.extra.last_rank, 'ranks'), self.ability.extra.last_nominal}
end

joker.calculate = function(self, context)
    if SMODS.end_calculate_context(context) and context.scoring_hand then
        local straight = get_straight(context.scoring_hand)[1]
        if not straight then return end

        local nominal_diff = 0
        if not context.blueprint then
            local highest_nominal = 0
            local highest_rank = ""
            local highest_id = 0
            for _, v in ipairs(straight) do
                if v.base.nominal > highest_nominal then
                    highest_nominal = v.base.nominal
                    highest_id = v.base.id
                    highest_rank = v.base.value
                elseif v.base.nominal == highest_nominal then
                    if v.base.id > highest_id then
                        highest_id = v.base.id
                        highest_rank = v.base.value
                    end
                end
            end

            if self.ability.extra.last_nominal then
                nominal_diff = math.abs(self.ability.extra.last_nominal - highest_nominal)
            end
            self.ability.extra.last_nominal = highest_nominal
            self.ability.extra.last_rank = highest_rank
            self.ability.extra.last_id = highest_id
        end

        if nominal_diff ~= 0 then
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {1 + 0.75*nominal_diff}},
                Xmult_mod = 1 + 0.75*nominal_diff
            }
        end
    end
end

return joker