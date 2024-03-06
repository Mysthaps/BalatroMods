table.insert(mods,
    {
        mod_id = "golden_challenge",
        name = "Golden Challenge",
        author = "Mysthaps",
        version = "0.1",
        description = {
            "Adds the challenge \"Golden\"",
            "\"Yellow\"",
        },
        enabled = true,
        on_enable = function(e)
            table.insert(G.CHALLENGES, #G.CHALLENGES + 1, {
                name = 'Golden',
                id = 'c_mod_golden',
                rules = {
                    custom = {
                        { id = 'gold_stake' },
                        { id = 'gold_cards' },
                        { id = 'increased_price' }
                    },
                    modifiers = {
                        { id = 'discards',    value = 2 },
                        { id = 'hand_size',   value = 7 },
                        { id = 'reroll_cost', value = 25 },
                    }
                },
                jokers = {
                    { id = 'j_golden',     eternal = true, edition = 'negative' },
                    { id = 'j_ticket',     eternal = true, edition = 'negative' },
                    { id = 'j_midas_mask', eternal = true, edition = 'negative' }
                },
                consumeables = {
                },
                vouchers = {
                },
                deck = {
                    enhancement = 'm_gold',
                    type = 'Challenge Deck'
                },
                restrictions = {
                    banned_cards = {
                        { id = 'j_vampire' },
                    },
                    banned_tags = {
                    },
                    banned_other = {

                    }
                }
            })

            -- Localization
            G.localization.misc.challenge_names.c_mod_golden = "Golden"
            G.localization.misc.v_text.ch_c_gold_stake = {
                "Apply {C:attention}Gold Stake{} rules",
            }
            G.localization.misc.v_text.ch_c_gold_cards = {
                "All cards have {C:attention}Gold{} enhancement and {C:attention}Gold Seal{}"
            }
            G.localization.misc.v_text.ch_c_increased_price = {
                "All prices are {C:attention}five times{} as expensive"
            }

            -- Update localization
            init_localization()

            local runPatch = [[
                if self.GAME.modifiers["gold_stake"] then
                    self.GAME.modifiers.no_blind_reward = self.GAME.modifiers.no_blind_reward or {}
                    self.GAME.modifiers.no_blind_reward.Small = true
                self.GAME.modifiers.scaling = 3
                    self.GAME.modifiers.enable_eternals_in_shop = true
                    self.GAME.modifiers.booster_ante_scaling = true
                    self.GAME.stake = 8
                end

                if self.GAME.modifiers["gold_cards"] then
                    for _, v in pairs(G.playing_cards) do
                        v:set_seal("Gold", true, true)
                    end
                end
            ]]

            injectTail("game.lua", "Game:start_run", runPatch)

            local setPatch = [[
                if G.GAME.modifiers["increased_price"] then
                    self.cost = self.cost * 5
                end
            ]]

            injectTail("card.lua", "Card:set_cost", setPatch)
        end,
    }
)
