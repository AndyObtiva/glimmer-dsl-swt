@ECHO OFF

if exist ".\bin\girb_runner.rb" (
  jruby %* -S irb -r ".\bin\girb_runner"
) else (
  jruby %* -S irb -r "girb_runner"
)
