{-# LANGUAGE RecordWildCards #-}

module System.Relocated.Exec (
 exec
) where

import System.Relocated.Records

import System.Posix.Signals
import System.Posix.Process
import System.Process
import System.Exit

import Control.Concurrent

exec :: (String, Relocator) -> IO ()
exec (source,Relocator{..}) = do
 printRelocate
 (_, _, _, r) <- createProcess $
  proc
  _relocate
  [ _name, _nameSpace, _class, source, _destination]
 waitForProcess r
 return ()
 where
  printRelocate =
   putStrLn $
    "RELOCATE: _name: " ++ _name ++ ", _nameSpace: " ++ _nameSpace ++ ", _class: " ++ _class ++ ", source: " ++ source ++ ", destination: " ++ _destination
