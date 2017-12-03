FROM python:3.6.3-slim

WORKDIR /usr/src/fail2ban

RUN apt-get update

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ADD fail2ban/ .
RUN ./setup.py install