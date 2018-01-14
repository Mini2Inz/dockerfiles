FROM phusion/baseimage:0.9.22

CMD ["/sbin/my_init"]

# run ssh server
RUN rm -f /etc/service/sshd/down

RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

RUN apt-get update && apt-get install -y \
	software-properties-common \
	python-software-properties \
	geoip-bin \
	iptables \
	python-pip

#RUN add-apt-repository ppa:jonathonf/python-3.6
#RUN apt-get update && apt-get install -y python3.6

WORKDIR /usr/src/fail2ban

#COPY requirements.txt ./
#RUN pip install --no-cache-dir -r requirements.txt

COPY fail2ban/ .
RUN ./setup.py install

ARG F2BCONF=empty
ARG JAILCONF=sshd

COPY config/f2b/${F2BCONF}/fail2ban.local /etc/fail2ban/ 
COPY config/jails/${JAILCONF}/jail.local /etc/fail2ban/

# https://github.com/phusion/baseimage-docker#adding_additional_daemons
RUN mkdir /etc/service/fail2ban-ng
COPY fail2ban-ng-debug.sh /etc/service/fail2ban-ng/run
RUN chmod +x /etc/service/fail2ban-ng/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*