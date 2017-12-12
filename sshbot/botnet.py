from subprocess import call
import argparse

class BotnetConfig:
	def __init__(self, bot_count, host, port):
		self.bot_count = bot_count
		self.host = host
		self.port = port

def parse_config(configline):
	config_args = configline.split(" ")
	return BotnetConfig(
		int(config_args[0]), 
		config_args[1], 
		int(config_args[2]) if len(config_args) == 3 else 22)

def run_botnet():
	botId = 0
	with open("botnet.config", "r") as f:
		configline = f.readline()
		while configline != "":
			config = parse_config(configline)			

			for i in range(0, config.bot_count):
				botId += 1
				result = call(
					["docker", "run", "-d", "--name", args.container + str(botId), args.image, 
					"python", "bot.py", config.host, "-p", str(config.port)])
				print(result)

			configline = f.readline()

parser = argparse.ArgumentParser()
parser.add_argument("--stop", type=bool, default=False)
parser.add_argument("--bots", type=int, help="number of containers with bots to stop", default=0)
parser.add_argument("-i","--image", type=str, default="sshbot:latest")
parser.add_argument("-c","--container", type=str, default="sshbot")
args = parser.parse_args();

if args.stop == False:
	run_botnet()
else:
	if args.bots <= 0:
		raise Exception("Bots number must be greater then 0")

	for i in range(1, args.bots+1):
		call(["docker", "stop", args.container +str(i)])
		call(["docker", "rm", args.container + str(i)])


