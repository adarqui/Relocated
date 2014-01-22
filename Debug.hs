{-# LANGUAGE OverloadedStrings #-}

module Debug (
	dump,
	)

where

import RelocateInc
import Data.List
import Data.Maybe

dump = dumpJson

dumpSep banner =
	putStrLn $
		"------------------- " ++ banner ++ " -------------------"

-- Expects 'wrap'
dumpJson :: Maybe Wrap -> IO (Maybe Wrap)
dumpJson c = do
	dumpRoot $ root $ fromJust c
	return c
				

-- Expects 'root'
dumpRoot :: Root -> IO Root
dumpRoot r = do
				dumpSep "Relocated-HS!"
				putStrLn $ "Daemon: " ++ (show $ daemon r :: String)
				putStrLn $ "Relocators: " ++ (show $ length $ relocators r :: String)
				dumpRelocators $ relocators r
				return r

-- Expects '[relocators]'
dumpRelocators :: [Relocator] -> IO [Relocator]
dumpRelocators r = mapM_ dumpRelocator r >> return r


-- Expects 'relocator'
dumpRelocator :: Relocator -> IO Relocator
dumpRelocator rel = do
				dumpSep $ name rel
				putStrLn $ "Active:" ++ (show $ active rel :: String)
				putStrLn $ "Name:" ++ (show $ name rel :: String)
				putStrLn $ "NameSpace:" ++ (show $ namespace rel :: String)
				putStrLn $ "Class:" ++ (show $ xclass rel :: String)
				putStrLn $ "Destination:" ++ (show $ destination rel :: String)
				putStrLn $ "Glob:" ++ (show $ glob rel :: String)
				putStrLn $ "Relocate:" ++ (show $ relocate rel :: String)
				putStrLn ""
				return rel
