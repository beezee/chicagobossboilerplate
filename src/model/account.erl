-module(account, [Id, Email::string(), Password::string(), ApiKey::string(), ApiSecret::string(), Created::datetime(), Updated::datetime()]).
-compile(export_all).

-define(APP_SALT, "reservationssessionappsaltdog").

before_create() ->
  WithKeys = generate_api_keys(), 
  {ok, WithKeys:set(updated, calendar:universal_time())}.

before_update() ->
  {ok, set(updated, calendar:universal_time())}.

generate_api_keys() ->
  WithKey = set(api_key, uuid:to_string(uuid:uuid4())),
  WithKey:set(api_secret, uuid:to_string(uuid:uuid4())).

validation_tests() ->
  [{fun() -> email_address:is_valid(Email) end,
    "Email is invalid"},
   {fun() -> boss_db:count(account, [email, equals, Email]) =:= 0 end,
    "Email is taken"},
   {fun() -> length(Password) > 7 end,
      "Password must be at least 7 characters"}].

session_identifier() ->
  mochihex:to_hex(erlang:md5(?APP_SALT ++ Id)).

check_password(SubmittedPassword) ->
  {ok, Password} =:= bcrypt:hashpw(SubmittedPassword, Password). 

login_cookies() ->
  [ mochiweb_cookies:cookie("user_id", Id, [{path, "/"}]),
    mochiweb_cookies:cookie("session_id", session_identifier(), [{path, "/"}]) ].
