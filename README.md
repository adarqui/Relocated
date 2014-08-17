WhatIsIt?
==========

A daemon which watches lists of file paths (glob) and relocates (relocate.sh) them according to an elapsed time (intervalElapsed) bound by a thread pool limit (maxProc). This tool can be useful when  you need to relocate files N seconds after they have been uploaded/modified. It may also aid you in situations when you can't use tools that rely on inotify.


Installing
==========

     make


Running
=========

     ./.cabal.sandbox/bin/relocated ./etc/config.json.example


Debug
=========

     cabal run relocated ./etc/config.json.example


Demo
=========

     make
     ./.cabal.sandbox/bin/relocated ./etc/config.json.example
     ./scripts/demo.sh
