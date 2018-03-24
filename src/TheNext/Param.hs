module TheNext.Param(
    workspaces,
    focusFollowsMouse,
    clickJustFocuses,
    borderWidth,
    defaultModMask,
    normalBorderColor, 
    focusedBorderColor,
    volumeInterval
)where

import XMonad.Core(WorkspaceId)
import Graphics.X11.Xlib.Types (Dimension)
import Graphics.X11.Types

workspaces :: [WorkspaceId]
workspaces = map show [1 .. 9 :: Int]


-- | 窗口锁定不跟随鼠标移动
--   主要是为了防止触摸板误触
focusFollowsMouse :: Bool
focusFollowsMouse = False

-- | 点击之后改变锁定的窗口
clickJustFocuses :: Bool
clickJustFocuses = True

-- | 窗口边框粗细
borderWidth :: Dimension
borderWidth = 3

-- | 默认关键键位，设置为super键
defaultModMask :: KeyMask
defaultModMask = mod4Mask

-- | 确定各种状况下的窗口边框颜色
normalBorderColor, focusedBorderColor :: String
normalBorderColor  = "#000000"
focusedBorderColor = "#325A8E" -- don't use hex, not <24 bit safe


-- | 设置音量调节间隔，以百分比为单位
--   请保证这是一个数字
volumeInterval :: String
volumeInterval = "5"