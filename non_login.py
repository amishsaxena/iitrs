import helper

def init():
	print("Welcome")
	print("Enter 1 to login as guest user")
	print("Enter 2 to login")
	print("Enter 3 to register")
	print("Enter 4 to exit")
	init_value = int(input())
	return init_value


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
		helper.psycop.db.execute_ddl_and_dml_commands("INSERT INTO user_info (name, password, mobile_no, email, address) values ('{}', '{}', '{}', '{}', '{}')".format(name, pwd, mob_no, email, address))
	except:
		print("Entered email already exists")


def guest_page():
	# Pretty table
	print("Welcome aboard!")
	print("Enter 1 for viewing available trains between two stations")
	print("Enter 2 to view availabilty of seats")
	print("Enter 3 for booking")
	print("Enter 4 to exit")
	guest_page_value = int(input())
	if guest_page_value == 1:
		helper.view_trains()
		guest_page()

	elif guest_page_value == 2:
		helper.view_availability()
		guest_page()

	elif guest_page_value == 3:
		print("Please login / register to book a ticket")
		return
	else:
		exit(0)