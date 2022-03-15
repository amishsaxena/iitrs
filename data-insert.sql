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
(1, )
;

