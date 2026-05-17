{-# LANGUAGE OverloadedStrings #-}

module Scraper (scrapeSite) where

import Data.Maybe (fromMaybe, listToMaybe)
import Data.Text (Text, stripPrefix, stripSuffix, unpack)
import Text.HTML.Scalpel (Scraper, URL, attr, chroots, hasClass, scrapeURL, text, texts, (@:))
import Types
  ( Quote (..),
    QuotePage (..),
    ScraperConfig (scraperConfigDepth, scraperConfigUrl),
  )

scrapeSite :: ScraperConfig -> IO [Quote]
scrapeSite config = scrapeSiteLoop baseUrl baseUrl depth
  where
    baseUrl = scraperConfigUrl config
    depth = scraperConfigDepth config

scrapeSiteLoop :: URL -> URL -> Int -> IO [Quote]
scrapeSiteLoop !baseUrl !url !depth
  | depth <= 0 = return []
  | otherwise = do
      putStrLn $ "Following URL:" ++ url
      page <- scrapePage url
      let quotes = quotePageQuotes page
          maybeNextPage = quotePageNextPage page
      case maybeNextPage of
        Just nextPage -> do
          let newUrl = baseUrl ++ nextPage
              newDepth = depth - 1
          (++ quotes) <$> scrapeSiteLoop baseUrl newUrl newDepth
        Nothing -> do
          putStrLn "No more pages found"
          return quotes

scrapePage :: URL -> IO QuotePage
scrapePage url = do
  maybePage <- scrapeURL url scraperProcessor
  case maybePage of
    Just page -> return page
    Nothing -> do
      putStrLn $ "Can't connect to " ++ url
      return QuotePage {quotePageQuotes = [], quotePageNextPage = Nothing}

scraperProcessor :: Scraper Text QuotePage
scraperProcessor = do
  quotes <- chroots ("div" @: [hasClass "quote"]) quoteProcessor
  nextPage <- nextPageProcessor
  return
    QuotePage
      { quotePageQuotes = quotes,
        quotePageNextPage = unpack <$> nextPage
      }

nextPageProcessor :: Scraper Text (Maybe Text)
nextPageProcessor = do
  let container = chroots ("li" @: [hasClass "next"])
  links <- container $ attr "href" "a"
  return $ listToMaybe links

quoteProcessor :: Scraper Text Quote
quoteProcessor = do
  qText <- trimQuotes <$> text ("span" @: [hasClass "text"])
  qAuthor <- text $ "small" @: [hasClass "author"]
  qTags <- texts $ "a" @: [hasClass "tag"]
  return $
    Quote
      { quoteText = qText,
        quoteAuthor = qAuthor,
        quoteTags = qTags
      }

trimQuotes :: Text -> Text
trimQuotes quote = fromMaybe "" $ stripPrefix "“" =<< stripSuffix "”" quote
