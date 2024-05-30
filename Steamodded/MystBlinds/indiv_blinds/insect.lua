local blind = {
    name = "The Insect",
    slug = "insect", 
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 3, max = 10},
    boss_colour = HEX('873E2C'),
    loc_txt = {
        ['default'] = {
            name = "The Insect",
            text = {
                "Debuffs leftmost Joker",
                "every hand"
            }
        },
        ['tp'] = {
            name = "󱥽󱥑",
            text = {
                "Debuffs leftmost Joker",
                "every hand"
            }
        }
    }
}

blind.press_play = function(self, blind)
    blind.prepped = true
end

blind.drawn_to_hand = function(self, blind)
    if G.jokers and G.jokers.cards[1] and not G.jokers.cards[1].debuff and blind.prepped then
        G.jokers.cards[1]:set_debuff(true)
        G.jokers.cards[1]:juice_up()
        blind:wiggle()
    end
end

return blind