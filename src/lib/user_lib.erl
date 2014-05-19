-module(user_lib).
-compile(export_all).

hash_password(Password) ->
  {ok, Salt} = bcrypt:gen_salt(),
  {ok, Hash} = bcrypt:hashpw(Password, Salt),
  Hash.

require_login(Request) ->
  case Request:cookie("user_id") of
    undefined -> {redirect, "/"};
    Id ->
      case boss_db:find(Id) of
        undefined -> {redirect, "/"};
        User ->
          case User:session_identifier() =:= Request:cookie("session_id") of
            true -> {ok, User};
            _Else -> {redirect, "/"}
          end
      end
  end.
