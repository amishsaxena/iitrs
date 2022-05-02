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

		d = Dialog(15, 3, 102, 16)

		d.add(43, 2, WLabel("\033[1mWelcome aboard!"))

		b = WButton(28, " View available trains ")
		d.add(37, 4, b)
		b.finish_dialog = 1

		b = WButton(28, " View availability of seats ")
		d.add(37, 6, b)
		b.finish_dialog = 2

		b = WButton(28, "Book ticket")
		d.add(37, 8, b)
		b.finish_dialog = 3

		b = WButton(28, "Exit")
		d.add(37, 10, b)
		b.finish_dialog = 4

		res = d.loop()
	return res


def view_train_screen():

	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 102, 16)

		d.add(40, 2, WLabel("\033[1mView available trains\033[0m"))

		d.add(32, 4, WLabel("Enter Source Station:"))
		t1 = WTextEntry(10, "")
		d.add(57, 4, t1)

		d.add(32, 6, WLabel("Enter Destination:"))
		t2 = WTextEntry(10, "")
		d.add(57, 6, t2)

		b = WButton(28, "Confirm")
		d.add(37, 10, b)
		b.finish_dialog = 1

		d.loop()
		return (t1.get(), t2.get())


def check_avail_screen():

	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 102, 16)

		d.add(40, 2, WLabel("\033[1mView available seats\033[0m"))

		d.add(30, 4, WLabel("Enter Source Station:"))
		t1 = WTextEntry(10, "")
		d.add(57, 4, t1)

		d.add(30, 6, WLabel("Enter Destination:"))
		t2 = WTextEntry(10, "")
		d.add(57, 6, t2)

		d.add(30, 8, WLabel("Enter Date (MM/DD/YY):"))
		t3 = WTextEntry(10, "")
		d.add(57, 8, t3)

		b = WButton(28, "Confirm")
		d.add(37, 12, b)
		b.finish_dialog = 1

		d.loop()
		return (t1.get(), t2.get(), t3.get())


def login_screen():

	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 102, 16)

		d.add(47, 2, WLabel("\033[1mLogin\033[0m"))

		d.add(35, 4, WLabel("Enter email:"))
		t1 = WTextEntry(10, "")
		d.add(57, 4, t1)

		d.add(35, 6, WLabel("Enter password:"))
		t2 = WPasswdEntry(10, "")
		d.add(57, 6, t2)

		b = WButton(28, "Confirm")
		d.add(37, 10, b)
		b.finish_dialog = 1

		d.loop()
		return (t1.get(), t2.get())


def register_screen():

	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3,102, 22)

		d.add(47, 2, WLabel("\033[1mRegister\033[0m"))

		d.add(30, 4, WLabel("Name:"))
		t1 = WTextEntry(25, "")
		d.add(60, 4, t1)

		d.add(30, 6, WLabel("Mobile Number:"))
		t2 = WTextEntry(25, "")
		d.add(60, 6, t2)

		d.add(30, 8, WLabel("Email:"))
		t3 = WTextEntry(25, "")
		d.add(60, 8, t3)

		d.add(30, 10, WLabel("Address:"))
		t4 = WMultiEntry(25, 2, "".split("\n"))
		d.add(60, 10, t4)

		d.add(30, 14, WLabel("Password:"))
		t5 = WPasswdEntry(25, "")
		d.add(60, 14, t5)

		d.add(30, 16, WLabel("Confirm Password:"))
		t6 = WPasswdEntry(25, "")
		d.add(60,16, t6)

		b = WButton(28, "Confirm")
		d.add(37, 18, b)
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

		d = Dialog(15, 3, 102, 22)

		d.add(43, 2, WLabel("\033[1mWelcome {}!".format(uname)))

		b = WButton(28, " View available trains ")
		d.add(37, 4, b)
		b.finish_dialog = 1

		b = WButton(28, " View availability of seats ")
		d.add(37, 6, b)
		b.finish_dialog = 2

		b = WButton(28, "Book ticket")
		d.add(37, 8, b)
		b.finish_dialog = 3

		b = WButton(28, "Cancel ticket")
		d.add(37, 10, b)
		b.finish_dialog = 4

		b = WButton(28, "View booked ticket history")
		d.add(37, 12, b)
		b.finish_dialog = 5

		b = WButton(28, "View user details")
		d.add(37, 14, b)
		b.finish_dialog = 6

		# b = WButton(28, "Change password")
		# d.add(37, 16, b)
		# b.finish_dialog = 7

		b = WButton(28, "Exit")
		d.add(37, 18, b)
		b.finish_dialog = 9

		res = d.loop()
	return res


