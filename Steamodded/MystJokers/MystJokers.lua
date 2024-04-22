--- STEAMODDED HEADER
--- MOD_NAME: Myst's Jokers
--- MOD_ID: MystJokers
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: A pack of Jokers
--- DISPLAY_NAME: MystJokers
--- BADGE_COLOUR: EDA9D3

local joker_list = {
    "miracle_milk",
    "lucky_seven",
    "scratch_card",
    "polydactyly",
    "yield_flesh",
    "pebbler",
    "autism_creature",
    "jimpostor", -- Suspicious Joker
    "options",
    "credits",
    "pap",
    "r_key",
    "exploding_fruitcake",
    "bobm",
    "rdcards", -- Collectible Card
    "prowess",
}

function SMODS.INIT.MystJokers()
    local mod_path = SMODS.findModByID("MystJokers").path

    -- basically taken from 5CEBalatro lol
    for _, v in ipairs(joker_list) do
        local joker = NFS.load(mod_path.."indiv_jokers/"..v..".lua")()

        -- don't fuck up the mod
        if not joker then
            sendErrorMessage("[MystJokers] Cannot find joker with shorthand: "..v)
        elseif joker.fusion and not SMODS.INIT.FusionJokers then
            sendWarnMessage("[MystJokers] Cannot find FusionJokers, did not load joker: "..v)
        else
            local sprite = NFS.getInfo(mod_path.."assets/2x/j_"..v..".png")
            if not sprite then
                sendWarnMessage("[MystJokers] Cannot find sprite ".."j_"..v..".png, fallbacking to blank")
            end

            SMODS.Joker:new(joker.name, 'myst_'..joker.slug, joker.config, {x = 0, y = 0}, joker.localization, joker.rarity, joker.cost, true, true, joker.blueprint_compat, joker.eternal_compat, "", "j_"..joker.slug):register()
            SMODS.Sprite:new('j_'..joker.slug, mod_path, (sprite and "j_"..joker.slug or "blank")..".png", 71, 95, "asset_atli"):register()

            if joker.fusion then
                local fus = joker.fusion
                FusionJokers.fusions:add_fusion(fus.joker1, fus.stat1, fus.extra1, fus.joker2, fus.stat2, fus.extra2, "j_myst_"..v, joker.cost)
            end

            if joker.set_ability then SMODS.Jokers['j_myst_'..v].set_ability = joker.set_ability end
            if joker.calculate then SMODS.Jokers['j_myst_'..v].calculate = joker.calculate end
            if joker.loc_def then SMODS.Jokers['j_myst_'..v].loc_def = joker.loc_def end
            if joker.tooltip then SMODS.Jokers['j_myst_'..v].tooltip = joker.tooltip end
            if joker.yes_pool_flag then SMODS.Jokers['j_myst_'..v].yes_pool_flag = joker.yes_pool_flag end
            if joker.enhancement_gate then SMODS.Jokers['j_myst_'..v].enhancement_gate = joker.enhancement_gate end
        end
    end

    G.localization.misc.dictionary.k_cleansed = "Cleansed!"
    G.localization.misc.dictionary.k_wheel = "Wheel!"
    G.localization.descriptions.Joker.j_bobm_tooltip = {
        name = "bobm",
        text = {
            "{C:dark_edition}Negative, Eternal{}",
            "Lose the game",
            "after {C:attention}300{} seconds",
            "{C:inactive}(Time left: 300s)"
        }
    }

    sendInfoMessage("Loaded MystJokers~")
end

---- Other functions ----

-- find_joker but keys
local function find_joker_with_key(key, non_debuff)
    local jokers = {}
    if not G.jokers or not G.jokers.cards then return {} end
    for _, v in pairs(G.jokers.cards) do
        if v and type(v) == 'table' and v.config.center.key == key and (non_debuff or not v.debuff) then
            table.insert(jokers, v)
        end
    end
    for _, v in pairs(G.consumeables.cards) do
        if v and type(v) == 'table' and v.config.center.key == key and (non_debuff or not v.debuff) then
            table.insert(jokers, v)
        end
    end
    return jokers
end

