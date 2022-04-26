import helper
import booking

def login_page():
	username = input("Enter email - ")
	password = input("Enter password - ")
	obj = helper.psycop.db.execute_ddl_and_dml_commands(helper.psycop.text("SELECT checkpassword('{}', '{}')".format(username, password)))
	obj = helper.retrieve_first_value(obj)

	if obj:
		uid_obj = helper.psycop.db.execute_ddl_and_dml_commands(helper.psycop.text("SELECT uid FROM user_info WHERE email = '{}'".format(username)))
		return helper.retrieve_first_value(uid_obj)
	else:
		return 0;


def ticket_history(uid):
	# pretty print
	# to be tested
	# check if no ticket found
	ticket_history_value = helper.psycop.db.execute_ddl_and_dml_commands("SELECT * FROM ticket WHERE uid = {}".format(uid))

	for row in ticket_history_value:
		print(row)


def user_details(uid):
	details = helper.psycop.db.execute_ddl_and_dml_commands("SELECT * FROM user_info WHERE uid = {}".format(uid))
	for row in details:
		details = row
		break
	print(details)


def after_login(uid):
	name = helper.psycop.db.execute_ddl_and_dml_commands("SELECT name FROM user_info WHERE uid = {}".format(uid))
	name = helper.retrieve_first_value(name)
	print("Welcome {}!".format(name))

	print("Enter 1 for viewing available trains between two stations")
	print("Enter 2 to view availabilty of seats")
	print("Enter 3 to book ticket")
	print("Enter 4 to view booked ticket history")
	print("Enter 5 to view user details")
	print("Enter 6 to change password")
	print("Enter 7 to cancel")
	print("Enter 8 to logout")
	print("Enter any other number to exit")

	after_login_value = int(input())

	if after_login_value == 1:
		helper.view_trains()

	elif after_login_value == 2:
		helper.view_availability()

	elif after_login_value == 3:
		details = booking.book_ticket(uid)

	elif after_login_value == 4:
		ticket_history(uid)

	elif after_login_value == 5:
		user_details(uid)

	elif after_login_value == 6:
		pass
		# change_password(uid)
	elif after_login_value == 7: 
		print("Cancelling ...")
		booking.cancel_ticket(uid)
		
	elif after_login_value == 8:
		print("Logging out")
		exit(0)
	else:
		exit(0)