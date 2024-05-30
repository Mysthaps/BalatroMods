local blind = {
    name = "The Center",
    slug = "center", 
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 4, max = 10},
    boss_colour = HEX('FFEF71'),
    loc_txt = {
        ['default'] = {
            name = "The Center",
            text = {
                "Permanent +$1 price per",
                "unused hand on defeat"
            }
        },
        ['tp'] = {
            name = "󱥽󱤏",
            text = {
                "Permanent +$1 price per",
                "unused hand on defeat"
            }
        }
    }
}

blind.defeat = function(self, blind)
    if not blind.disabled then
        if G.GAME.current_round.hands_left > 0 then
            blind:wiggle()
            G.GAME.inflation = G.GAME.inflation or 0
            G.GAME.inflation = G.GAME.inflation + G.GAME.current_round.hands_left
        end
    end
end

return blind