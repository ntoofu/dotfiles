--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- about xmobar
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import System.IO


-- about layout
import XMonad.Layout
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.TwoPane
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Util.WorkspaceCompare
import XMonad.Actions.CycleWS
import XMonad.Actions.NoBorders
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
-- myTerminal      = "xterm"
myTerminal      = "urxvt"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#22cccc"
myFocusedBorderColor = "#ff0000"

myShiftnview = \s -> (windows . W.shift) s >> (windows . W.view) s
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm ,              xK_Return), spawn $ XMonad.terminal conf)
    , ((modm .|. shiftMask, xK_Return), moveTo Next EmptyWS >> (spawn $ XMonad.terminal conf))

    -- launch dmenu
    --, ((modm,               xK_e     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    -- launch gmrun
    , ((modm              , xK_e     ), spawn "dmenu_run")
    , ((modm .|. shiftMask, xK_e     ), moveTo Next EmptyWS >> spawn "dmenu_run")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_r     ), refresh)

    -- Move focus to the next/prev window
    , ((modm .|. shiftMask, xK_Tab   ), windows W.focusDown)
    , ((modm,               xK_Tab   ), windows W.focusUp)

    -- Move focus
    , ((modm,               xK_h     ), sendMessage $ Go L )
    , ((modm,               xK_j     ), sendMessage $ Go D )
    , ((modm,               xK_k     ), sendMessage $ Go U )
    , ((modm,               xK_l     ), sendMessage $ Go R )

    -- Swap window
    , ((modm .|. shiftMask, xK_h     ), sendMessage $ Swap L )
    , ((modm .|. shiftMask, xK_j     ), sendMessage $ Swap D )
    , ((modm .|. shiftMask, xK_k     ), sendMessage $ Swap U )
    , ((modm .|. shiftMask, xK_l     ), sendMessage $ Swap R )


    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_m     ), windows W.swapMaster)

    -- Toggle workspace
    , ((modm              , xK_n     ), moveTo Next HiddenNonEmptyWS )
    , ((modm              , xK_p     ), moveTo Prev HiddenNonEmptyWS )
    , ((modm              , xK_a     ), moveTo Next EmptyWS )

    -- Send focus window to other workspace
    , ((modm .|. shiftMask, xK_n     ), shiftTo Next HiddenNonEmptyWS >> moveTo Next HiddenNonEmptyWS)
    , ((modm .|. shiftMask, xK_p     ), shiftTo Prev HiddenNonEmptyWS >> moveTo Next HiddenNonEmptyWS)

    , ((modm .|. shiftMask, xK_a     ), do
   					t <- findWorkspace getSortByIndex Next EmptyWS 1
   					(windows . W.shift) t
   					(windows . W.greedyView) t)
    , ((modm .|. shiftMask, xK_z     ), shiftTo Prev EmptyWS )

    -- Toggle screen
    , ((modm ,              xK_f     ), nextScreen)
    , ((modm              , xK_b     ), prevScreen)

    -- Send focus window to other screen
    , ((modm .|. shiftMask, xK_f     ), shiftNextScreen >> nextScreen)
    , ((modm .|. shiftMask, xK_b     ), shiftPrevScreen >> prevScreen)

    -- Swap WS on screen
    , ((modm ,             xK_s     ), swapNextScreen)
    , ((modm .|. shiftMask, xK_s     ), swapPrevScreen)

    -- Reset the relation between screen and workspace
    , ((modm ,              xK_0     ), do
    					screenWorkspace 1 >>= flip whenJust (windows.W.view)
    					(windows . W.greedyView) "2"
    					screenWorkspace 0 >>= flip whenJust (windows.W.view)
    					(windows . W.greedyView) "1" )

    -- Shrink the master area
    , ((modm .|. shiftMask, xK_comma ), sendMessage Shrink)
    , ((modm ,              xK_comma ), sendMessage MirrorShrink)

    -- Expand the master area
    , ((modm .|. shiftMask, xK_period), sendMessage Expand)
    , ((modm ,              xK_period), sendMessage MirrorExpand)

    -- Push window back into tiling
    , ((modm .|. shiftMask, xK_r     ), withFocused $ windows . W.sink)

    -- Toggle current borders
    , ((modm ,              xK_w     ), withFocused toggleBorder )
	
    -- toggle window to fullscreen
    --, ((modm,               xK_f     ), sendMessage $ JumpToLayout "FULL" )

    -- Increment the number of windows in the master area
    , ((modm              , xK_i ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_o ), sendMessage (IncMasterN (-1)))

    -- for Sublayout
    , ((modm .|. controlMask, xK_h     ), sendMessage $ pullGroup L )
    , ((modm .|. controlMask, xK_j     ), sendMessage $ pullGroup D )
    , ((modm .|. controlMask, xK_k     ), sendMessage $ pullGroup U )
    , ((modm .|. controlMask, xK_l     ), sendMessage $ pullGroup R )
    , ((modm .|. controlMask, xK_i     ), withFocused ( sendMessage . MergeAll ))
    , ((modm .|. controlMask, xK_o     ), withFocused ( sendMessage . UnMerge ))
    , ((modm .|. controlMask, xK_g     ), withFocused ( sendMessage . UnMergeAll ))
    , ((modm                , xK_t     ), onGroup W.focusDown')
    , ((modm .|. shiftMask  , xK_t     ), onGroup W.focusUp')
    , ((modm                , xK_semicolon ), onGroup W.focusDown')
    , ((modm .|. shiftMask  , xK_semicolon ), onGroup W.focusUp')

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm .|. shiftMask, xK_w     ), sendMessage ToggleStruts)

    -- Capture screen
    , ((modm              , xK_Print ), spawn "import -window root ~/capture_$(date +%Y%m%d-%H%M%S).png")

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_Escape     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. controlMask, xK_r     ), spawn "xmonad --recompile; xmonad --restart")

    -- Xf86 keys
    , ((0  , 0x1008FF02   ), spawn "xbacklight + 5" )
    , ((0  , 0x1008FF03   ), spawn "xbacklight - 5" )
    , ((0  , 0x1008FF11   ), spawn "pulseaudio-ctl down" )
    , ((0  , 0x1008FF12   ), spawn "pulseaudio-ctl mute" )
    , ((0  , 0x1008FF13   ), spawn "pulseaudio-ctl up" )
    ]



