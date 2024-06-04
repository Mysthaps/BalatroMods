local joker = {
    name = "Exploding Fruitcake", slug = "exploding_fruitcake",
    config = {}, rarity = 3, cost = 7, 
    blueprint_compat = true, -- yes this is literally just bait you get two bobms
    eternal_compat = false
}

joker.localization = {
    name = "Exploding Fruitcake",
    text = {
        "When {C:attention}Small Blind{} begins, gives",
        "a random {C:dark_edition}Edition{} to all",
        "Jokers and consumables, then",
        "replace this with a {C:attention}bobm{}"
    }
}

joker.calculate = function(self, context)
    if context.first_hand_drawn then
        if G.GAME.blind and G.GAME.blind:get_type() == 'Small' then
            -- Editions
            for _, v in ipairs(G.jokers.cards) do
                if v ~= self and not v.edition then
                    local edition = poll_edition('exploding_fruitcake_jokers', nil, false, true)
                    v:set_edition(edition)
                end
            end

            for _, v in ipairs(G.consumeables.cards) do
                if not v.edition then
                    local edition = poll_edition('exploding_fruitcake_consumeables', nil, false, true)
                    v:set_edition(edition)
                end
            end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()    
                    self:flip()
                    self:set_ability(G.P_CENTERS['j_myst_bobm'], false, true)
                    play_sound('card1', 1.1)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    delay(1.2)  
                    self:flip()
                    return true
                end
            }))
        end
    end
end

joker.tooltip = function(self, info_queue)
    info_queue[#info_queue+1] = {key = 'j_bobm_tooltip', set = 'Joker', vars = {300}}
end

joker.loc_def = function(self)
    return {}
end

return joker