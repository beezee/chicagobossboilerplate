%% Migration: create_reservations

{create_reservations,
  fun(up) -> 
    boss_db:execute(
      "create table reservations (
        id bigserial primary key,
        account_id bigint not null,
        type_id bigint not null,
        from_date timestamp not null,
        to_date timestamp not null,
        created timestamp not null default (current_timestamp at time zone 'utc'),
        updated timestamp not null
      );
      create index reservation_account on reservations using btree(account_id);
      create index reservation_type on reservations using btree(type_id);
      create index reservation_from_date on reservations using btree(from_date);
      create index reservation_to_date on reservations using btree(to_date);"
    );
     (down) -> boss_db:execute("drop table reservations;")
  end}.
