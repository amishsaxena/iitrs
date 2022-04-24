# First page :
# Welcome 

import psycop

SEAT_COUNT_1AC = 24
SEAT_COUNT_2AC = 48
SEAT_COUNT_3AC = 64
SEAT_COUNT_SL = 72
SEAT_COUNT_GEN = 72


def retrieve_first_value(obj):
	for row in obj:
		obj = row[0]
		break
	return obj

def init():
	print("Welcome")
	print("Enter 1 to login as guest user")
	print("Enter 2 to login")
	print("Enter 3 to register")
	print("Enter 4 to exit")
	init_value = int(input())
	return init_value

def login_page():
	username = input("Enter email - ")
	password = input("Enter password - ")
	obj = psycop.db.execute_ddl_and_dml_commands(psycop.text("SELECT checkpassword('{}', '{}')".format(username, password)))
	obj = retrieve_first_value(obj)

	if obj:
		uid_obj = psycop.db.execute_ddl_and_dml_commands(psycop.text("SELECT uid FROM user_info WHERE email = '{}'".format(username)))
		return retrieve_first_value(uid_obj)
	else:
		return 0;

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

def guest_page():
	# Pretty table
	print("Welcome aboard!")
	print("Enter 1 for viewing available trains between two stations")
	print("Enter 2 to view availabilty of seats")
	print("Enter 3 for booking")
	print("Enter 4 to exit")
	guest_page_value = int(input())
	if guest_page_value == 1:
		view_trains()
		guest_page()

	elif guest_page_value == 2:
		view_availability()
		guest_page()

	elif guest_page_value == 3:
		pass 

	else:
		exit(0)

def register():
	# TODO - try and catch!
	print("Enter 1 to continue")
	print("Enter any other number to return back to home page")
	register_value = int(input())

	if register_value == 1:
		pass
	else:
		init()

	name = input("Enter name - ")
	mob_no = input("Enter mobile - ")
	email = input("Enter email - ")
	address = input("Enter address - ")
	pwd = input("Enter password - ")
	pwd_check = input("Confirm your password - ")
	if pwd_check == pwd:
		pass
	else:
		print("Passwords do not match!")
		register()

	try:
		psycop.db.execute_ddl_and_dml_commands("INSERT INTO user_info (name, password, mobile_no, email, address) values ('{}', '{}', '{}', '{}', '{}')".format(name, pwd, mob_no, email, address))
	except:
		print("Entered email already exists")

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

def ticket_history(uid):
	# pretty print
	# to be tested
	# check if no ticket found
	ticket_history_value = psycop.db.execute_ddl_and_dml_commands("SELECT * FROM ticket WHERE uid = {}".format(uid))

def user_details(uid):
	details = psycop.db.execute_ddl_and_dml_commands("SELECT * FROM user_info WHERE uid = {}".format(uid))
	for row in details:
		details = row
		break
	print(details)