def book_ticket_screen():
	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 102, 16)

		d.add(47, 2, WLabel("\033[1mBook Ticket\033[0m"))

		d.add(30, 6, WLabel("Enter number of seats"))
		t2 = WTextEntry(10, "")
		d.add(57, 6, t2)

		d.add(30, 8, WLabel("Choose class:"))
		t3 = WDropDown(11, ["1AC", "2AC", "3AC", "SL", "2S"], dropdown_h=7)
		d.add(57, 8, t3)

		b = WButton(28, "View booking table again")
		d.add(37, 12, b)
		b.finish_dialog = 1

		b = WButton(28, "Confirm")
		d.add(37, 14, b)
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
			x.field_names = ["Train Name", "Train Number", "Departure", "Arrival"]
			for row in ret_table:
				x.add_row(row[0:2] + row[-1:-3:-1])
			table = x.get_string().split("\n")

			d.add(38, 2, "\033[1mTrains between {} and {}\033[0m".format(
				source, destination))

			idx = 0
			for row in table:
				d.add(28, 4 + idx, row)
				idx += 1

			b = WButton(21, "Ok")
			d.add(40, 20, b)
			b.finish_dialog = 4

			res = d.loop()
	return res


def check_avail_screen_out(source, destination, date, ret_table_1, ret_table_2):
	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()
		
		d = Dialog(15, 3, 102, 16)
		d.add(31, 2, "\033[1mTrains between {} and {} on {}\033[0m".format(
			source, destination, date))

		cnt = 0; curr = 0
		store = -1
		for row in ret_table_1:
			x = PrettyTable()
			train_name, train_no = row[1], row[2]
			d.add(27, curr + 4, "Train Name: {}, Train Number: {}".format(train_name, train_no))
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

		d = Dialog(15, 3, 102, 16)

		d.add(38, 2, WLabel("\033[1mEnter passenger {}'s details\033[0m".format(num)))

		d.add(30, 4, WLabel("Name:"))
		t1 = WTextEntry(10, "")
		d.add(57, 4, t1)

		d.add(30, 6, WLabel("Age:"))
		t2 = WTextEntry(10, "")
		d.add(57, 6, t2)

		d.add(30, 8, WLabel("Gender:"))
		t3 = WTextEntry(10, "")
		d.add(57, 8, t3)

		b = WButton(28, "Confirm")
		d.add(37, 10, b)
		b.finish_dialog = 1

		d.loop()

	return (t1.get(), t2.get(), t3.get())


def view_train_screen():

	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 102, 16)

		d.add(40, 2, WLabel("\033[1mView available trains\033[0m"))

		d.add(32, 4, WLabel("Enter Source Station:"))
		t1 = WTextEntry(10, "")
		d.add(57, 4, t1)

		d.add(32, 6, WLabel("Enter Destination:"))
		t2 = WTextEntry(10, "")
		d.add(57, 6, t2)

		b = WButton(28, "Confirm")
		d.add(37, 10, b)
		b.finish_dialog = 1

		d.loop()
	return (t1.get(), t2.get())


def cancel_ticket_screen():

	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(15, 3, 102, 16)

		d.add(40, 2, WLabel("\033[1mCancel Ticket\033[0m"))

		d.add(32, 4, WLabel("Enter PNR:"))
		t1 = WTextEntry(10, "")
		d.add(57, 4, t1)

		b = WButton(28, "Confirm")
		d.add(37, 10, b)
		b.finish_dialog = 1

		d.loop()
	return t1.get()


def ticket_history_screen(ret_table):
	with Context():
		Screen.attr_color(C_WHITE, C_BLUE)
		Screen.cls()
		Screen.attr_reset()

		d = Dialog(8, 3, 102, 16)
		d.add(41, 2, "\033[1mYour booked tickets are:\033[0m")

		cnt = 0
		curr = 0
		store = -1
		# for row in ret_table:
		x = PrettyTable()
		x.field_names = ["PNR", "Train Number", "Train Name", "Source", "Destination", "Date", "Seats", "Amount", "Booking Status"]
		for row in ret_table:
			x.add_row(row[0:1] + row[2:3] + row[4:8] +
			          tuple([(len(row[8]['ticket']))]) + row[9:])
		table = x.get_string().split("\n")
		for i in range(len(table)):
			d.add(3, curr + 4 + i + 2, table[i])
			i += 1
		
		b = WButton(28, "Confirm")
		d.add(43, 30, b)
		b.finish_dialog = 1

		res = d.loop()
	return res


def dialog_screen(text):
	with Context():
		d = DMultiEntry(25, 3, [text], title="Message")
		d.result()
	return

# res = ticket_history_screen([["", "", "", "", "", "", "", "", "", "", ""]])
# # res = view_trains_out_screen('LDH', 'ASR', [])
# # res = check_avail_screen_out('LDH', "ASR", "26/03/2001", [[1, "Hello", 232], [2, "World", 323]], [[222, 1, 2, 3, 4, 23], [222, 2, 3, 4, 32, 2]])
# print("Result:", res)