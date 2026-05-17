module ResultOutput (displayResults) where

import Data.Aeson.Text (encodeToLazyText)
import Data.Text qualified as T
import Data.Text.IO qualified as T
import Data.Text.Lazy (toStrict)
import Types (Quote)

resultsFileName :: String
resultsFileName = "results.json"

displayResults :: [Quote] -> IO ()
displayResults [] = putStrLn "No results found"
displayResults quotes = do
  let json = formatResults quotes
  T.writeFile resultsFileName json
  putStrLn $ "Found " ++ show (length quotes) ++ " quotes"
  putStrLn $ "Outputtig results to \"" ++ resultsFileName ++ "\""
  putStrLn "Results:"
  T.putStrLn json

formatResults :: [Quote] -> T.Text
formatResults quotes = toStrict $ encodeToLazyText quotes
