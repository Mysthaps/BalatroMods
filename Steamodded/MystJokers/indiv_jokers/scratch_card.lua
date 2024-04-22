local joker = {
    name = "Scratched Card", slug = "scratch_card",
    config = {},
    rarity = 1, cost = 5, 
    blueprint_compat = false, 
    eternal_compat = true
}

joker.localization = {
    name = "Scratched Card",
    text = {
        "Gives {C:mult}+10{} Mult and {C:money}$5{} to",
        "{C:attention}Lucky Card{} triggers giving {C:mult}Mult{}",
    }
}

joker.tooltip = function(self, info_queue)
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
end

return joker