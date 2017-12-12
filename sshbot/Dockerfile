FROM python:3.6.3-slim

RUN apt-get update && apt-get install -y ssh-client
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /bot
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY bot.py .