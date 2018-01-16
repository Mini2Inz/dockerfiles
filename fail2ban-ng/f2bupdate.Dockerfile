ARG F2BIMG=fail2ban-ng

FROM ${F2BIMG}
COPY fail2ban/fail2ban/client/fail2banserver.py /usr/src/fail2ban/fail2ban/client/fail2banserver.py