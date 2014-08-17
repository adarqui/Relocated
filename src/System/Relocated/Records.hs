{-# LANGUAGE DeriveGeneric #-}

module System.Relocated.Records (
 Elapsed,
 Root (..),
 Relocator (..),
 RelocatorWrapper (..)
) where


import GHC.Generics
import Data.Aeson
import Control.Concurrent.BoundedChan


type Elapsed = Int


data Root = Root {
  _options :: Options,
  _relocators :: [Relocator]
 } deriving (Show, Read, Generic)

instance FromJSON Root
instance ToJSON Root


data Options = Options {
  _daemon :: Bool
 } deriving (Show, Read, Generic)

instance FromJSON Options
instance ToJSON Options


data Relocator = Relocator {
  _active :: Bool,
  _maxProc :: Int,
  _intervalPoll :: Int,
  _intervalElapsed :: Int,
  _name :: String,
  _nameSpace :: String,
  _class :: String,
  _destination :: String,
  _glob :: [String],
  _relocate :: String
 } deriving (Show, Read, Generic)

instance FromJSON Relocator
instance ToJSON Relocator


data RelocatorWrapper = RelocatorWrapper {
 _relocator :: Relocator,
 _bch :: BoundedChan FilePath
}