-- Card updates
local card_updateref = Card.update
function Card.update(self, dt)
    if G.STAGE == G.STAGES.RUN then
        if self.config.center.key == "j_myst_autism_creature" then
            self.ability.extra = (G.jokers.config.card_limit - #G.jokers.cards) * 6
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == 'Joker Stencil' then self.ability.extra = self.ability.extra + 6 end
            end
        end
        if self.config.center.key == "j_myst_bobm" and not self.debuff then
            self.ability.extra = self.ability.extra - (dt / G.SETTINGS.GAMESPEED)
            if self.ability.extra <= 0 and G.STATE ~= G.STATES.GAME_OVER then
                G.STATE = G.STATES.GAME_OVER
                if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
                    G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                end
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
            end
        end
    end
    card_updateref(self, dt)
end

-- Set sprites
local card_set_spritesref = Card.set_sprites
function Card.set_sprites(self, _center, _front)
    card_set_spritesref(self, _center, _front)
    if _center and _center.set then
        if _center.key == 'j_myst_rdcards' and (_center.discovered or self.bypass_discovery_center) then 
            self.children.center.scale.y = self.children.center.scale.y/1.33333
        end
    end
end

-- Load sprites
local card_loadref = Card.load
function Card.load(self, cardTable, other_card)
    card_loadref(self, cardTable, other_card)

    local scale = 1
    local H = G.CARD_H
    local W = G.CARD_W

    if self.config.center.key == "j_myst_rdcards" then 
        self.T.h = H*scale/1.33333*scale
        self.T.w = W*scale
    end
end

-- Polydactyly
local openref = Card.open
function Card.open(self)
    local temp = 0
    local extra_pulls = 0
    if self.ability.set == "Booster" then
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == "j_myst_polydactyly" and not v.debuff then
                extra_pulls = extra_pulls + 1
            end
        end
        self.config.center.config.choose = self.config.center.config.choose or 1
        temp = self.config.center.config.choose
        self.config.center.config.choose = math.min(self.config.center.config.choose + extra_pulls,
            self.ability.extra)
    end
    openref(self)
    if self.ability.set == "Booster" then
        self.config.center.config.choose = temp
    end
end

-- Yield My Flesh
local evaluate_playref = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(self, e)
    evaluate_playref(self, e)

    for i = 1, #G.jokers.cards do
        local effects = eval_card(G.jokers.cards[i],
            { card = G.consumeables, after = true, scored_chips = hand_chips * mult })
        if effects.jokers then
            card_eval_status_text(G.jokers.cards[i], 'jokers', nil, 0.3, nil, effects.jokers)
        end
    end
end

-- Options / Credits / Pictured as Perfect
local draw_from_deck_to_handref = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS.draw_from_deck_to_hand(self, e)
    draw_from_deck_to_handref(self, e)

    for _, v in ipairs(G.jokers.cards) do
        if G.STATE == G.STATES.DRAW_TO_HAND and not v.debuff then
            if v.config.center.key == "j_myst_options" and G.GAME.current_round.hands_played == v.ability.extra or
            v.config.center.key == "j_myst_credits" and G.GAME.current_round.discards_used == v.ability.extra then
                for i = 1, 2 do draw_card(G.deck, G.hand, i*100/2, 'up', true) end
                v.ability.extra = v.ability.extra + 1
            end
            if v.config.center.key == "j_myst_pap" and G.GAME.current_round.discards_used == v.ability.extra then
                for i = 1, 3 do draw_card(G.deck, G.hand, i*100/2, 'up', true) end
                v.ability.extra = v.ability.extra + 1
            end
        end
    end
end

-- R Key
local set_costref = Card.set_cost
function Card.set_cost(self)
    set_costref(self)
    if self.config.center.key == "j_myst_r_key" then
        self.sell_cost = 0
    end
end

-- Pebbler Joker
local add_to_highlightedref = CardArea.add_to_highlighted
function CardArea.add_to_highlighted(self, card, silent)
    if self.config.type == "hand" then
        local stone_count = 0
        if next(find_joker_with_key("j_myst_pebbler")) then
            for _, v in ipairs(G.hand.highlighted) do
                if v.ability.effect == "Stone Card" then
                    stone_count = stone_count + 1
                end
            end
            if #self.highlighted - stone_count < self.config.highlighted_limit or card.ability.effect == "Stone Card" then
                self.highlighted[#self.highlighted+1] = card
                card:highlight(true)
                if not silent then play_sound('cardSlide1') end

                if self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
                    self:parse_highlighted()
                end
                return
            end
        end
    end
    add_to_highlightedref(self, card, silent)
end

local can_playref = G.FUNCS.can_play
function G.FUNCS.can_play(e)
    can_playref(e)
    local stone_count = 0
    if next(find_joker_with_key("j_myst_pebbler")) then
        for _, v in ipairs(G.hand.highlighted) do
            if v.ability.effect == "Stone Card" then
                stone_count = stone_count + 1
            end
        end

        if not G.GAME.blind.block_play and #G.hand.highlighted - stone_count <= 5 then 
            e.config.colour = G.C.BLUE
            e.config.button = 'play_cards_from_highlighted'
        end
    end
end

-- Scratched Card
local get_p_dollarsref = Card.get_p_dollars
function Card.get_p_dollars(self)
    local ret = 0
    for _, v in ipairs(G.jokers.cards) do
        if not v.debuff and v.config.center.key == "j_myst_scratch_card" then
            if self.lucky_trigger then
                ret = ret + 5
            end
        end
    end
    ret = ret + get_p_dollarsref(self)
    G.GAME.dollar_buffer = ret
    return ret
end

local get_chip_multref = Card.get_chip_mult
function Card.get_chip_mult(self)
    local ret = get_chip_multref(self)
    for _, v in ipairs(G.jokers.cards) do
        if not v.debuff and v.config.center.key == "j_myst_scratch_card" then
            if self.lucky_trigger then
                ret = ret + 10
            end
        end
    end
    return ret
end