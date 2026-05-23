module Utils where

import Data.Char (isSpace)

trim :: String -> String
trim str = reverse $ dropSpaces $ reverse $ dropSpaces str
  where
    dropSpaces = dropWhile isSpace

doIfNothing :: Maybe a -> IO a -> IO a
doIfNothing (Just x) _ = return x
doIfNothing Nothing action = action
