module System.Relocated.Config (
 load
) where

import System.Relocated.Records

import Data.Aeson
import qualified Data.ByteString.Lazy as B

load :: FilePath -> IO (Either String Root)
load s = do
 d <- B.readFile s
 return (eitherDecode d :: Either String Root)
