import helper
from datetime import date
today = date.today()


SEAT_COST = [3000, 2000, 1000, 500, 100]

def book_ticket(uid):
	# train_no = int(input("Enter train Number"))
	# date_of_journey = input("Enter Journey date [format : MM/DD/YYYY]")

	connection = helper.psycop.db.open_connect()
	trans = connection.begin()

	ret_table = helper.view_availability()
	print(ret_table)
	# av_id = int(input("Enter av_id of the desired journey : "))
	ticket_id = int(input("Enter index corresponding to the desired train : "))
	ticket_class = input("Enter desired class of Travel [1AC, 2AC, 3AC, SL, GEN] : ")
	no_seats = int(input("Enter the number of Required seats [in Digits] : "))
	av_id = ret_table[ticket_id-1][0]
	train_name = ret_table[ticket_id-1][1]
	train_no = ret_table[ticket_id-1][2]
	ticket_src = ret_table[ticket_id-1][3]
	ticket_dest = ret_table[ticket_id-1][4]
	ticket_date = ret_table[ticket_id-1][7]
	booking_date = str(today.strftime("%m/%d/%Y"))

	if ticket_class == '1AC':
		ticket_class_name = 'first_ac'
		cost = SEAT_COST[0]
	elif ticket_class == '2AC':
		ticket_class_name = 'second_ac'
		cost = SEAT_COST[1]
	elif ticket_class == '3AC':
		ticket_class_name = 'third_ac'
		cost = SEAT_COST[2]
	elif ticket_class == 'SL':
		ticket_class_name = 'sleeper'
		cost = SEAT_COST[3]
	elif ticket_class == 'GEN':
		ticket_class_name = 'general'
		cost = SEAT_COST[4]
	else:
		print("Entered class is invalid. Try again with a valid class type.")
		return -1

	ret_journey = helper.retrieve_first_value(connection.execute(helper.psycop.text('SELECT journey FROM train_journey WHERE train_no = {}'.format(train_no))))
	ret_journey = ret_journey.split(",")
	print(ret_journey)

	journey_length = len(ret_journey)
	ind1, ind2 = ret_journey.index(ticket_src), ret_journey.index(ticket_dest)
	for i in range(ind1):
		for j in range(ind2, journey_length):
			if i == j : 
				continue
			tmp_av_id = helper.retrieve_first_value(connection.execute(helper.psycop.text("SELECT get_im_av_id('{}', '{}', {}, '{}')".format(ret_journey[i], ret_journey[j], train_no, ticket_date))))
			connection.execute(helper.psycop.text('CALL seatbook{}({}, {})'.format(ticket_class, tmp_av_id, no_seats)))
			


	no_coaches = connection.execute(helper.psycop.text("SELECT {} FROM train WHERE train_no = {}".format(ticket_class_name, train_no)))
	no_coaches = helper.retrieve_first_value(no_coaches)

	left_seats = helper.retrieve_first_value(connection.execute(helper.psycop.text('CALL seatbook{}({}, {})'.format(ticket_class, av_id, no_seats))))
	print("left seats : ", left_seats,"  ", no_coaches)
	for_seats = left_seats + no_seats

	passenger = '''{"ticket" : ['''
	for i in range(no_seats): 
		name_passenger = input("Enter Passenger {}'s Name : ".format(i))
		age_passenger = input("Enter Passenger {}'s Age [in digits] : ".format(i))
		gender_passenger = input("Enter Passenger {}'s Gender [M/F/O] : ".format(i))
		seat = helper.calc_seat(for_seats, ticket_class)
		# ticket_string = "{"+ "'name': '"+ str(name_passenger) + "', 'age': " + age_passenger + ", 'gender': '" + gender_passenger + "', 'seat': " + seat + "'}"
		ticket_string = '''{{"name": "{}", "age": "{}", "gender": "{}", "seat": "{}", "date": "{}"}}'''.format(name_passenger, age_passenger, gender_passenger, seat, ticket_date)
		passenger += (ticket_string + ", ")
		for_seats -= 1

	passenger = passenger[:-2] + "]}"
	print(passenger)

	pnr = str(abs(hash((av_id, train_no, ticket_date, left_seats))) % 10 ** 10)

	insert_query = connection.execute(helper.psycop.text("INSERT INTO ticket (pnr, train_no, uid, train_name, source, destination, date, seats, amount) values ('{}', {}, {}, '{}', '{}', '{}', '{}', '{}', {})".format(pnr, train_no, uid, train_name, ticket_src, ticket_dest, booking_date, passenger, cost * no_seats)))

	trans.commit()
	helper.psycop.db.close_connect(connection)

	print("Ticket booked successfully")
