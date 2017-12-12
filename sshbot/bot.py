from pexpect import pxssh
import argparse
import signal

parser = argparse.ArgumentParser()
parser.add_argument("hostname")
parser.add_argument("-p", "--port", type=int, default=22)
parser.add_argument("-t", "--timeout", type=int, default=3)

args = parser.parse_args()
class GracefulExit:
	now = False
	def __init__(self):
		signal.signal(signal.SIGINT, self.exit_gracefully)
		signal.signal(signal.SIGTERM, self.exit_gracefully)

	def exit_gracefully(self,signum, frame):
		self.now = True


exit = GracefulExit()

while True and not exit.now:
	s = pxssh.pxssh(options={
		                    "StrictHostKeyChecking": "no",
		                    "UserKnownHostsFile": "/dev/null"})
	try:		
		s.login(args.hostname, "root", "12345", 
			port = args.port,
			login_timeout = args.timeout)
		s.logout()

	except pxssh.ExceptionPxssh as e:
		print("Error - pxssh failed")
		print("--------------------------")
		print(e)
		print("--------------------------")
		s.close()
