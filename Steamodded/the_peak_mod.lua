--- STEAMODDED HEADER
--- MOD_NAME: the peak mod
--- MOD_ID: THE_MOD_THAT_SWITCHES_THE_PLAY_AND_THE_QUIT_BUTTONS_IN_THE_MAIN_MENU_SO_THAT_EVERYONE_WILL_PRESS_THE_QUIT_BUTTON_ON_ACCIDENT
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: peak modding

if not G.F_QUIT_BUTTON then
    sendWarnMessage("Quit button does not exist!")
    return
end

local main_menu_ref = create_UIBox_main_menu_buttons
function create_UIBox_main_menu_buttons()
    local text_scale = 0.45
    local t = main_menu_ref()
    t.nodes[1].nodes[1].nodes[1] = UIBox_button{button = 'quit', colour = G.C.BLUE, minw = 3.65, minh = 1.55, label = {localize('b_quit_cap')}, scale = text_scale * 2, col = true}
    t.nodes[1].nodes[1].nodes[2].nodes[3] = UIBox_button{id = 'main_menu_play', button = not G.SETTINGS.tutorial_complete and "start_run" or "setup_run", colour = G.C.RED, minw = 2.65, minh = 1.35, label = {localize('b_play_cap')}, scale = text_scale*1.2, col = true}
    return t
end