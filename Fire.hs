module Fire (fireOne) where

import RelocateInc
import Relocate
import Service
import HMisc.StatInc
import HMisc.Pool

fireOne :: ThreadChan ThreadCTX -> RelPair -> IO ()
fireOne input rp = mapM_ (fireOneThreadPair input . createThreadPair (r rp) . path) (fp rp)


fireOneThreadPair :: ThreadChan ThreadCTX -> ThreadPair -> IO ()
fireOneThreadPair = boundedWrite
