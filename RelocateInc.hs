{-# LANGUAGE OverloadedStrings #-}

module RelocateInc (
	ThreadChan,
	Elapsed,
	Wrap(..),
	Root(..),
	Relocator(..),
	RelPoint(..),
	RelPair(..),
	ThreadPair(..),
	ThreadCTX,
	) where

import Data.Aeson
import Data.Text
import Control.Applicative
import Control.Monad (forever, mzero, liftM)
import Control.Concurrent.BoundedChan
import Data.Maybe
import HMisc.StatInc


type Elapsed = Int


data Wrap = Wrap
		{ root :: Root
		} deriving (Show)


data Root = Root
		{ daemon :: Bool
		, relocators :: [Relocator]
		} deriving (Show, Read)


data Relocator = Relocator
		{ active :: Bool
		, maxProc :: Int
		, intervalPoll :: Int
		, intervalElapsed :: Int
		, name :: String
		, namespace :: String
		, xclass :: String
		, destination :: String
		, glob :: [String]
		, relocate :: String
		} deriving (Show, Read)


instance FromJSON Wrap where
	parseJSON (Object v) = Wrap <$>
		v .: "root"
	parseJSON _ = mzero


instance FromJSON Root where
	parseJSON (Object v) = Root <$>
		v .: "Daemon" <*>
		v .: "Relocators"
	parseJSON _ = mzero


instance FromJSON Relocator where
	parseJSON (Object v) = Relocator <$>
		v .: "Active" <*>
		v .: "MaxProc" <*>
		v .: "IntervalPoll" <*>
		v .: "IntervalElapsed" <*>
		v .: "Name" <*>
		v .: "NameSpace" <*>
		v .: "Class" <*>
		v .: "Destination" <*>
		v .: "Glob" <*>
		v .: "Relocate"
	parseJSON _ = mzero


data RelPoint = RelPoint { rel :: Relocator, files :: [FilePath] } deriving (Show, Read)


data RelPair = RelPair { r :: Relocator, fp :: [FilePair] }


data ThreadPair = ThreadPair { tr :: Relocator, tf :: FilePath }


type ThreadCTX = ThreadPair


type ThreadChan = BoundedChan
