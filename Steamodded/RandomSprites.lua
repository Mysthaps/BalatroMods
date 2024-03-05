--- STEAMODDED HEADER
--- MOD_NAME: Random Sprites
--- MOD_ID: RandomSprites
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: Randomizes the sprites of all Jokers, Vouchers, Boosters and comsumables

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.RandomSprites()
    sendDebugMessage("Loaded Random Sprites~")
end

local set_abilityref = Card.set_ability
function Card.set_ability(self, center, initial, delay_sprites)
    set_abilityref(self, center, initial, delay_sprites)

    local posx = center.pos.x
    local posy = center.pos.y

    if self.ability.set == 'Joker' then
        center.atlas = 'Joker'
        posx = math.random(0, 9)
        posy = math.random(0, 14)
        if posy >= 9 then posy = posy + 1 end 
    elseif self.ability.set == 'Voucher' then
        center.atlas = 'Voucher'
        posx = math.random(0, 7)
        posy = math.random(0, 3)
    elseif self.ability.set == 'Booster' then
        center.atlas = 'Booster'
        posx = math.random(0, 3)
        posy = math.random(0, 7)
        if posy >= 5 then posy = posy + 1 end
    elseif self.ability.consumeable then
        center.atlas = 'Tarot'
        local card = math.random(0, 51)
        if card >= 24 then card = card + 4 end
        posx = card % 10
        posy = math.floor(card / 10)
    end

    center.pos.x = posx
    center.pos.y = posy

    G.E_MANAGER:add_event(Event({
        func = function()
            if not self.REMOVED then
                self:set_sprites(center)
            end
            return true
        end
    }))
end

----------------------------------------------
------------MOD CODE END----------------------
