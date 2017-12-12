from subprocess import call
import argparse
import asyncio

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

async def start_bot(botId, config, args):
	proc = await asyncio.create_subprocess_exec(
		"docker", "run", "-d", "--name", args.container + str(botId), args.image, 
		"python", "bot.py", config.host, "-p", str(config.port))
	returncode = await proc.wait()
	print(returncode)

def run_botnet(args):
	botId = 0
	loop = asyncio.get_event_loop()
	tasks = []
	with open("botnet.config", "r") as f:
		configline = f.readline()
		while configline != "":
			config = parse_config(configline)			

			for i in range(0, config.bot_count):
				botId += 1
				tasks.append(asyncio.ensure_future(start_bot(botId, config, args)))

			configline = f.readline()

	loop.run_until_complete(asyncio.gather(*tasks))
	loop.close()

async def stop_bot(container, botId):
	cntnr = container + str(botId)
	proc = await asyncio.create_subprocess_exec("docker", "stop", cntnr)
	returncode = await proc.wait()
	print(returncode)
	proc2 = await asyncio.create_subprocess_exec("docker", "rm", cntnr)
	returncode2 = await proc2.wait()
	print(returncode2)

def stop_botnet(args):
	if args.bots <= 0:
		raise Exception("Bots number must be greater then 0")

	loop = asyncio.get_event_loop()
	tasks = []
	for i in range(1, args.bots+1):
		tasks.append(asyncio.ensure_future(stop_bot(args.container, i)))
	loop.run_until_complete(asyncio.gather(*tasks))
	loop.close()



parser = argparse.ArgumentParser()
parser.add_argument("--stop", type=bool, default=False)
parser.add_argument("--bots", type=int, help="number of containers with bots to stop", default=0)
parser.add_argument("-i","--image", type=str, default="sshbot:latest")
parser.add_argument("-c","--container", type=str, default="sshbot")
args = parser.parse_args();

if args.stop == False:
	run_botnet(args)
else:
	stop_botnet(args)
