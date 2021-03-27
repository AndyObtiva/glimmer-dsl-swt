@ECHO OFF
set Args=
:TOP

IF (%1)==() GOTO END

set ArgString=%1
IF NOT "%ArgString%"=="%ArgString:-=%" set Args=%Args% %1

SHIFT
GOTO TOP

:END

jruby %Args% -e "require File.exist?('./bin/glimmer_runner.rb') ? './bin/glimmer_runner' : 'glimmer_runner'" %*
