# First page :
# Welcome 
import login
import non_login

def main():

	while True:
		uid = -1
		init_value = non_login.init()
	
		if init_value == 1:
			non_login.guest_page()

		elif init_value == 2:
			login_successful = 0; cnt = 0
			while cnt < 3 and not login_successful:
				login_successful = login.login_page()
				cnt += 1
			if login_successful:
				uid = login_successful
				print("Successful login")
				while (True):
					login.after_login(uid)
			else:
				print("Entered 3 incorrect passwords!")
				continue

		elif init_value == 3:
			non_login.register()

		else:
			exit(0)

if __name__ == '__main__':
	main()