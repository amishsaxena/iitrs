import psycop

SEAT_COUNT_1AC = 24
SEAT_COUNT_2AC = 48
SEAT_COUNT_3AC = 64
SEAT_COUNT_SL = 72
SEAT_COUNT_GEN = 72

def view_trains():
	src = input("Enter source station: ")
	dest = input("Enter destination: ") 
	result_form = psycop.db.execute_ddl_and_dml_commands(psycop.text("SELECT avail_trains('{}', '{}')".format(src, dest)))
	for row in result_form:
		print(row)

def view_availability():
	src = input("Enter source station: ")
	dest = input("Enter destination: ") 
	date = input("Enter date in MM/DD/YYYY format: ")
	result_form_1 = psycop.db.execute_ddl_and_dml_commands(psycop.text("SELECT avail_seats_1('{}', '{}', '{}')".format(src, dest, date)))
	result_form_2 = psycop.db.execute_ddl_and_dml_commands(psycop.text("SELECT avail_seats_2('{}', '{}', '{}')".format(src, dest, date)))

	check = 1
	index = 1
	ret_table = []
	for row in result_form_1:
		check = 0
		l = row[0][1:-1].split(",")
		l[0] = int(l[0])
		l[2] = int(l[2])
		ret_table.append(l)
		print(index, l)
		index +=1

	for row in result_form_2:
		check = 0
		print(row)

	if check:
		print("No such trains found!")

	return ret_table


def retrieve_first_value(obj):
	for row in obj:
		obj = row[0]
		break
	return obj


def calc_seat(rem_seat, ticket_class):
	if ticket_class == '1AC':
		coach_no = rem_seat // SEAT_COUNT_1AC + 1
		seat_no = (rem_seat - 1) % SEAT_COUNT_1AC + 1
		return "H"+str(coach_no)+"/"+str(seat_no)

	elif ticket_class == '2AC':
		coach_no = rem_seat // SEAT_COUNT_2AC + 1
		seat_no = (rem_seat - 1) % SEAT_COUNT_2AC + 1
		return "A"+str(coach_no)+"/"+str(seat_no)

	elif ticket_class == '3AC':
		coach_no = rem_seat // SEAT_COUNT_3AC + 1
		seat_no = (rem_seat - 1) % SEAT_COUNT_3AC + 1
		return "B"+str(coach_no)+"/"+str(seat_no)

	elif ticket_class == 'SL':
		coach_no = rem_seat // SEAT_COUNT_SL + 1
		seat_no = (rem_seat - 1) % SEAT_COUNT_SL + 1
		return "S"+str(coach_no)+"/"+str(seat_no)

	elif ticket_class == 'GEN':
		coach_no = rem_seat // SEAT_COUNT_GEN + 1
		seat_no = (rem_seat - 1) % SEAT_COUNT_GEN + 1
		return "2S"+str(coach_no)+"/"+str(seat_no)
