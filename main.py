# First page :
# Welcome 

import booking

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
	obj = booking.db.execute_ddl_and_dml_commands(booking.text("SELECT checkpassword('{}', '{}')".format(username, password)))
	obj = retrieve_first_value(obj)

	if obj:
		uid_obj = booking.db.execute_ddl_and_dml_commands(booking.text("SELECT uid FROM user_info WHERE email = '{}'".format(username)))
		return retrieve_first_value(uid_obj)
	else:
		return 0;

def view_trains():
	src = input("Enter source station: ")
	dest = input("Enter destination: ") 
	result_form = booking.db.execute_ddl_and_dml_commands(booking.text("SELECT avail_trains('{}', '{}')".format(src, dest)))
	for row in result_form:
		print(row)

def view_availability():
	src = input("Enter source station: ")
	dest = input("Enter destination: ") 
	date = input("Enter date in MM/DD/YYYY format: ")
	result_form_1 = booking.db.execute_ddl_and_dml_commands(booking.text("SELECT avail_seats_1('{}', '{}', '{}')".format(src, dest, date)))
	result_form_2 = booking.db.execute_ddl_and_dml_commands(booking.text("SELECT avail_seats_2('{}', '{}', '{}')".format(src, dest, date)))

	check = 1
	for row in result_form_1:
		check = 0
		print(row)

	for row in result_form_2:
		check = 0
		print(row)

	if check:
		print("No such trains found!")

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
		booking.db.execute_ddl_and_dml_commands("INSERT INTO user_info (name, password, mobile_no, email, address) values ('{}', '{}', '{}', '{}', '{}')".format(name, pwd, mob_no, email, address))
	except:
		print("Entered email already exists")

def ticket_history(uid):
	# pretty print
	# to be tested
	# check if no ticket found
	ticket_history_value = booking.db.execute_ddl_and_dml_commands("SELECT * FROM ticket WHERE uid = {}".format(uid))

def user_details(uid):
	details = booking.db.execute_ddl_and_dml_commands("SELECT * FROM user_info WHERE uid = {}".format(uid))
	for row in details:
		details = row
		break
	print(details)

def after_login(uid):
	name = booking.db.execute_ddl_and_dml_commands("SELECT name FROM user_info WHERE uid = {}".format(uid))
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
		# booking
		pass
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