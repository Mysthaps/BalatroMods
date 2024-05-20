local blind = {
    name = "The Fruit",
    slug = "fruit", 
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 2, max = 10},
    boss_colour = HEX('E06B3B'),
    loc_txt = {
        ['default'] = {
            name = "The Fruit",
            text = {
                "No hands with even",
                "total ranks of played cards"
            }
        },
        ['tp'] = {
            name = "󱥽󱤚",
            text = {
                "No hands with even",
                "total ranks of played cards"
            }
        }
    }
}

blind.debuff_hand = function(self, cards, hand, handname, check)
    self.triggered = false
    local total = 0
    for _, v in ipairs(cards) do
        total = total + v.base.nominal
    end
    if total % 2 == 0 then
        self.triggered = true
        return true
    end
end

return blind