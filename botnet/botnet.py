#!/bin/python3

from subprocess import call
import argparse
import asyncio
from time import sleep

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
    if args.bash:
        proc = await asyncio.create_subprocess_exec(
            "docker", "run", "-d", "--name", args.container + str(botId), args.image,
            "/bot/bot.sh", "root@"+config.host, "-p", str(config.port))
    else:
        proc = await asyncio.create_subprocess_exec(
            "docker", "run", "-d", "--name", args.container + str(botId), args.image,
            "python", "bot.py", config.host, "-p", str(config.port))
    code = await proc.wait()
    if code != 0: print(str(botId) + " returned " + str(code))

def run_botnet(args):
    botId = args.id
    loop = asyncio.get_event_loop()
    tasks = []
    with open("botnet.config", "r") as f:
        configline = f.readline()
        while configline != "":
            config = parse_config(configline)

            for i in range(0, config.bot_count):
                if args.sleeptime > 0.0 and (botId - 1)%5 == 0: sleep(args.sleeptime)
                botId += 1
                tasks.append(asyncio.ensure_future(start_bot(botId, config, args)))

            configline = f.readline()

    loop.run_until_complete(asyncio.gather(*tasks))
    loop.close()

def stop_bots(containers):
    containers.insert(0,"docker")
    containers.insert(1, "stop")
    call(containers)
    containers.pop(1)
    containers.insert(1, "rm")
    call(containers)

def stop_botnet(args):
    if args.bots <= 0:
        raise Exception("Bots number must be greater then 0")

    cntnrs = []
    for i in range(1, args.bots+1):
        cntnrs.append(args.container + str(i))

    stop_bots(cntnrs)


parser = argparse.ArgumentParser()
parser.add_argument("-b", "--bots", type=int, help="number of containers with bots to stop", default=0)
parser.add_argument("-i", "--image", type=str, default="sshbot:latest")
parser.add_argument("-c", "--container", type=str, default="sshbot")
parser.add_argument("--bash", type=bool, default=True)
parser.add_argument("--id", type=int, help="last id used for container", default=0)
parser.add_argument("-t", "--sleeptime", type=float, default=0.0, help="sleep time between containers startup")
args = parser.parse_args()

if args.bots == 0:
    run_botnet(args)
else:
    stop_botnet(args)
