CREATE OR REPLACE FUNCTION seats_in_first_ac(
      IN id INT,
      OUT cnt INT
)
as $$
begin
   select  first_ac
   into cnt
   from route join train on route.train_no = train.train_no
   where route.uti = id;
   cnt = cnt * 24;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION seats_in_second_ac(
      IN id INT,
      OUT cnt INT
)
as $$
begin
   select  first_ac
   into cnt
   from route join train on route.train_no = train.train_no
   where route.uti = id;
   cnt = cnt * 48;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION seats_in_third_ac(
      IN id INT,
      OUT cnt INT
)
as $$
begin
   select  first_ac
   into cnt
   from route join train on route.train_no = train.train_no
   where route.uti = id;
   cnt = cnt * 64;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION seats_in_sleeper(
      IN id INT,
      OUT cnt INT
)
as $$
begin
   select  first_ac
   into cnt
   from route join train on route.train_no = train.train_no
   where route.uti = id;
   cnt = cnt * 72;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION seats_in_general(
      IN id INT,
      OUT cnt INT
)
as $$
begin
   select  first_ac
   into cnt
   from route join train on route.train_no = train.train_no
   where route.uti = id;
   cnt = cnt * 72;
end;
$$ LANGUAGE plpgsql;
