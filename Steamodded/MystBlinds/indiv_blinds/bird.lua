local blind = {
    name = "The Bird",
    slug = "bird", 
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    color = HEX('9CE0F0')
}

blind.localization = {
    name = "The Bird",
    text = {
        "Apply a random sticker",
        "to a Joker every hand"
    }
}

blind.set_blind = function(self, blind, reset, silent)
    self.prepped = true
end

blind.drawn_to_hand = function(self)
    if G.GAME.current_round.hands_played == self.discards_sub and self.prepped then
        local available_jokers = {}
        for _, v in ipairs(G.jokers.cards) do
            if not v.ability.rental or (not v.ability.perishable and not v.ability.eternal) then
                table.insert(available_jokers, v)
            end
        end

        if #available_jokers > 0 then
            local chosen_joker = pseudorandom_element(available_jokers, pseudoseed('random_joker'))
            local stickers = {}

            if not chosen_joker.ability.perishable and not chosen_joker.ability.eternal then 
                if chosen_joker.config.center.eternal_compat then table.insert(stickers, "eternal") end
                if chosen_joker.config.center.perishable_compat then table.insert(stickers, "perishable") end
            end
            if not chosen_joker.ability.rental then table.insert(stickers, "rental") end

            if #stickers > 0 then
                local chosen_sticker = pseudorandom_element(stickers, pseudoseed('random_sticker'))
                sendDebugMessage(chosen_sticker)
                sendDebugMessage(chosen_joker.ability.name)

                if chosen_sticker == "eternal" then chosen_joker.ability.eternal = true end
                if chosen_sticker == "perishable" then chosen_joker:set_perishable(true) end
                if chosen_sticker == "rental" then chosen_joker:set_rental(true) end

                self:wiggle()
            end
        end
        self.prepped = false
    end
end

return blind