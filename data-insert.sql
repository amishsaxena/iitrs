INSERT INTO train(train_no, train_name, first_ac, second_ac, third_ac, sleeper, general) VALUES
(11111, 'Andhra Pradesh Express', 1, 3, 5, 10, 2),
(11112, 'Andhra Pradesh Sampark Kranti', 1, 3, 5, 10, 2),
(11113, 'Ahimsa Express', 0, 2, 5, 8, 4),
(11114, 'Amritsar Shatabdi', 3, 5, 10, 0, 2),
(11115, 'Anandwan Express', 1, 3, 5, 10, 2),
(11116, 'Annanya Express', 1, 2, 5, 6, 2),
(11117, 'Archana Express', 1, 1, 2, 5, 4),
(11118, 'Ashram Express', 1, 3, 5, 10, 2),
(11119, 'Bagmati Express', 3, 5, 10, 0, 2);
	
INSERT INTO route(train_no, source, destination, departure, arrival) VALUES 
(11114, 'NDLS', 'LDH', '07:20', '11:30'),
(11114, 'LDH', 'ASR', '11:30', '13:45'),
(11114, 'NDLS', 'ASR', '07:20', '13:45');

INSERT INTO route(train_no, source, destination, departure, arrival) VALUES 
(11119, 'DBG', 'MYS', '15:45', '23:40'),
(11118, 'DLI', 'ADI', '15:20', '07:40'),
(11116, 'UDZ', 'SDAH', '00:25', '15:10');

INSERT INTO availability (uti, First_AC ,Second_AC ,Third_AC ,Sleeper ,General ,Date) VALUES
(1, seats_in_first_ac(1), seats_in_second_ac(1), seats_in_third_ac(1), seats_in_sleeper(1), seats_in_general(1), '03/26/2022')
;

INSERT INTO availability (uti, First_AC ,Second_AC ,Third_AC ,Sleeper ,General ,Date) VALUES 
(1, seats_in_first_ac(1), seats_in_second_ac(1), seats_in_third_ac(1), seats_in_sleeper(1), seats_in_general(1), '04/02/2022');

INSERT INTO availability (uti, First_AC, Second_AC, Third_AC, Sleeper, General, Date) VALUES 
(1, seats_in_first_ac(1), seats_in_second_ac(1), seats_in_third_ac(1), seats_in_sleeper(1), seats_in_general(1), '04/09/2022');

INSERT INTO availability (uti, First_AC, Second_AC, Third_AC, Sleeper, General, Date) VALUES 
(2, seats_in_first_ac(2), seats_in_second_ac(2), seats_in_third_ac(2), seats_in_sleeper(2), seats_in_general(2), '03/26/2022'),
(2, seats_in_first_ac(2), seats_in_second_ac(2), seats_in_third_ac(2), seats_in_sleeper(2), seats_in_general(2), '04/02/2022'),
(2, seats_in_first_ac(2), seats_in_second_ac(2), seats_in_third_ac(2), seats_in_sleeper(2), seats_in_general(2), '04/09/2022'),
(3, seats_in_first_ac(3), seats_in_second_ac(3), seats_in_third_ac(3), seats_in_sleeper(3), seats_in_general(3), '03/26/2022'),
(3, seats_in_first_ac(3), seats_in_second_ac(3), seats_in_third_ac(3), seats_in_sleeper(3), seats_in_general(3), '04/02/2022'),
(3, seats_in_first_ac(3), seats_in_second_ac(3), seats_in_third_ac(3), seats_in_sleeper(3), seats_in_general(3), '04/09/2022'),
(6, seats_in_first_ac(6), seats_in_second_ac(6), seats_in_third_ac(6), seats_in_sleeper(6), seats_in_general(6), '04/25/2022'),
(6, seats_in_first_ac(6), seats_in_second_ac(6), seats_in_third_ac(6), seats_in_sleeper(6), seats_in_general(6), '04/26/2022'),
(6, seats_in_first_ac(6), seats_in_second_ac(6), seats_in_third_ac(6), seats_in_sleeper(6), seats_in_general(6), '04/27/2022')
;

INSERT INTO train(train_no, train_name, first_ac, second_ac, third_ac, sleeper, general) VALUES
(19999, 'Test Train', 1, 3, 5, 10, 2);

INSERT INTO route(train_no, source, destination, departure, arrival) VALUES 
(19999, 'NDLS', 'LDH', '07:20', '11:30'),
(19999, 'LDH', 'ASR', '11:30', '13:45'),
(19999, 'NDLS', 'ASR', '07:20', '13:45');

INSERT INTO availability (uti, First_AC ,Second_AC ,Third_AC ,Sleeper ,General ,Date) VALUES
(7, seats_in_first_ac(7), seats_in_second_ac(7), seats_in_third_ac(7), seats_in_sleeper(7), seats_in_general(7), '03/26/2022');

INSERT INTO availability (uti, First_AC ,Second_AC ,Third_AC ,Sleeper ,General ,Date) VALUES 
(7, seats_in_first_ac(7), seats_in_second_ac(7), seats_in_third_ac(7), seats_in_sleeper(7), seats_in_general(7), '04/02/2022');

INSERT INTO availability (uti, First_AC, Second_AC, Third_AC, Sleeper, General, Date) VALUES 
(7, seats_in_first_ac(7), seats_in_second_ac(7), seats_in_third_ac(7), seats_in_sleeper(7), seats_in_general(7), '04/09/2022');

INSERT INTO availability (uti, First_AC, Second_AC, Third_AC, Sleeper, General, Date) VALUES 
(8, seats_in_first_ac(8), seats_in_second_ac(8), seats_in_third_ac(8), seats_in_sleeper(8), seats_in_general(8), '03/26/2022'),
(8, seats_in_first_ac(8), seats_in_second_ac(8), seats_in_third_ac(8), seats_in_sleeper(8), seats_in_general(8), '04/02/2022'),
(8, seats_in_first_ac(8), seats_in_second_ac(8), seats_in_third_ac(8), seats_in_sleeper(8), seats_in_general(8), '04/09/2022'),
(9, seats_in_first_ac(9), seats_in_second_ac(9), seats_in_third_ac(9), seats_in_sleeper(9), seats_in_general(9), '03/26/2022'),
(9, seats_in_first_ac(9), seats_in_second_ac(9), seats_in_third_ac(9), seats_in_sleeper(9), seats_in_general(9), '04/02/2022'),
(9, seats_in_first_ac(9), seats_in_second_ac(9), seats_in_third_ac(9), seats_in_sleeper(9), seats_in_general(9), '04/09/2022');


INSERT INTO user_info (name, password, mobile_no, email, address) VALUES ('biju', 'jibu', '123456', 'biju@iit.com', 'iit');

INSERT INTO train_journey (train_no, journey) VALUES (11114, 'NDLS,LDH,ASR'), (11119, 'DBG,MYS'), (11118, 'DLI,ADI'), (11116, 'UDZ,SDAH'), (19999, 'NDLS,LDH,ASR');