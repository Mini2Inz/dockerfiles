#!/bin/sh
cd /usr/src/fail2ban
exec python -m fail2ban.client.fail2banserver --vsdebug -xf start
