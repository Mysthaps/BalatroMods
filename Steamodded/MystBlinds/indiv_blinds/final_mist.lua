local blind = {
    name = "Scarlet Mist",
    slug = "final_mist", 
    dollars = 8, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('CA1C1C'),
    loc_txt = {
        name = "Scarlet Mist",
        text = {
            "Halves Base Mult, sets",
            "Base Chips to Base Mult"
        }
    }
}

blind.modify_hand = function(self, blind, cards, poker_hands, text, mult, hand_chips)
    blind.triggered = true
    return math.max(math.floor(mult*0.5 + 0.5), 1), math.max(math.floor(mult*0.5 + 0.5), 1), true
end

return blind