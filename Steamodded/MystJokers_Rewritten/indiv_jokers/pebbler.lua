local joker = {
    name = "Pebbler Joker", slug = "pebbler",
    config = {}, rarity = 2, cost = 6,
    blueprint_compat = false,
    eternal_compat = true
}

joker.localization = {
    name = "Pebbler Joker",
    text = {
        "Allows {C:attention}Stone Cards{}",
        "to be selected and played",
        "past the hand card limit",
    }
}

joker.tooltip = function(self, info_queue)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
end

joker.enhancement_gate = "m_stone"

return joker