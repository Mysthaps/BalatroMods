--- STEAMODDED HEADER
--- MOD_NAME: Yippee Joker over Win Screen
--- MOD_ID: YippeeGameOver
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: YIPPEEEEEEEE!!!

----------------------------------------------
------------MOD CODE -------------------------

local sound = nil
local won_game = false
function SMODS.INIT.YippeeGameOver()
    sendDebugMessage("yippee! Loaded YippeeGameOver~")

    -- Assets
    local mod = SMODS.findModByID("YippeeGameOver")
    local sprite_yippee = SMODS.Sprite:new("YippeeGameOver", mod.path, "tbh_joker.png", 71, 95, "asset_atli")
    sprite_yippee:register()

    sound = {sound = love.audio.newSource(mod.path .. 'assets/yippee.ogg', 'static')}
    sound.original_pitch = 1
    sound.original_volume = 0.7
    sound.sound_code = 'yippee'

    -- Add Yippee Joker
    G.P_CENTERS.j_yippee = {
        order = 0,
        name = "yippee",
        set = "",
        config = {},
        pos = { x = 0, y = 0 },
        atlas = "YippeeGameOver"
    }  
end

local win_gameref = win_game
function win_game() 
    win_gameref()
    won_game = true
end

local set_abilityref = Card.set_ability
function Card.set_ability(self, center, initial, delay_sprites)
    set_abilityref(self, center, initial, delay_sprites)

    if self.ability.name == "yippee" then
        self:set_sprites(center)
    end
end

local card_characterinitref = Card_Character.init
function Card_Character.init(self, args)
    card_characterinitref(self, args)

    if won_game then
        -- remove old Jimbo
        self.children.card:remove()
        self.children.card = Card(self.T.x, self.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS.j_yippee, {bypass_discovery_center = true})
        self.children.card.states.visible = false
        self.children.card:start_materialize({G.C.BLUE, G.C.WHITE, G.C.RED})
        self.children.card:set_alignment{
            major = self, type = 'cm', offset = {x=0, y=0}
        }
        self.children.card.jimbo = self
        self.children.card.states.collide.can = true
        self.children.card.states.focus.can = false
        self.children.card.states.hover.can = true
        self.children.card.states.drag.can = false
        self.children.card.hover = Node.hover

        if getmetatable(self) == Card_Character then 
            table.insert(G.I.CARD, self)
        end
    end
end

local card_charactersay_stuffref = Card_Character.say_stuff
function Card_Character.say_stuff(self, n, not_first)
    card_charactersay_stuffref(self, n, not_first)

    if not_first and won_game then
        -- respect volume sliders
        local sound_vol = sound.original_volume*(G.SETTINGS.SOUND.volume/100.0)*(G.SETTINGS.SOUND.game_sounds_volume/100.0)
        if sound_vol <= 0 then
            sound.sound:setVolume(0)
        else
            sound.sound:setVolume(sound_vol)
        end
        love.audio.play(sound.sound)
        won_game = false
    end
end

----------------------------------------------
------------MOD CODE END----------------------
