FROM ubuntu:16.04

RUN apt-get update && apt-get install -y ssh-client sshpass
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /bot
COPY bot.sh .
RUN chmod +x bot.sh