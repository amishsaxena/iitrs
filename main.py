# First page :
# Welcome 

import booking

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
	for row in obj:
		obj = row[0]
		break

	if obj:
		uid_obj = booking.db.execute_ddl_and_dml_commands(booking.text("SELECT uid FROM user_info WHERE email = '{}'".format(username)))
		save = -1
		for row in uid_obj:
			save = row[0]
		return save
	else:
		return 0;

def guest_page():
	# Pretty table
	print("Welcome aboard!")
	print("Enter 1 for viewing available trains between two stations")
	print("Enter 2 to view availabilty of seats")
	print("Enter 3 for booking")
	print("Enter 4 to exit")
	guest_page_value = int(input())
	if guest_page_value == 1:
		src = input("Enter source station: ")
		dest = input("Enter destination: ") 
		result_form = booking.db.execute_ddl_and_dml_commands(booking.text("SELECT avail_trains('{}', '{}')".format(src, dest)))
		for row in result_form:
			print(row)
		guest_page()

	elif guest_page_value == 2:
		src = input("Enter source station: ")
		dest = input("Enter destination: ") 
		date = input("Enter date in MM/DD/YYYY format: ")
		result_form_1 = booking.db.execute_ddl_and_dml_commands(booking.text("SELECT avail_seats_1('{}', '{}', '{}')".format(src, dest, date)))
		result_form_2 = booking.db.execute_ddl_and_dml_commands(booking.text("SELECT avail_seats_2('{}', '{}', '{}')".format(src, dest, date)))

		for row in result_form_1:
			print(row)
		for row in result_form_1:
			print(row)
		guest_page()

	elif guest_page_value == 3:
		pass 

	else:
		exit(0)

def register():
	# TODO - try and catch!
	print("Enter 1 to continue")
	print("Enter 2 to return back to home page")
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
	ticket_history_value = booking.db.execute_ddl_and_dml_commands("SELECT * FROM ticket WHERE uid = {}".format(uid))

def main():
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
			# Something else
		else:
			print("Entered 3 incorrect passwords!")
			init()

	elif init_value == 3:
		register()

	else:
		exit(0)

if __name__ == '__main__':
	main()