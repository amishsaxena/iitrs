CREATE OR UPDATE FUNCTION seats_in(utno int)
RETURNS int
language plpgsql
as
$$
declare
   seat_count integer;
begin
   select count(*) 
   into film_count
   from film
   where length between len_from and len_to;
   
   return film_count;
end;
$$;
