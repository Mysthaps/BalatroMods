if (sendDebugMessage == nil) then
    sendDebugMessage = function(_)
    end
end

table.insert(mods,
    {
        mod_id = "blindcollectionpatch",
        name = "Blind Collection Patch",
        author = "Mysthaps",
        version = "0.2",
        description = {
            "Patches several functions to allow adding and displaying Blinds properly",
        },
        enabled = true,
        on_enable = function()
            -----------------------------------------------------------------------------------
            local toPatch = "local temp_blind = AnimatedSprite%(0,0,1.3,1.3, G.ANIMATION_ATLAS%['blind_chips'%], discovered and v.pos or G.b_undiscovered.pos%)"
            local patch = [[
                local temp_blind = AnimatedSprite%(0,0,1.3,1.3, %(v.atlas and G.ANIMATION_ATLAS[v.atlas] or G.ANIMATION_ATLAS['blind_chips']%), discovered and v.pos or G.b_undiscovered.pos%)
             ]]
            inject("functions/UI_definitions.lua", "create_UIBox_your_collection_blinds", toPatch, patch)
            ----
            local toPatch = "blind_choice.animation = AnimatedSprite%(0,0, 1.4, 1.4, G.ANIMATION_ATLAS%['blind_chips'%],  blind_choice.config.pos%)"
            local patch = [[
                blind_choice.animation = AnimatedSprite%(0,0,1.4,1.4, %(blind_choice.config.atlas and G.ANIMATION_ATLAS[blind_choice.config.atlas] or G.ANIMATION_ATLAS['blind_chips']%), blind_choice.config.pos%)
            ]]
            inject("functions/UI_definitions.lua", "create_UIBox_blind_choice", toPatch, patch)
            inject("functions/UI_definitions.lua", "create_UIBox_round_scores_row", toPatch, patch)
            ----
            local toPatch = "local blind_sprite = AnimatedSprite%(0, 0, 1.2,1.2, G.ANIMATION_ATLAS%['blind_chips'%], copy_table%(G.GAME.blind.pos%)%)"
            local patch = [[
                local blind_sprite = AnimatedSprite%(0, 0, 1.2, 1.2, %(G.GAME.blind.config.blind.atlas and G.ANIMATION_ATLAS%[G.GAME.blind.config.blind.atlas%] or G.ANIMATION_ATLAS['blind_chips']%), copy_table%(G.GAME.blind.pos%)%)
            ]]
            inject("functions/common_events.lua", "add_round_eval_row", toPatch, patch)
            ----
            local toPatch = "self.children.animatedSprite:set_sprite_pos%(self.config.blind.pos%)"
            local patch = [[
                if self.config.blind.atlas then
                    self.children.animatedSprite.atlas = G.ANIMATION_ATLAS[self.config.blind.atlas]
                else
                    self.children.animatedSprite.atlas = G.ANIMATION_ATLAS["blind_chips"]
                end
                self.children.animatedSprite:set_sprite_pos(self.config.blind.pos)
            ]]
            inject("blind.lua", "Blind:set_blind", toPatch, patch)
            inject("blind.lua", "Blind:load", toPatch, patch)
            -----------------------------------------------------------------------------------
            local toPatch = "for k, v in ipairs%(blind_tab%) do"
            local patch = [[
                for k, v in ipairs%(blind_tab%) do
                    if k %% 5 == 1 then
                        table.insert%(blind_matrix, {}%)
                    end
            ]]
            inject("functions/UI_definitions.lua", "create_UIBox_your_collection_blinds", toPatch, patch)
            ----
            local toPatch = "%(k==6 or k ==16 or k == 26%) and {n=G.UIT.B, config={h=0.2,w=0.5}} or nil,"
            local patch = [[
                    %(k %% 10 == 6%) and { n = G.UIT.B, config = { h = 0.2, w = 0.5 } } or nil,
                ]]
            inject("functions/UI_definitions.lua", "create_UIBox_your_collection_blinds", toPatch, patch)
            ----
            local toPatch = "%(k==5 or k ==15 or k == 25%) and {n=G.UIT.B, config={h=0.2,w=0.5}} or nil,"
            local patch = [[
                    %(k %% 10 == 5%) and { n = G.UIT.B, config = { h = 0.2, w = 0.5 } } or nil,
                ]]
            inject("functions/UI_definitions.lua", "create_UIBox_your_collection_blinds", toPatch, patch)
            ----
            local toPatch = "local extras = nil"
            local patch = [[
                    local blind_nodes = {}
                    for k, v in ipairs%(blind_matrix%) do
                        table.insert%(blind_nodes, {n = G.UIT.R, config = {align = "cm"}, nodes = blind_matrix[k]}%)
                    end
                    local extras = nil
                ]]
            inject("functions/UI_definitions.lua", "create_UIBox_your_collection_blinds", toPatch, patch)
            ----
            local toPatch = "}}%)"
            local patch = [[
                }}%)
                t = create_UIBox_generic_options%({ back_func = exit or 'your_collection', contents = {
                    {n=G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.BLACK, padding = 0.1, emboss = 0.05}, nodes={
                      {n=G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.L_BLACK, padding = 0.1, force_focus = true, focus_args = {nav = 'tall'}}, nodes={
                        {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                          {n=G.UIT.C, config={align = "cm", minw = 0.7}, nodes={
                            {n=G.UIT.T, config={text = localize%('k_ante_cap'%), scale = 0.4, colour = lighten%(G.C.FILTER, 0.2%), shadow = true}},
                          }},
                          {n=G.UIT.C, config={align = "cr", minw = 2.8}, nodes={
                            {n=G.UIT.T, config={text = localize%('k_base_cap'%), scale = 0.4, colour = lighten%(G.C.RED, 0.2%), shadow = true}},
                          }}
                        }},
                        {n=G.UIT.R, config={align = "cm"}, nodes=ante_amounts}
                    }},
                    {n=G.UIT.C, config={align = "cm"}, nodes={
                      {n=G.UIT.R, config={align = "cm"}, nodes=blind_nodes}
                    }} 
                  }}  
                }}%)
            ]]
            inject("functions/UI_definitions.lua", "create_UIBox_your_collection_blinds", toPatch, patch)
            -----------------------------------------------------------------------------------
            ---- Blind:load
            local patch = [[
                self.config.blind = G.P_BLINDS[blindTable.config_blind] or {}
                if self.config.blind.atlas then
                    self.children.animatedSprite.atlas = G.ANIMATION_ATLAS[self.config.blind.atlas]
                end
            ]]
            injectHead("blind.lua", "Blind:load", patch)
            -----------------------------------------------------------------------------------
        end,
    }
)
