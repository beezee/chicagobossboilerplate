-module(reservations_dashboard_controller, [Request]).
-compile(export_all).

before_(_) ->
  user_lib:require_login(Request).

index(GET, [], User) ->
  {ok, [{api_key, User:api_key()}, {api_secret, User:api_secret()}]}. 

logout('GET', []) ->
  {redirect, "/", 
    [mochiweb_cookies:cookie("user_id", "", "/"),
      mochiweb_cookies:cookie("session_id", "", "/")]}.
