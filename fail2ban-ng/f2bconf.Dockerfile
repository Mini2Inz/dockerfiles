ARG F2BIMG=fail2ban-ng

FROM ${F2BIMG}

ARG F2BCONF=empty
ARG JAILCONF=ssh_lighty
ARG HOSTS=hosts

COPY config/f2b/${F2BCONF} /etc/fail2ban/fail2ban.local
COPY config/jails/${JAILCONF} /etc/fail2ban/jail.local
COPY config/f2b/${HOSTS} /etc/fail2ban/hosts

