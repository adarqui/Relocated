all:
	cabal sandbox init
	cabal-meta install

debug:
	cabal run relocated ./etc/config.json.example
