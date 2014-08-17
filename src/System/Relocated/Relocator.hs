{-# LANGUAGE CPP #-}
module System.Relocated.Relocator (
 relocate
) where

import System.Relocated.Records
import System.Relocated.Exec
import System.Relocated.Debug
import System.Relocated.Misc

import Control.Concurrent
import Control.Concurrent.BoundedChan as BoundedChan

import System.Path.Glob

import Data.Maybe
import Control.Monad


-- Creates a bounded thread pool, polls for file changes
relocate :: Relocator -> IO ()
relocate re = do
 case (_active re) of
  False -> do
   debug're re "inactive"
   return ()
  True -> do
   _ <- forkIO $ relocate' re
   return ()


relocate' :: Relocator -> IO ()
relocate' re = do
 debug're re "relocate: Entered"
 bch <- newBoundedChan $ _maxProc re
 let rew = RelocatorWrapper{ _relocator = re, _bch = bch }
 relocate'loop rew


relocate'loop :: RelocatorWrapper -> IO ()
relocate'loop rew = do
 launch'execPool rew
 launch'poller rew
 

launch'execPool :: RelocatorWrapper -> IO ()
launch'execPool rew = do
 debug'rew rew "launch'execPool: Entered"
 _ <- mapM_ (\_ -> forkIO (exec'worker rew)) [1..(_maxProc $ _relocator rew)]
 return ()


exec'worker :: RelocatorWrapper -> IO ()
exec'worker rew = do
 job <- BoundedChan.readChan $ _bch rew
 debug'rew rew ("job: " ++ job)
 exec (job, _relocator rew)
 exec'worker rew


launch'poller :: RelocatorWrapper -> IO ()
launch'poller rew = do
 debug'rew rew "launch'poller: Entered"
 epoch <- getTime
 globs <- mapM (\s -> glob s) $ _glob $ _relocator rew
 stats <- mapM (\s -> statFile s) $ concat globs
 relocatable <- filterM (\pair -> isRelocatable pair (_intervalElapsed $ _relocator rew) epoch) $ catMaybes stats
 let relocatable'paths = map (\pair -> fst pair) relocatable
 debug'rew rew ("relocatable paths: " ++ show relocatable'paths)
 mapM_ (\s -> BoundedChan.writeChan (_bch rew) s) relocatable'paths
 sleep $ _intervalElapsed $ _relocator rew
 launch'poller rew