------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
--myLayout = windowNavigation( ResizableTall 1 (3/100) (1/2) []||| ThreeCol 1 (3/100) (1/3) ||| Full ||| (combineTwo (ResizableTall 1 (3/100) (1/2) []) simpleTabbed (ResizableTall 1 (3/100) (1/2) [])) )
--myLayout =  avoidStruts $ windowNavigation $ subTabbed $ ( (ResizableTall 1 (3/100) (1/2) [])||| ThreeCol 1 (3/100) (1/3) ||| Mgn.magnifiercz 1.0 (Grid) ||| combineTwo (ResizableTall 1 (3/100) (3/4) []) (Mgn.magnifiercz 1.97 (Grid)) (tiled) ||| Full )
myLayout =  avoidStruts $ windowNavigation $ subTabbed $ ( (ResizableTall 1 (3/100) (1/2) [])||| ThreeCol 1 (3/100) (1/3) ||| Full )
--myLayout = tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 2/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
-- myManageHook = composeAll
myManageHook = manageDocks <+> composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
-- myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
	xmproc <- spawnPipe "xmobar"
	xmonad $ defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
--        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook = dynamicLogWithPP xmobarPP
		{ ppOutput = hPutStrLn xmproc
		, ppTitle = xmobarColor "green" "" . shorten 50
		},
        startupHook        = myStartupHook
    }


-- Dzen Menu bar

