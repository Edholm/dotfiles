{-# OPTIONS -fno-warn-missing-signatures #-}
-------------------------------------------------------------------------------
-- |
-- Module      :  Utils
-- Copyright   :  (c) Patrick Brisbin 2010 
-- License     :  as-is
--
-- Maintainer  :  pbrisbin@gmail.com
-- Stability   :  unstable
-- Portability :  unportable
--
-- Parts of my config that are general-purpose enough to be useful 
-- outside the scope of my config.
--
-- This could be imported and used on its own without having to use \"my\" 
-- config entirely.
--
-- haddocks: <http://pbrisbin.com/static/docs/haskell/xmonad-config/Utils.html>
--
-------------------------------------------------------------------------------

module Utils 
    ( 
    -- * Config entries
      pbWorkspaces
    , pbManageHook
    , pbLayout
    , pbPP

    -- * Urgency
    , SpawnSomething(..)
    , pbUrgencyHook
    , pbUrgencyConfig

    -- * Utilities
    , matchAny
    , name
    , role
    , hideNSP
    , yeganesh
    , runInTerminal
    , spawnInScreen
    , cleanStart
    ) where

import XMonad

import XMonad.Hooks.DynamicLog      (dzenPP, PP(..), pad, dzenColor)
import XMonad.Hooks.ManageDocks     (manageDocks, avoidStruts)
import XMonad.Hooks.ManageHelpers   (isDialog, isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.UrgencyHook     (UrgencyHook(..), UrgencyConfig(..), urgencyConfig, SuppressWhen(Focused))
import XMonad.Layout.LayoutHints    (layoutHints)
import XMonad.Util.WorkspaceCompare (getSortByXineramaRule)
import Data.List                    (elemIndex, isInfixOf)

import qualified XMonad.StackSet as W

myIconPath           = "/home/eda/.xmonad/xbm_icons/subtle/"
-- | The setup I like: a main, web and chat plus the rest numbered.
pbWorkspaces :: [WorkspaceId]
pbWorkspaces = ["^i(" ++ myIconPath  ++ "tv.xbm) 1-web", "^i(" ++ myIconPath  ++ "code.xbm) 2-foo", "3-bar"] ++ map show [4..5 :: Int] ++ 
               [
                "6-irc", 
                "^i(" ++ myIconPath  ++ "spotify.xbm) 7-spotify", 
                "8-Skype", 
                "^i(" ++ myIconPath  ++ "mail.xbm) 9-Pidgin"
               ]

-- | Default plus docks, dialogs and smarter full screening.
pbManageHook :: ManageHook
pbManageHook = composeAll $ concat
    [ [ manageDocks                                      ]
    , [ manageHook defaultConfig                         ]
    , [ isDialog     --> doCenterFloat                   ]
    , [ isFullscreen --> doF W.focusDown <+> doFullFloat ]
    ]

-- | Match a string against any one of a window's class, title, name or 
--   role.
matchAny :: String -> Query Bool
matchAny x = foldr ((<||>) . (=? x)) (return False) [className, title, name, role]

-- | Match against @WM_NAME@.
name :: Query String
name = stringProperty "WM_NAME"

-- | Match against @WM_ROLE@.
role :: Query String
role = stringProperty "WM_ROLE"

-- Default plus hinting and avoidStruts.
pbLayout = avoidStruts . layoutHints $ layoutHook defaultConfig

-- | @dzenPP@ plus sorting by Xinerama, softer title/layout colors, 
--   hiding of the NSP workspace and a nice @ppLayout@ if you happen to 
--   use @'pbLayout'@.
--
-- > logHook = dynamicLogWithPP $ pbPP { ppOutput = hPutStrLn d }
--
pbPP :: PP
pbPP = dzenPP
    { ppCurrent = dzenColor "#eee8d5" "#586e75" . pad
    , ppHidden = hideNSP . wrapClickWorkspace
    , ppUrgent = dzenColor "#eee8d5" "#dc322f" . hideNSP . wrapClickWorkspace . pad
    --, ppSort   = getSortByXineramaRule
    , ppVisible= wrapClickWorkspace
    , ppTitle  = dzenColor "#b58900" "" . pad . wrapClickTitle
    , ppLayout = dzenColor "#eee8d5" "" .  pad . wrapClickLayout . \s ->
        case s of
            "Hinted Tall"             -> "^i(" ++ myIconPath ++ "tall.xbm)"
            "Hinted Mirror Tall"      -> "^i(" ++ myIconPath ++ "mtall.xbm)"
            "Hinted Full"             -> "^i(" ++ myIconPath ++ "full2.xbm)"
            "ReflectX IM Grid"        -> "^i(" ++ myIconPath ++ "grid.xbm) " ++ "^i(" ++ myIconPath ++ "dotbox.xbm)"
            "ReflectX IM Tall"        -> "^i(" ++ myIconPath ++ "tall.xbm) " ++ "^i(" ++ myIconPath ++ "dotbox.xbm)"
            "ReflectX IM Mirror Tall" -> "^i(" ++ myIconPath ++ "mtall.xbm) " ++ "^i(" ++ myIconPath ++ "dotbox.xbm)"
            _                      -> pad s
    }
          where
                wrapClickLayout l = "^ca(1,xdotool key alt+space)^ca(3,xdotool key alt+shift+space)" ++ l ++ "^ca()^ca()"                       --clickable layout
		wrapClickTitle t = "^ca(1,xdotool key alt+m)^ca(2,xdotool key alt+c)^ca(3,xdotool key alt+shift+m)" ++ t ++ "^ca()^ca()^ca()" --clickable title
		wrapClickWorkspace ws = "^ca(1," ++ xdo "w;" ++ xdo index ++ ")" ++ "^ca(3," ++ xdo "w;" ++ xdo index ++ ")" ++ ws ++ "^ca()^ca()"  --clickable workspaces
			where
				wsIdxToString Nothing = "1"
				wsIdxToString (Just n) = show (n+1)
				index = wsIdxToString (elemIndex ws pbWorkspaces)
				xdo key = "xdotool key alt+" ++ key


-- | Hide the "NSP" workspace.
hideNSP :: WorkspaceId -> String
hideNSP ws = if isInfixOf "NSP" ws then "" else pad ws
         

-- | Spawn any command on urgent; discards the workspace information.
data SpawnSomething = SpawnSomething String deriving (Read, Show)

instance UrgencyHook SpawnSomething where
    urgencyHook (SpawnSomething s) _ = spawn s

-- | Ding! on urgent via aplay and a sound from Gajim.
pbUrgencyHook :: SpawnSomething
pbUrgencyHook = SpawnSomething "aplay ~/.xmonad/data/sounds/message2.wav"

-- | Default but still show urgent on visible non-focused workspace.
--
-- > xmonad $ withUrgencyHookC pbUrgencyHook pbUrgencyConfig $ defaultConfig
--
pbUrgencyConfig :: UrgencyConfig
pbUrgencyConfig = urgencyConfig { suppressWhen = Focused }

-- | Spawns yeganesh <http://dmwit.com/yeganesh/>, set the environment 
--   variable @$DMENU_OPTIONS@ to customize dmenu appearance, this is a 
--   good @M-p@ replacement.
yeganesh :: MonadIO m => m ()
yeganesh = spawn "exe=`yeganesh -x -- -fn -xos4-terminus-medium-r-normal-*-20-*-*-*-*-*-*-* $DMENU_OPTIONS` && eval \"exec $exe\""

-- | Execute a command in the user-configured terminal.
--
-- > runInTerminal [ "screen", "-S", "my-session", "-R", "-D", "my-session" ]
--
runInTerminal :: [String] -> X ()
runInTerminal args = asks config >>= \(XConfig { terminal = t }) -> spawn $ unwords (t:args)

-- | Spawn in accordance with <http://pbrisbin.com/posts/screen_tricks>.
spawnInScreen :: String -> X ()
spawnInScreen c = runInTerminal [ "-title", c, "-e bash -ci", "\"SCREEN_CONF=" ++ c, "screen -S", c, "-R -D", c ++ "\"" ]

-- | Kill (@-9@) any running dzen and conky processes before executing 
--   the default restart command, this is a good @M-q@ replacement.
cleanStart :: MonadIO m => m ()
cleanStart = spawn $ "for pid in `pgrep conky`; do kill -9 $pid; done && "
                  ++ "for pid in `pgrep dzen2`; do kill -9 $pid; done && "
                  ++ "xmonad --recompile && xmonad --restart"
