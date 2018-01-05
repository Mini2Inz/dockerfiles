ARG F2BIMG=fail2ban-ng

FROM ${F2BIMG}

ARG F2BCONF=empty
ARG JAILCONF=sshd

COPY config/f2b/${F2BCONF}/fail2ban.local /etc/fail2ban/ 
COPY config/jails/${JAILCONF}/jail.local /etc/fail2ban/