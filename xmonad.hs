import XMonad
import XMonad.Actions.Volume
import XMonad.Util.Dzen
import XMonad.Util.EZConfig
import Data.Time (getZonedTime, formatTime)
import System.Locale (defaultTimeLocale)

alert :: String -> X ()
alert = dzenConfig centered
  where
    centered = onCurr (center 200 66) -- Sorry about the magic numbers
               >=> font "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*"
               >=> addArgs ["-fg", "#80c0ff"] -- Light blue
               >=> addArgs ["-bg", "#000040"] -- Dark blue

showAlert :: Show a => a -> X ()
showAlert = alert . show

roundedAlert :: RealFrac a => a -> X ()
roundedAlert = showAlert . round

time :: IO String
time = formatTime defaultTimeLocale "%I:%M" `fmap` getZonedTime

main :: IO ()
main = xmonad $ defaultConfig
     { modMask = mod4Mask
     , terminal = "urxvtc"
     }
     `additionalKeysP`
     [ ("C-M-l", spawn "xscreensaver-command --lock")
     , ("<F1>", spawn "dmenu_run -b")
     , ("<F8>", lowerVolume 4 >>= roundedAlert)
     , ("<F9>", raiseVolume 4 >>= roundedAlert)
     , ("<F4>", (io time) >>= alert)
     ]
