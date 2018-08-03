{-# LANGUAGE OverloadedStrings #-}
module Main where

import Lib
import Data.Text
import Test.WebDriver
import Test.WebDriver.Session
import Test.WebDriver.Commands
import Test.WebDriver.JSON (ignoreReturn)

chromeConfig :: WDConfig
chromeConfig = useBrowser chr defaultConfig
  { wdHost = "0.0.0.0", wdPort = 4444, wdHTTPRetryCount = 50 }
  where chr = chrome

main :: IO ()
main = do
  result <- runSession chromeConfig googleIt
  print result

googleIt :: WD [Text]
googleIt = do
  openPage "https://google.com"
  searchInput <- findElem (ById "lst-ib")
  sendKeys "Glasgow\n" searchInput
  links <- findElems (ByClass "r")
  linkTexts <- mapM getText links
  closeSession
  return linkTexts
  
  

phantomConfig = useBrowser phantom defaultConfig
  where phantom =
    Phantomjs
      { phantomjsBinary = Just "/opt/phantomjs/bin/phantomjs"
      , phantomjsOptions =
        [ "/opt/phantomjs/src/ghostdriver/main.js"
        , "--webdriver=8910"
        , "--webdriver-selenium-grid-hub=http://127.0.0.1:4444"
        , "--webdriver-logfile=/var/log/phantomjs/webdriver.log"
        ]
      }

chromiumConfig :: WDConfig
chromiumConfig =
  useBrowser chr defaultConfig
    { wdHost = "0.0.0.0", wdPort = 4444, wdHTTPRetryCount = 50 }
  where chr = chrome
              { chromeBinary = Just "/usr/bin/chromium"
              , chromeOptions = ["--headless"
                                , "--mute-audio"
                                , "--disable-gpu"
                                , "--no-sandbox"
                                ]
              }
