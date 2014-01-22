{-# LANGUAGE OverloadedStrings #-}

module Relocate (
	load,
	findRelocator,
	createRelPoint,
	createThreadPair,
	sanitizeRelocator,
	relPoints2Pairs,
	relPoint2Pair
	) where

import Data.Aeson
import Data.Text
import Control.Concurrent
import Control.Applicative
import Control.Monad (forever, mzero, liftM, filterM, mapM)
import qualified Data.ByteString.Lazy as BSL
import GHC.Generics
import Data.Maybe
import qualified Data.List as DL
import qualified System.Path.Glob as GLOB
import System.Time
import System.Posix.Files

import RelocateInc
import HMisc.Misc
import HMisc.Stat
import HMisc.Time
import HMisc.StatInc


createRelPoint a b = RelPoint { rel=a, files=b }


createRelPair a b = RelPair { r=a, fp=b }


createThreadPair a b = ThreadPair { tr=a, tf=b }


findRelocator :: Relocator -> IO RelPoint
findRelocator r = liftM (createRelPoint r) (findRelocatorFiles r)


findRelocatorFiles :: Relocator -> IO [FilePath]
findRelocatorFiles r = findGlobs (glob r)


findGlobs :: [String] -> IO [FilePath]
findGlobs = concatMapM GLOB.glob


loadFile = BSL.readFile


loadJson :: BSL.ByteString -> Maybe Wrap


loadJson = decode


load file = Control.Monad.liftM loadJson (loadFile file)


sanitizeRelocator :: Relocator -> Maybe Relocator
sanitizeRelocator r = if active r then Just r else Nothing


relPoints2Pairs :: [RelPoint] -> Elapsed -> ClockTime -> IO [RelPair]
relPoints2Pairs relpoints elapsed epoch =
	mapM (\x -> relPoint2Pair x elapsed epoch) relpoints


relPoint2Pair :: RelPoint -> Elapsed -> ClockTime -> IO RelPair
relPoint2Pair relpoint elapsed epoch = do
	stats <- statFiles _files
	m <- filterM (\x -> isRelocatable x elapsed epoch) stats
	return (createRelPair _rel m)
	where
		_rel = rel relpoint
		_files = files relpoint


isRelocatable :: FilePair -> Elapsed -> ClockTime -> IO Bool
isRelocatable fp elapsed epoch = return(isRegularFile _stat && withinRange epoch mtime 0 elapsed)
	where
		_stat = stat fp
		mtime = toCT $ modificationTime _stat
