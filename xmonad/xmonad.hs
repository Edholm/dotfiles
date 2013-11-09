--
-- Edholms default xmonad config - October 2012  - Laptop version
--

import XMonad 

--Layouts
import XMonad.Layout.NoBorders    (noBorders, smartBorders)
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.LayoutHints  (layoutHintsWithPlacement)
import XMonad.Layout.Grid
import XMonad.Layout.Reflect
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.ComboP
import XMonad.Layout.TwoPane
import XMonad.Layout.Tabbed

-- Other
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageHelpers  -- floatCenter
import XMonad.Hooks.ManageDocks    -- Struts management
import XMonad.Hooks.DynamicLog hiding (dzen)

import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig        -- Emacs keybindings
import XMonad.Util.Scratchpad
import XMonad.Util.Loggers
import XMonad.Util.Run

import XMonad.Actions.CycleWS
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise

import XMonad.Hooks.SetWMName

import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import ScratchPadKeys
import Utils
import Dzen

import qualified XMonad.Actions.FlexibleResize as Flex

-- Some visual settings
-- 

myTerminal           = "urxvtc"
 
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#9ac7e7"
 
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeybindings = 
  [ 
    -- Application launchers
    ("M-p"   ,spawn "gmrun"                         ),  
    ("M-r"   ,yeganesh                              ),          
    ("M-S-p" ,runOrRaisePrompt defaultXPConfig      ),        
    ("M-c"   ,spawn "firefox"                       ),
    ("M-v"   ,spawn "firefox --private"             ),
    --("M4-l"  ,spawn "slock"                       ),  -- Lock screen with Win-L
    ("M-S-t" ,spawn "thunar"                        ),
    ("M-q"   ,cleanStart                            ),

    -- Multimedia keys
    ("<XF86AudioMute>"            ,spawn "sh /home/eda/.scripts/cvol -t"         ),
    ("<XF86AudioLowerVolume>"     ,spawn "sh /home/eda/.scripts/cvol -d 5"       ),
    ("<XF86AudioRaiseVolume>"     ,spawn "sh /home/eda/.scripts/cvol -i 5"       ),
    ("<XF86AudioNext>"            ,spawn "mpc next"                              ),
    ("<XF86AudioPrev>"            ,spawn "mpc prev"                              ),
    --("<XF86ScreenBrightnessDown>"    ,spawn "sudo -n /home/eda/.scripts/brightness.sh down"  ),
    --("<XF86ScreenBrightnessUp>"      ,spawn "sudo -n /home/eda/.scripts/brightness.sh up"    ),
    ("<XF86KbdBrightnessDown>" ,spawn "asus-kbd-backlight down"            ),
    ("<XF86KbdBrightnessUp>"   ,spawn "asus-kbd-backlight up"              ),
    ("<XF86TouchpadToggle>"       ,spawn "/home/eda/.scripts/trackpad-toggle.sh" ),
    
    ("<Print>"       ,spawn "scrot"                              ),
    
    --Settings
    ("M4-<Backspace>"   ,focusUrgent                ), -- Go to urgent window
    ("M4-S-<Backspace>" ,clearUrgents               ), -- Remove urgent from window
    ("M4-<Right>"       ,nextWS                     ), -- Switch to next WS
    ("M4-<Left>"        ,prevWS                     ),
    ("M4-S-<Right>"     ,shiftToNext >> nextWS      ), -- Send and switch window to n ws
    ("M4-S-<Left>"      ,shiftToPrev >> prevWS      ),
    ("M-b"              ,sendMessage ToggleStruts   )  -- Toggle struts
                                
  ]  ++ scratchPadKeys scratchPadList

myKeyunbindings = ["M-<Return>"]

-----------------------------------------------------------------------
-- Layouts:
myLayout = avoidStruts $ onWorkspace (pbWorkspaces !! 8) (im pidgin) $ onWorkspace (pbWorkspaces !! 7) (im skype) $ smartBorders  $ pbLayout       
  where
    skype  =  Or (Title "emil.edholm - Skype™")(Title "Skype™ 2.2 (Beta) for Linux")
    pidgin =  Role "buddy_list"
    im roster   = withIM (0.20) roster (smartBorders Grid ||| Mirror tiled ||| tiled)
   
    -- default tiling algorithm partitions the screen into two panes
    tiled           = smartBorders (Tall nmaster delta ratio)
 
    -- The default number of windows in the master pane
    nmaster = 1
 
    -- Default proportion of screen occupied by master pane
    ratio   = 11/20 --0,55
 
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100
 
------------------------------------------------------------------------
-- Window rules:
myManageHook :: ManageHook
myManageHook = composeAll [ matchAny v --> a | (v,a) <- myActions ] <+> manageScratchPads scratchPadList
    where myActions = [("rdesktop"   , doFloat          )
                      , ("Xmessage"  , doCenterFloat    )
                      , ("Gmrun"     , doCenterFloat    )
                      , ("Chromium"  , doShift (pbWorkspaces !! 0)  )
                      , ("Firefox"   , doShift (pbWorkspaces !! 0)  )
                      , ("Pidgin"    , doShift (pbWorkspaces !! 8)  )
                      , ("Skype"     , doShift (pbWorkspaces !! 7)  )
                      , ("Spotify"   , doShift (pbWorkspaces !! 6)  )
                      , ("Options"   , doCenterFloat     )
                      , ("Smplayer"  , doCenterFloat     )
                      , ("emulator-arm" , doCenterFloat  )
                      ]

	
	
------------------------------------------------------------------------
-- Startup hook
 
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
---
myStartupHook = spawn "conky -c ~/.xmonad/data/conky/main" <+> setWMName "LG3D"
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
--
main = do 
    d <- spawnDzen defaultDzenXft 
		{ width = Just (Percent 50)
                , Dzen.fgColor = Just "#657b83"
                , Dzen.bgColor = Just "#002b36" 
                }
    spawnToDzen "conky -c ~/.xmonad/data/conky/dzen" conkyBar
    xmonad $ withUrgencyHookC pbUrgencyHook pbUrgencyConfig $ defaultConfig 
        { terminal           = myTerminal
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor 
        , layoutHook         = myLayout
        , handleEventHook    = fullscreenEventHook
        , logHook            = (dynamicLogWithPP $ pbPP{ ppOutput = hPutStrLn d }) <+> setWMName "LG3D"
        , manageHook         = myManageHook <+> pbManageHook-- <+> (doF W.swapDown) 
        , startupHook        = myStartupHook
        , workspaces         = pbWorkspaces
        , mouseBindings      = myMouseBindings
        } `additionalKeysP` myKeybindings `removeKeysP` myKeyunbindings
          where
            conkyBar :: DzenConf
            conkyBar = defaultDzenXft
               { alignment    = Just RightAlign
               , width        = Just (Percent 50)
               , xPosition    = Just (Percent 50)
               , Dzen.fgColor = Just "#657b83"
               , Dzen.bgColor = Just "#002b36" 
               }


myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
 
                                                        -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button4), (\w -> focus w >> mouseMoveWindow w))
       
          -- mod-button2, Raise the window to the top of the stack
    , ((modm, button5), (\w -> focus w >> windows W.shiftMaster))

    , ((modm, button3), (\w -> focus w >> Flex.mouseResizeWindow w))
       
    ]
