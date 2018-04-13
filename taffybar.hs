import System.Information.CPU2                      (getCPULoad)
import System.Information.Memory                    (parseMeminfo,memoryUsedRatio)
import System.Taffybar.FreedesktopNotifications     (notifyAreaNew,defaultNotificationConfig)
import System.Taffybar.SimpleClock                  (textClockNew)
import System.Taffybar.Battery                      (batteryBarNew)
import System.Taffybar.MPRIS                        (mprisNew,defaultMPRISConfig)
import System.Taffybar.NetMonitor                   (netMonitorNewWith)
import System.Taffybar.Widgets.VerticalBar          (defaultBarConfig,BarConfig(..))
import Text.Printf                                  (printf)
import System.Process                               (readProcess)
import System.Taffybar.Systray                      (systrayNew)
import TheNext.Bar.Unit                             (unitBase,pager)
import System.Taffybar       as Taffybar

getVolume :: IO String
getVolume = do
  cmd <- readProcess "pactl" ["list","sinks"] []
  return $ words (lines cmd !! 9) !! 3

memCallback :: IO [Double]
memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

toInt :: Double -> Int
toInt = round

makeColor :: [Double]-> String
makeColor color = printf "#%02x%02x%02x" (toInt(head color * 255)) (toInt(color!!1 * 255)) (toInt(last color * 255))

computerInfo ::IO String
computerInfo = do
  cpu <- getCPULoad "cpu"
  mem <- memCallback
  let
    cpuBar = "<span font='monospace 9' fgcolor='"++makeColor [head cpu,1.0-head cpu,0.0]++"'>cpu"  ++ printf "%02.0f"(head cpu * 100) ++ "%</span>"
    memBar = "<span font='monospace 9' fgcolor='"++makeColor [head mem,1.0-head mem,0.0]++"'>mem"  ++ printf "%02.0f"(head mem * 100) ++ "%</span>"
  return (cpuBar ++ "\n" ++ memBar)

batteryConfig :: BarConfig
batteryConfig =
  defaultBarConfig colorFunc
  where
    colorFunc pct = (1-pct,pct,0)

main :: IO ()
main = do
  let clock = textClockNew Nothing "<span font='monospace 9' fgcolor='#fff'>%m-%d %u\n%H:%M 周</span>" 30
      networkWire = netMonitorNewWith 1 "wlp3s0" 2 "<span font='monospace 10' fgcolor='#fff'>$inKB$kb/s▼\n$outKB$kb/s▲</span>"
      note = notifyAreaNew defaultNotificationConfig
      battery = batteryBarNew batteryConfig 10
      mpris = mprisNew defaultMPRISConfig
      info = unitBase computerInfo
      volume = unitBase getVolume
      tray = systrayNew
  Taffybar.taffybarMain Taffybar.defaultTaffybarConfig
                                    { Taffybar.barHeight     = 28
                                    , Taffybar.monitorNumber = 0
                                    , Taffybar.startWidgets  = [pager,note]
                                    , Taffybar.endWidgets    = [tray,battery,clock,mpris,info,volume,networkWire]
                                    , Taffybar.widgetSpacing = 5
                                    }
