import helper
from gui import *


def init():
	init_value = init_screen()
	return init_value


def register():
	# TODO - try and catch!
	# print("Enter 1 to continue")
	# print("Enter any other number to return back to home page")
	# register_value = int(input())

	# if register_value == 1:
	# 	pass
	# else:
	# 	init()

	name, mob_no, email, address, pwd, pwd_check = register_screen()
	if pwd_check == pwd:
		pass
	else:
		dialog_screen("Passwords do not match!")
		register()

	try:
		helper.psycop.db.execute_ddl_and_dml_commands("INSERT INTO user_info (name, password, mobile_no, email, address) values ('{}', '{}', '{}', '{}', '{}')".format(name, pwd, mob_no, email, address))
	except:
		dialog_screen("Entered email already exists")


def guest_page():
	# Pretty table
	guest_page_value = guest_screen()
	if guest_page_value == 1:
		helper.view_trains()
		guest_page()

	elif guest_page_value == 2:
		ticket_src, ticket_dest, ticket_date, ret_table, ret_table_2 = helper.view_availability()
		ticket_id = 1 + check_avail_screen_out(ticket_src, ticket_dest, ticket_date, ret_table, ret_table_2)
		guest_page()

	elif guest_page_value == 3:
		dialog_screen("Please login / register to book a ticket")
		return
	else:
		exit(0)