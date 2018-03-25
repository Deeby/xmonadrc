module TheNext.Key(
    mouseBindings,
    keys,
    defaultModMask
)where



import XMonad.Core                  as XMonad hiding    (keys,mouseBindings)
import qualified XMonad.Core        as XMonad           (workspaces,layoutHook,modMask)
import Data.Bits                                        ((.|.))
import System.Exit                                      (exitSuccess)
import XMonad.Hooks.ManageDocks                         (ToggleStruts(..))
import qualified XMonad.Operations  as OP
import qualified XMonad.StackSet    as W
import qualified Data.Map           as M
import qualified TheNext.DefalutApp as APP
import qualified TheNext.Param      as Param
import XMonad.Layout
import Graphics.X11.Xlib

-- | 默认关键键位，设置为super键
defaultModMask :: KeyMask
defaultModMask = mod4Mask

-- | 可以通过xmodmap确定按键绑定
-- | 在我的电脑上左右alt都是mod1
altMask = mod1Mask
letfAltMask = 0x40
rightAltMask = 0x6c
leftCtrlMask = 0x25
rightCtrlMask = 0x69
letfShiftMask = 0x32
rightShiftMask = 0x3e
superMask = mod4Mask



keys:: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys conf@XConfig {XMonad.modMask = modm} = M.fromList $

    -- 启动app
    -- 启动一个终端
    [ ((modm                , xK_Return     ), spawn APP.terminal)

    -- 启动启动器
    , ((modm                , xK_p          ), spawn APP.launcher)
    ]
    ++

    -- 关闭程序
    [ ((modm .|. shiftMask  , xK_c          ), OP.kill)
    , ((letfAltMask         , xK_F4         ), OP.kill)

    -- 下一个布局算法
    , ((modm                , xK_space      ), OP.sendMessage NextLayout)

    -- 重置布局算法
    , ((modm .|. shiftMask  , xK_space      ), OP.setLayout $ XMonad.layoutHook conf)

    -- 重新设置屏幕
    , ((modm                , xK_n          ), OP.sendMessage ToggleStruts)

    -- 锁定下一个窗口
    , ((modm                , xK_Tab        ), OP.windows W.focusDown)
    -- 出于习惯
    , ((letfAltMask         , xK_Tab        ), OP.windows W.focusDown)

    -- 锁定下一个窗口
    , ((modm                , xK_j          ), OP.windows W.focusDown)

    -- 锁定上一个窗口
    , ((modm                , xK_k          ), OP.windows W.focusUp)

    -- 锁定主窗口
    , ((modm                , xK_m          ), OP.windows W.focusMaster)

    -- 将当前窗口放入主区域
    , ((modm .|. shiftMask  , xK_Return     ), OP.windows W.swapMaster)

    -- 转换到上一个位置
    , ((modm .|. shiftMask  , xK_j          ), OP.windows W.swapDown)

    -- 转换到下一个位置
    , ((modm .|. shiftMask  , xK_k          ), OP.windows W.swapUp)

    -- 缩小主窗口
    , ((modm                , xK_h          ), OP.sendMessage Shrink)

    -- 放大主窗口
    , ((modm                , xK_l          ), OP.sendMessage Expand)

    -- 使得窗口退出float模式
    , ((modm                , xK_t          ), OP.withFocused $ OP.windows . W.sink)

    -- super + ,  增加主区域的窗口数量
    , ((modm                , xK_comma      ), OP.sendMessage (IncMasterN 1))

    -- super + . 减少主区域的窗口数量
    , ((modm                , xK_period     ), OP.sendMessage (IncMasterN (-1)))

    -- 重启xmonad
    , ((modm                , xK_q          ), spawn "xmonad --recompile && xmonad --restart")

    -- 退出xmonad
    ,((modm .|. shiftMask   , xK_q          ),  io exitSuccess)
    ]
    ++

    -- | 音量控制
    -- | 音量增加
    [((modm               , xK_F5    ), spawn $ "pactl set-sink-volume 0 -" ++ Param.volumeInterval ++ "%")
    -- | 音量减少
    ,((modm               , xK_F6    ), spawn $ "pactl set-sink-volume 0 +" ++ Param.volumeInterval ++ "%")
    -- | 立即静音
    ,((modm               , xK_F3    ), spawn "pactl set-sink-mute 0 toggle")

    ]
    ++
    -- 工作区切换
    [((m .|. modm, k), OP.windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- 多屏幕控制
    [((m .|. modm, key), OP.screenWorkspace sc >>= flip whenJust (OP.windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

mouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
mouseBindings XConfig {XMonad.modMask = modMask} = M.fromList
    -- mod-button1 %! Set the window to floating mode and move by dragging
    [ ((modMask, button1), \w -> OP.focus w >> OP.mouseMoveWindow w
                                            >> OP.windows W.shiftMaster)
    -- mod-button2 %! Raise the window to the top of the stack
    , ((modMask, button2), OP.windows . (W.shiftMaster .) . W.focusWindow)
    -- mod-button3 %! Set the window to floating mode and resize by dragging
    , ((modMask, button3), \w -> OP.focus w >> OP.mouseResizeWindow w
                                            >> OP.windows W.shiftMaster)
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]