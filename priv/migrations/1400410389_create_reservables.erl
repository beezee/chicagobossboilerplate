%% Migration: create_reservables

{create_reservables,
  fun(up) -> 
    boss_db:execute(
      "create table reservables(
        id bigserial not null, 
        account_id bigint not null,
        name varchar not null,
        capacity bigint not null,
        created timestamp not null default (current_timestamp at time zone 'utc'),
        updated timestamp not null
      );
      create index reservable_account on reservables using btree(account_id);
      create index reservable_name on reservables using btree(name);"
    );
     (down) -> boss_db:execute("drop table reservables;")
  end}.
