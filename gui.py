#
# This example shows usage of "changed" event handlers to propagate
# current state of widgets to other parts of an app (to other widgets
# in this case).
#
from picotui.context import Context
from picotui.screen import Screen
from picotui.widgets import *
from picotui.defs import *
from picotui.dialogs import *
from prettytable import PrettyTable



def init_screen():
	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 12, 102, 16)

		d.add(45, 2, WLabel("\033[1mWelcome!"))

		b = WButton(21, " Login as guest user ")
		d.add(40, 4, b)
		b.finish_dialog = 1

		b = WButton(21, "Login")
		d.add(40, 6, b)
		b.finish_dialog = 2

		b = WButton(21, "Register")
		d.add(40, 8, b)
		b.finish_dialog = 3

		b = WButton(21, "Exit")
		d.add(40, 10, b)
		b.finish_dialog = 4

		res = d.loop()
	return res


def guest_screen():
	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 50, 16)

		d.add(17, 2, WLabel("\033[1mWelcome aboard!"))

		b = WButton(28, " View available trains ")
		d.add(11, 4, b)
		b.finish_dialog = 1

		b = WButton(28, " View availability of seats ")
		d.add(11, 6, b)
		b.finish_dialog = 2

		b = WButton(28, "Book ticket")
		d.add(11, 8, b)
		b.finish_dialog = 3

		b = WButton(28, "Exit")
		d.add(11, 10, b)
		b.finish_dialog = 4

		res = d.loop()
	return res


def view_train_screen():

	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 50, 16)

		d.add(14, 2, WLabel("\033[1mView available trains\033[0m"))

		d.add(6, 4, WLabel("Enter Source Station:"))
		t1 = WTextEntry(10, "")
		d.add(30, 4, t1)

		d.add(6, 6, WLabel("Enter Destination:"))
		t2 = WTextEntry(10, "")
		d.add(30, 6, t2)

		b = WButton(28, "Confirm")
		d.add(11, 10, b)
		b.finish_dialog = 1

		d.loop()
		return (t1.get(), t2.get())


def check_avail_screen():

	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 50, 16)

		d.add(14, 2, WLabel("\033[1mView available seats\033[0m"))

		d.add(6, 4, WLabel("Enter Source Station:"))
		t1 = WTextEntry(10, "")
		d.add(30, 4, t1)

		d.add(6, 6, WLabel("Enter Destination:"))
		t2 = WTextEntry(10, "")
		d.add(30, 6, t2)

		d.add(6, 8, WLabel("Enter Date (MM/DD/YY):"))
		t3 = WTextEntry(10, "")
		d.add(30, 8, t3)

		b = WButton(28, "Confirm")
		d.add(11, 12, b)
		b.finish_dialog = 1

		d.loop()
		return (t1.get(), t2.get(), t3.get())


def login_screen():

	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 50, 16)

		d.add(14, 2, WLabel("\033[1mLogin\033[0m"))

		d.add(6, 4, WLabel("Enter email:"))
		t1 = WTextEntry(10, "")
		d.add(30, 4, t1)

		d.add(6, 6, WLabel("Enter password:"))
		t2 = WPasswdEntry(10, "")
		d.add(30, 6, t2)

		b = WButton(28, "Confirm")
		d.add(11, 10, b)
		b.finish_dialog = 1

		d.loop()
		return (t1.get(), t2.get())


def register_screen():

	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 50, 16)

		d.add(14, 2, WLabel("\033[1mRegister\033[0m"))

		d.add(6, 4, WLabel("Name:"))
		t1 = WTextEntry(10, "")
		d.add(30, 4, t1)

		d.add(6, 6, WLabel("Mobile Number:"))
		t2 = WTextEntry(10, "")
		d.add(30, 6, t2)

		d.add(6, 8, WLabel("Email:"))
		t3 = WTextEntry(10, "")
		d.add(30, 8, t3)

		d.add(6, 10, WLabel("Address:"))
		t4 = WMultiEntry(10, 2, "".split("\n"))
		d.add(30, 10, t4)

		d.add(6, 14, WLabel("Password:"))
		t5 = WPasswdEntry(10, "")
		d.add(30, 14, t5)

		d.add(6, 16, WLabel("Confirm Password:"))
		t6 = WPasswdEntry(10, "")
		d.add(30,16, t6)

		b = WButton(28, "Confirm")
		d.add(11, 18, b)
		b.finish_dialog = 1

		# print(t4.get())

		d.loop()

		ret_t4 = ""
		for stri in t4.get():
			ret_t4 += stri + " "

		return (t1.get(), t2.get(), t3.get(), ret_t4, t5.get(), t6.get())


