{-# LANGUAGE CPP #-}
module System.Relocated.Debug (
 debug,
 debug're,
 debug'rew
) where

import System.Relocated.Records

debug'rew :: RelocatorWrapper -> String -> IO ()
debug'rew rew = debug're (_relocator rew)

debug're :: Relocator -> String -> IO ()
debug're re s = debug $ (_name re) ++ " : " ++ (_nameSpace re) ++ " => " ++ s

debug :: String -> IO ()
debug s = do
#ifdef __DEBUG__
 putStrLn s
#endif
 return ()
