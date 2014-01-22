module Service (blockSigs,doRelocate) where

import System.Posix.Signals
import System.Posix.Process
import System.Process
import System.Exit
import RelocateInc
import HMisc.Pool

import Control.Concurrent


blockSigs = blockSignals reservedSignals


doRelocate :: ThreadPair -> IO ()
doRelocate tp = doRelocateFile (tr tp) (tf tp)


doRelocateFile :: Relocator -> FilePath -> IO ()
doRelocateFile rel fp = do
	printRelocate
	(_, _, _, r) <- createProcess (proc (relocate rel) [name rel, namespace rel, xclass rel, source, destination rel])
	waitForProcess r
	return ()
	where
		source = fp
		printRelocate =
			print $
				"RELOCATE: "
				++ name rel ++
				", namespace: "
				++ namespace rel ++
				", class: "
				++ xclass rel ++
				", source: "
				++ source ++
				", dest: "
				++ destination rel
