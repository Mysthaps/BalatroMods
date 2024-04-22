local joker = {
    name = "R Key", slug = "r_key",
    config = {}, rarity = 3, cost = 40, 
    blueprint_compat = false, 
    eternal_compat = false
}

joker.localization = {
    name = "R Key",
    text = {
        "Sell this Joker to",
        "reduce Ante by {C:attention}2{},",
        "down to minimum Ante {C:attention}1{}",
    }
}

joker.set_ability = function(self, center, initial, delay_sprites)
    self.sell_cost = 0
end

joker.calculate = function(self, context)
    if context.selling_self then
        G.E_MANAGER:add_event(Event({
            func = (function()
                for _ = 1, 2 do
                    if G.GAME.round_resets.blind_ante <= 1 or G.GAME.round_resets.ante <= 1 then break end

                    ease_ante(-1)
                    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - 1
                    delay(0.2)
                end
                play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                return true
            end)
        }))
    end
end

return joker