def after_login_screen(uname):
	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 50, 16)

		d.add(17, 2, WLabel("\033[1mWelcome {}!".format(uname)))

		b = WButton(28, " View available trains ")
		d.add(11, 4, b)
		b.finish_dialog = 1

		b = WButton(28, " View availability of seats ")
		d.add(11, 6, b)
		b.finish_dialog = 2

		b = WButton(28, "Book ticket")
		d.add(11, 8, b)
		b.finish_dialog = 3

		b = WButton(28, "Cancel ticket")
		d.add(11, 10, b)
		b.finish_dialog = 4

		b = WButton(28, "View booked ticket history")
		d.add(11, 12, b)
		b.finish_dialog = 5

		b = WButton(28, "View user details")
		d.add(11, 14, b)
		b.finish_dialog = 6

		b = WButton(28, "Change password")
		d.add(11, 16, b)
		b.finish_dialog = 7

		b = WButton(28, "Exit")
		d.add(11, 18, b)
		b.finish_dialog = 9

		res = d.loop()
	return res


def book_ticket_screen():
	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 50, 16)

		d.add(17, 2, WLabel("\033[1mBook Ticket\033[0m"))

		d.add(6, 6, WLabel("Enter number of seats"))
		t2 = WTextEntry(10, "")
		d.add(30, 6, t2)

		d.add(6, 8, WLabel("Choose class:"))
		t3 = WDropDown(11, ["1AC", "2AC", "3AC", "SL", "2S"], dropdown_h=7)
		d.add(30, 8, t3)

		b = WButton(28, "View booking table again")
		d.add(11, 12, b)
		b.finish_dialog = 1

		b = WButton(28, "Confirm")
		d.add(11, 14, b)
		b.finish_dialog = 2

		res = d.loop()
	
	return (res, t2.get(), t3.get())


def view_trains_out_screen(source, destination, ret_table):

	with Context():
			Screen.attr_color(C_WHITE, C_BLUE)
			Screen.cls()
			Screen.attr_reset()

			d = Dialog(15, 3, 102, 16)
			x = PrettyTable()
			# x.field_names = ["Train Name", "Train Number", "Departure", "Arrival", "Days"]
			x.add_rows(ret_table)
			table = x.get_string().split("\n")

			d.add(21, 2, "\033[1mTrains between {} and {}\033[0m".format(
				source, destination))

			idx = 0
			for row in table:
				d.add(21, 4 + idx, row)
				idx += 1

			b = WButton(21, "Ok")
			d.add(15, 10, b)
			b.finish_dialog = 4

			res = d.loop()
	return res


def check_avail_screen_out(source, destination, date, ret_table_1, ret_table_2):
	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()
		
		d = Dialog(15, 3, 102, 16)
		d.add(30, 2, "\033[1mTrains between {} and {} on {}\033[0m".format(
			source, destination, date))

		cnt = 0; curr = 0
		store = -1
		for row in ret_table_1:
			x = PrettyTable()
			train_name, train_no = row[1], row[2]
			d.add(30, curr + 4, "Train Name: {}, Train Number: {}".format(train_name, train_no))
			x.field_names = ["1AC", "2AC", "3AC", "SL", "2S"]
			x.add_row(ret_table_2[cnt][1:-1])
			table = x.get_string().split("\n")
			for i in range(len(table)):
				d.add(35, curr + 4 + i + 2, table[i])
				i += 1
			b = WButton(15, "Select")
			d.add(43, curr + 4 + len(table) + 2, b)
			b.finish_dialog = cnt
			cnt += 1
			curr += i + 4

		res = d.loop()
		
	return res

def enter_user_details(num):
	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 50, 16)

		d.add(14, 2, WLabel("\033[1mEnter passenger {}'s details\033[0m".format(num)))

		d.add(6, 4, WLabel("Name:"))
		t1 = WTextEntry(10, "")
		d.add(30, 4, t1)

		d.add(6, 6, WLabel("Age:"))
		t2 = WTextEntry(10, "")
		d.add(30, 6, t2)

		d.add(6, 8, WLabel("Gender:"))
		t3 = WTextEntry(10, "")
		d.add(30, 8, t3)

		b = WButton(28, "Confirm")
		d.add(11, 10, b)
		b.finish_dialog = 1

		d.loop()

	return (t1.get(), t2.get(), t3.get())


def dialog_screen(text):
	with Context():
		d = DMultiEntry(25, 3, [text], title="Message")
		d.result()
	return


# res = dialog_screen("Booking successful")
# # # res = check_avail_screen_out('LDH', "ASR", "26/03/2001", [[1, "Hello", 232], [2, "World", 323]], [[222, 1, 2, 3, 4, 23], [222, 2, 3, 4, 32, 2]])
# print("Result:", res)