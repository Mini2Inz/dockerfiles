FROM python:3.6.3-slim

WORKDIR /usr/src/fail2ban

RUN apt-get update && apt-get install -y geoip-bin

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ADD fail2ban/ .
RUN ./setup.py install

# fail2ban-client interactive mode fix/hack
RUN sed -i 's/return eval(input(PROMPT))/return input(PROMPT)/' /usr/local/lib/python3.6/site-packages/fail2ban/client/fail2banclient.py