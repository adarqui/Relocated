import System.Relocated

import System.Environment
import Control.Monad


-- step3: launch relocators
step3'relocator :: Relocator -> IO ()
step3'relocator re = do
 debug "step3'relocator: Entered"
 relocate re


-- step2: analyze root object
step2'root :: Root -> IO ()
step2'root r = do
 debug "step2'root: Entered"
 mapM_ (\re -> step3'relocator re) $ _relocators r


-- step1: read configs
step1'configs :: String -> IO ()
step1'configs s = do
 debug $ "step1'configs: Entered => " ++ s
 config <- load s
 case config of
  (Left err) -> putStrLn $ "FATAL ERROR PARSING CONFIG: " ++ err
  (Right root) -> do
   debug $ "step1'configs: Config => " ++ show root
   step2'root root


inputLoop :: IO ()
inputLoop = getLine >> inputLoop


main :: IO ()
main = do
 argv <- getArgs
 case (null argv) of
  True -> step1'configs "config.json"
  _ -> step1'configs $ head argv
 inputLoop
