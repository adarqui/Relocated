{-# LANGUAGE ScopedTypeVariables #-}

module System.Relocated.Misc (
 sleep,
 toCT,
 getTime,
 diffTimes,
 withinRange,
 statFile,
 isRelocatable
) where

import System.Relocated.Records

import Control.Concurrent
import Control.Monad
import System.Time
import Data.Time
import System.Posix.Types
import System.Posix.Time
import System.Posix.Files

import qualified Control.Exception as E


sec :: Int -> Int
sec n = n * 1000000


sleep :: Int -> IO ()
sleep n = threadDelay $ sec n


toCT :: EpochTime -> ClockTime
toCT et = TOD (truncate (toRational et)) 0


getTime :: IO ClockTime
getTime = liftM toCT epochTime


diffTimes :: ClockTime -> ClockTime -> Int
diffTimes a b = tdSec $ diffClockTimes a b


withinRange :: ClockTime -> ClockTime -> Int -> Int -> Bool
withinRange a b c d = d <= (abs (diffTimes a b))


statFile :: FilePath -> IO (Maybe (FilePath, FileStatus))
statFile s = do
 E.catch (getFileStatus s >>= \x -> return (Just (s, x)))
  (\(e :: E.SomeException) -> return Nothing)


isRelocatable :: (FilePath, FileStatus) -> Elapsed -> ClockTime -> IO Bool
isRelocatable (name,status) elapsed epoch = do
 return $ isRegularFile status && withinRange epoch mtime 0 elapsed
 where
  mtime = toCT $ statusChangeTime status
