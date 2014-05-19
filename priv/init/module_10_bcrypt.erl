-module(module_10_bcrypt).
-compile(export_all).

init() ->
  bcrypt:start().

stop() ->
  bcrypt:stop().
