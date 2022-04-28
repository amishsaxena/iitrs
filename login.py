import helper
import booking
from gui import *

def login_page():
	username, password = login_screen()
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
		details = row.split(',')[1:-1]
		break
	dialog_screen(details)


def after_login(uid):
	name = helper.psycop.db.execute_ddl_and_dml_commands("SELECT name FROM user_info WHERE uid = {}".format(uid))
	name = helper.retrieve_first_value(name)

	after_login_value = after_login_screen(name)

	if after_login_value == 1:
		helper.view_trains()

	elif after_login_value == 2:
		ticket_src, ticket_dest, ticket_date, ret_table, ret_table_2 = helper.view_availability()
		ticket_id = 1 + check_avail_screen_out(ticket_src, ticket_dest, ticket_date, ret_table, ret_table_2)

	elif after_login_value == 3:
		details = booking.book_ticket(uid)
		print(details)

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