%% Migration: create_accounts

{create_accounts,
  fun(up) -> 
    boss_db:execute(
      "create table accounts(
        id bigserial primary key not null,
        email varchar not null unique,
        password varchar not null,
        api_key varchar not null,
        api_secret varchar not null,
        created timestamp not null default (current_timestamp at time zone 'utc'),
        updated timestamp not null
      );
      create index account_email on accounts using btree(email);
      create index api_key on accounts using btree(api_key);");
     (down) -> boss_db:execute("drop table accounts;")
  end}.
