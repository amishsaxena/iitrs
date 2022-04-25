CREATE DATABASE iitrs;


CREATE TABLE Train (Train_No int PRIMARY KEY CHECK (Train_No > 9999),
					Train_Name text NOT NULL, 
					First_AC int CHECK (First_AC >= 0), Second_AC int CHECK (Second_AC >= 0), Third_AC int CHECK (Third_AC >= 0),
					Sleeper int CHECK (Sleeper >= 0), General int CHECK (General >= 0));


CREATE TABLE Route (UTI SERIAL PRIMARY KEY,
					Train_No int REFERENCES Train(Train_No),
					Source text NOT NULL,
					Destination text NOT NULL, 
					Departure time NOT NULL,
					Arrival time NOT NULL);


CREATE TABLE Availability (Av_ID SERIAL PRIMARY KEY,
						  UTI int REFERENCES Route(UTI),
						  First_AC int CHECK (First_AC >= 0),
						  Second_AC int CHECK (Second_AC >= 0),
						  Third_AC int CHECK (Third_AC >= 0),
						  Sleeper int CHECK (Sleeper >= 0),
						  General int CHECK (General >= 0),
						  Date date);


CREATE TABLE User_Info (UID SERIAL PRIMARY KEY,
						Name text NOT NULL,
						Password text NOT NULL,
						Mobile_No text,
						Email text UNIQUE NOT NULL,
						Address text NOT NULL);


CREATE TABLE Ticket (PNR text PRIMARY KEY,
					 av_id int NOT NULL,
					 Train_No int REFERENCES Train (Train_No),
					 UID int REFERENCES User_Info (UID),
					 Train_Name text NOT NULL,
					 Source text NOT NULL,
					 Destination text NOT NULL,
					 Date date NOT NULL,
					 Seats JSON NOT NULL,
					 Amount numeric (8,2) NOT NULL,
					 Booking_status varchar(10));


CREATE TABLE Train_Journey (Train_No int PRIMARY KEY REFERENCES Train (Train_No),
					 journey text NOT NULL
);