local joker = {
    name = "bobm", slug = "bobm",
    config = { extra = 300 }, rarity = 1, cost = -4, 
    blueprint_compat = false, 
    eternal_compat = true
}

joker.localization = {
    name = "bobm",
    text = {
        "{C:dark_edition}Negative, Eternal{}",
        "Lose the game",
        "after {C:attention}300{} seconds",
        "{C:inactive}(Time left: #1#s)"
    }
}

joker.yes_pool_flag = "this_flag_will_never_be_added_to_pools"

joker.set_ability = function(self, center, initial, delay_sprites)
    self:set_edition({ negative = true })
    self.ability.eternal = true
end

joker.loc_def = function(self)
    if not self.ability.extra then return { 300 } end
    return { math.floor(self.ability.extra) }
end

return joker