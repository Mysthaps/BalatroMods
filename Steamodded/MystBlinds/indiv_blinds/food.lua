local blind = {
    name = "The Food",
    slug = "food", 
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    boss_colour = HEX('1EE68E'),
    loc_txt = {
        ['default'] = {
            name = "The Food",
            text = {
                "No hands with",
                "odd total ranks"
            }
        },
        ['tp'] = {
            name = "󱥽󱤶",
            text = {
                "No hands with",
                "odd total ranks"
            }
        }
    }
}

blind.debuff_hand = function(self, blind, cards, hand, handname, check)
    blind.triggered = false
    local total = 0
    for _, v in ipairs(cards) do
        total = total + v.base.nominal
    end
    if total % 2 == 1 then
        blind.triggered = true
        return true
    end
end

return blind