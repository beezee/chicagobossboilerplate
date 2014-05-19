-module(reservations_site_controller, [Req, SessId]).
-compile(export_all).

index(GET, []) ->
  {ok, []}.

invalid_params() ->
  { Req:post_param("confirm_password") =/= Req:post_param("password"),
    length(Req:post_param("password")) < 7 }.

login(POST, []) ->
  case boss_db:find(account, [{email, equals, Req:post_param("email")}]) of
    [Acct] ->
      case Acct:check_password(Req:post_param("password")) of
        true ->
          {redirect, "/dashboard", Acct:login_cookies()};
        _Else ->
          boss_flash:add(SessId, danger, "", "Invalid username/password combination"),
          {redirect, "/"}
      end;
    _Else ->
      boss_flash:add(SessId, danger, "", "Invalid username/password combination"),
      {redirect, "/"}
    end.

signup(POST, []) ->
  case invalid_params() of
    {true, true} ->
      boss_flash:add(SessId, danger, "", "Password and Confirm Password do not match."),
      boss_flash:add(SessId, danger, "", "Password must be at least 7 characters."),
      {redirect, "/"};
    {true, false} ->
      boss_flash:add(SessId, danger, "", "Password and Confirm Password do not match."),
      {redirect, "/"};
    {false, true} ->
      boss_flash:add(SessId, danger, "", "Password must be at least 7 characters."),
      {redirect, "/"};
    {false, false} ->
      NewUser = boss_record_lib:dummy_record(account),
      PopulatedUser = NewUser:set([{email, Req:post_param("email")}, {password, user_lib:hash_password(Req:post_param("password"))}]),
      case PopulatedUser:save() of
        {ok, SavedUser} ->
          {redirect, "/dashboard", SavedUser:login_cookies()};
        {error, ErrorList} ->
          lists:map(fun (Error) -> boss_flash:add(SessId, danger, "", Error) end, ErrorList),
          {redirect, "/"}
      end
  end.
