all:
	ghc relocated.hs -threaded -fforce-recomp

clean:
	rm -f *.o *.hi relocated

run:
	./relocated

deps:
	cabal install missingh
	cabal install glob
	cabal install aeson
	cabal install boundedchan
