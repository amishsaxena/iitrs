CREATE ROLE db_admin WITH SUPERUSER LOGIN PASSWORD 'admin';

CREATE ROLE guest;
GRANT SELECT ON avail_seats_1_view TO guest;
GRANT SELECT ON avail_seats_2_view TO guest;

CREATE ROLE login_user LOGIN PASSWORD 'login';
GRANT UPDATE on availability TO login_user;
GRANT UPDATE on user_info TO login_user;
GRANT INSERT on ticket TO login_user ;

CREATE ROLE manager LOGIN PASSWORD 'rail';
GRANT  SELECT, INSERT, UPDATE, DELETE ON train, train_journey, stations, route, availability TO manager;