def book_ticket(uid):
	# train_no = int(input("Enter train Number"))
	# date_of_journey = input("Enter Journey date [format : MM/DD/YYYY]")
	ret_table = view_availability()
	print(ret_table)
	# av_id = int(input("Enter av_id of the desired journey : "))
	ticket_id = int(input("Enter index corresponding to the desired train : "))
	ticket_class = input("Enter desired class of Travel [1AC, 2AC, 3AC, SL, GEN] : ")
	no_seats = int(input("Enter the number of Required seats [in Digits] : "))
	train_no = ret_table[ticket_id-1][2]
	av_id = ret_table[ticket_id-1][0]
	ticket_src = ret_table[ticket_id-1][3]
	ticket_dest = ret_table[ticket_id-1][4]
	ticket_date = ret_table[ticket_id-1][-1]
	
	if ticket_class == '1AC':
		ticket_class_name = 'first_ac'
	elif ticket_class == '2AC':
		ticket_class_name = 'second_ac'
	elif ticket_class == '3AC':
		ticket_class_name = 'third_ac'
	elif ticket_class == 'SL':
		ticket_class_name = 'sleeper'
	elif ticket_class == 'GEN':
		ticket_class_name = 'general'
	else:
		print("Entered class is invalid. Try again with a valid class type.")
		return -1

	ret_journey = retrieve_first_value(psycop.db.execute_ddl_and_dml_commands(psycop.text('SELECT journey FROM train_journey WHERE train_no = {}'.format(train_no))))
	ret_journey = ret_journey.split(",")
	print(ret_journey)

	journey_length = len(ret_journey)
	ind1, ind2 = ret_journey.index(ticket_src), ret_journey.index(ticket_dest)
	for i in range(ind1):
		for j in range(ind2, journey_length):
			if i == j : 
				continue
			tmp_av_id = retrieve_first_value(psycop.db.execute_ddl_and_dml_commands(psycop.text("SELECT get_im_av_id('{}', '{}', {}, '{}')".format(ret_journey[i], ret_journey[j], train_no, ticket_date))))
			psycop.db.execute_ddl_and_dml_commands(psycop.text('CALL seatbook{}({}, {})'.format(ticket_class, tmp_av_id, no_seats)))
			


	no_coaches = psycop.db.execute_ddl_and_dml_commands(psycop.text('SELECT {} FROM train WHERE train_no = {}'.format(ticket_class_name, train_no)))
	no_coaches = retrieve_first_value(no_coaches)

	left_seats = retrieve_first_value(psycop.db.execute_ddl_and_dml_commands(psycop.text('CALL seatbook{}({}, {})'.format(ticket_class, av_id, no_seats))))
	print("left seats : ", left_seats,"  ", no_coaches)
	for_seats = left_seats + no_seats

	passenger = "{'ticket' : ["
	for i in range(no_seats): 
		name_passenger = input("Enter Passenger {}'s Name : ".format(i))
		age_passenger = input("Enter Passenger {}'s Age [in digits] : ".format(i))
		gender_passenger = input("Enter Passenger {}'s Gender [M/F/O] : ".format(i))
		seat = calc_seat(for_seats, ticket_class)
		# ticket_string = "{"+ "'name': '"+ str(name_passenger) + "', 'age': " + age_passenger + ", 'gender': '" + gender_passenger + "', 'seat': " + seat + "'}"
		ticket_string = "{{'name': '{}', 'age': {}, 'gender': '{}', 'seat': '{}'}}".format(name_passenger, age_passenger, gender_passenger, seat)
		passenger += (ticket_string + ", ")
		for_seats -= 1

	passenger += "\b\b]}"

	print(passenger)

	# add dict to DB
		




def after_login(uid):
	name = psycop.db.execute_ddl_and_dml_commands("SELECT name FROM user_info WHERE uid = {}".format(uid))
	name = retrieve_first_value(name)
	print("Welcome {}!".format(name))

	print("Enter 1 for viewing available trains between two stations")
	print("Enter 2 to view availabilty of seats")
	print("Enter 3 to book ticket")
	print("Enter 4 to view booked ticket history")
	print("Enter 5 to view user details")
	print("Enter 6 to change password")
	print("Enter 7 to logout")
	print("Enter any other number to exit")

	after_login_value = int(input())

	if after_login_value == 1:
		view_trains()
		after_login(uid)

	elif after_login_value == 2:
		view_availability()
		after_login(uid)
	elif after_login_value == 3:
		details = book_ticket(uid)
		# enter details in ticket
	
	elif after_login_value == 4:
		ticket_history(uid)
		after_login(uid)
	elif after_login_value == 5:
		user_details(uid)
		after_login(uid)
	elif after_login_value == 6:
		pass
		# change_password(uid)
	elif after_login_value == 7:
		# logout
		return
	else:
		exit(0)

def main():

	while True:
		uid = -1
		init_value = init();
	
		if init_value == 1:
			guest_page()

		elif init_value == 2:
			login_successful = 0; cnt = 0
			while cnt < 3 and not login_successful:
				login_successful = login_page()
				cnt += 1
			if login_successful:
				uid = login_successful
				print("Succefful login")
				after_login(uid)
			else:
				print("Entered 3 incorrect passwords!")
				continue

		elif init_value == 3:
			register()

		else:
			exit(0)

if __name__ == '__main__':
	main()