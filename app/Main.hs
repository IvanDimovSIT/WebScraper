module Main where

import Data.Maybe (fromMaybe)
import GHC.IO.Encoding (setLocaleEncoding)
import GHC.IO.Encoding.UTF8 (utf8)
import ResultOutput (displayResults)
import Scraper (scrapeSite)
import Text.HTML.Scalpel (URL)
import Text.Read (readMaybe)
import Types (ScraperConfig (ScraperConfig, scraperConfigDepth, scraperConfigUrl))
import Utils (trim)

defaultDepth :: Int
defaultDepth = 10

scrapeUrl :: URL
scrapeUrl = "https://quotes.toscrape.com"

main :: IO ()
main = do
  setLocaleEncoding utf8
  depth <- inputDepth
  tagInput <- inputTag
  let urlWithTag = addTagToUrl scrapeUrl tagInput
      config =
        ScraperConfig
          { scraperConfigUrl = urlWithTag,
            scraperConfigDepth = depth
          }
  putStrLn $ "Scraping \"" ++ urlWithTag ++ "\" with a depth of " ++ show depth
  scrapeResult <- scrapeSite config
  displayResults scrapeResult

inputDepth :: IO Int
inputDepth = do
  putStrLn "Enter depth (empty for max):"
  str <- getLine
  let depth = fromMaybe defaultDepth $ readMaybe $ trim str
  return depth

inputTag :: IO String
inputTag = do
  putStrLn "Enter tag to filter (empty for no filter):"
  trim <$> getLine

addTagToUrl :: URL -> String -> URL
addTagToUrl url "" = url
addTagToUrl url tag = url ++ "/tag/" ++ tag
