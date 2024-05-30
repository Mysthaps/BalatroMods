local blind = {
    name = "The Stone",
    slug = "stone", 
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 2, max = 10},
    boss_colour = HEX('85898C'),
    loc_txt = {
        ['default'] = {
            name = "The Stone",
            text = {
                "All Enhanced cards",
                "are debuffed"
            }
        },
        ['tp'] = {
            name = "󱥽󱤛",
            text = {
                "All Enhanced cards",
                "are debuffed"
            }
        }
    }
}

blind.debuff_card = function(self, blind, card, from_blind)
    if card.area ~= G.jokers and card.config.center ~= G.P_CENTERS.c_base then
        card:set_debuff(true)
        return
    end
end

return blind