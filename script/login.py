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

	ret_list = []
	for row in ticket_history_value:
		ret_list.append(row)
	
	# print(ret_list)
	# exit(0)

	return ret_list


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

	elif after_login_value == 5:
		ret_table = ticket_history(uid)
		ticket_history_screen(ret_table)

	elif after_login_value == 6:
		user_details(uid)

	elif after_login_value == 4: 
		pnr = cancel_ticket_screen()
		booking.cancel_ticket(uid, pnr)
		dialog_screen("Ticket cancelled successfully!")
		
	elif after_login_value == 7:
		print("Logging out")
		exit(0)
	else:
		exit(0)