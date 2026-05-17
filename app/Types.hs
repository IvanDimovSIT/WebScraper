module Types where

import Data.Aeson (ToJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

data ScraperConfig = ScraperConfig
  { scraperConfigUrl :: !String,
    scraperConfigDepth :: !Int
  }
  deriving (Show)

data Quote = Quote
  { quoteText :: !Text,
    quoteAuthor :: !Text,
    quoteTags :: ![Text]
  }
  deriving (Show, Generic)

instance ToJSON Quote

data QuotePage = QuotePage
  { quotePageQuotes :: [Quote],
    quotePageNextPage :: Maybe String
  }
  deriving (Show)
