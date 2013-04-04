-----------------------------------------------------
--  Custom theme based on solarized colors and the --
--          "eddybob" awesome theme                --
--            By Adrian C. (anrxc)                 --
-----------------------------------------------------
-- Date modified: 2013-04-03
-- Modified by: Emil Edholm
--
-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

-- {{{ Main
theme = {}
theme.wallpaper = "/home/eda/.config/awesome/themes/eddybob/background.png"
-- }}}

-- {{{ Styles
theme.font      = "sans 8"

-- {{{ Colors
theme.fg_normal  = "#DCDCCC"
theme.fg_focus   = "#F0DFAF"
theme.fg_urgent  = "#CC9393"
theme.bg_normal  = "#3F3F3F"
theme.bg_focus   = "#1E2320"
theme.bg_urgent  = "#3F3F3F"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width  = 2
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#6F6F6F"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = 15
theme.menu_width  = 100
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = "/home/eda/.config/awesome/themes/eddybob/taglist/squarefz.png"
theme.taglist_squares_unsel = "/home/eda/.config/awesome/themes/eddybob/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = "/home/eda/.config/awesome/themes/eddybob/awesome-icon.png"
theme.menu_submenu_icon      = "/home/eda/.config/awesome/themes/default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = "/home/eda/.config/awesome/themes/eddybob/layouts/tile.png"
theme.layout_tileleft   = "/home/eda/.config/awesome/themes/eddybob/layouts/tileleft.png"
theme.layout_tilebottom = "/home/eda/.config/awesome/themes/eddybob/layouts/tilebottom.png"
theme.layout_tiletop    = "/home/eda/.config/awesome/themes/eddybob/layouts/tiletop.png"
theme.layout_fairv      = "/home/eda/.config/awesome/themes/eddybob/layouts/fairv.png"
theme.layout_fairh      = "/home/eda/.config/awesome/themes/eddybob/layouts/fairh.png"
theme.layout_spiral     = "/home/eda/.config/awesome/themes/eddybob/layouts/spiral.png"
theme.layout_dwindle    = "/home/eda/.config/awesome/themes/eddybob/layouts/dwindle.png"
theme.layout_max        = "/home/eda/.config/awesome/themes/eddybob/layouts/max.png"
theme.layout_fullscreen = "/home/eda/.config/awesome/themes/eddybob/layouts/fullscreen.png"
theme.layout_magnifier  = "/home/eda/.config/awesome/themes/eddybob/layouts/magnifier.png"
theme.layout_floating   = "/home/eda/.config/awesome/themes/eddybob/layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = "/home/eda/.config/awesome/themes/eddybob/titlebar/close_focus.png"
theme.titlebar_close_button_normal = "/home/eda/.config/awesome/themes/eddybob/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = "/home/eda/.config/awesome/themes/eddybob/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = "/home/eda/.config/awesome/themes/eddybob/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = "/home/eda/.config/awesome/themes/eddybob/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = "/home/eda/.config/awesome/themes/eddybob/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = "/home/eda/.config/awesome/themes/eddybob/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = "/home/eda/.config/awesome/themes/eddybob/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = "/home/eda/.config/awesome/themes/eddybob/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = "/home/eda/.config/awesome/themes/eddybob/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = "/home/eda/.config/awesome/themes/eddybob/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = "/home/eda/.config/awesome/themes/eddybob/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = "/home/eda/.config/awesome/themes/eddybob/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = "/home/eda/.config/awesome/themes/eddybob/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = "/home/eda/.config/awesome/themes/eddybob/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = "/home/eda/.config/awesome/themes/eddybob/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = "/home/eda/.config/awesome/themes/eddybob/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = "/home/eda/.config/awesome/themes/eddybob/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
