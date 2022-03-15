CREATE DATABASE iitrs;

-- \c iitrs

CREATE TABLE Train (Train_No int PRIMARY KEY,
					Train_Name text NOT NULL, 
					First_AC int, Second_AC int, Third_AC int,
					Sleeper int, General int);


CREATE TABLE Route (UTI SERIAL PRIMARY KEY,
					Train_No int REFERENCES Train(Train_No),
					Source text NOT NULL,
					Destination text NOT NULL, 
					Departure time NOT NULL,
					Arrival time NOT NULL);


CREATE TABLE Availability (Av_ID SERIAL PRIMARY KEY,
						  UTI int REFERENCES Route(UTI),
						  First_AC int,
						  Second_AC int,
						  Third_AC int,
						  Sleeper int,
						  General int,
						  Date date);


CREATE TABLE User_Info (UID int PRIMARY KEY,
						Name text NOT NULL,
						Password text NOT NULL,
						Mobile_No int,
						Email text UNIQUE NOT NULL,
						Address text NOT NULL);


CREATE TABLE Ticket (PNR int PRIMARY KEY,
					 Train_No int REFERENCES Train (Train_No),
					 UID int REFERENCES User_Info (UID),
					 Train_Name text NOT NULL,
					 Source text NOT NULL,
					 Destination text NOT NULL,
					 Date date NOT NULL,
					 Seats JSON NOT NULL,
					 Amount numeric (8,2) NOT NULL);

