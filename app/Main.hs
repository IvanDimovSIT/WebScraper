module Main where

import Data.Maybe (fromMaybe, listToMaybe)
import GHC.IO.Encoding (setLocaleEncoding)
import GHC.IO.Encoding.UTF8 (utf8)
import ResultOutput (displayResults)
import Scraper (scrapeSite)
import System.Environment (getArgs)
import Text.Read (readMaybe)
import Types (ScraperConfig (ScraperConfig, scraperConfigDepth, scraperConfigUrl))

defaultDepth :: Int
defaultDepth = 10

scrapeUrl :: String
scrapeUrl = "https://quotes.toscrape.com"

main :: IO ()
main = do
  setLocaleEncoding utf8
  args <- getArgs
  let depth = fromMaybe defaultDepth $ readMaybe =<< listToMaybe args
      config =
        ScraperConfig
          { scraperConfigUrl = scrapeUrl,
            scraperConfigDepth = depth
          }
  putStrLn $ "Scraping \"" ++ scrapeUrl ++ "\" with a depth of " ++ show depth
  putStrLn "You can pass the depth via a CMD argument"
  scrapeResult <- scrapeSite config
  displayResults scrapeResult
