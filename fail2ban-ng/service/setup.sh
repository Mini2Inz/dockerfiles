touch /var/log/auth.log

cd /service
mkdir /etc/service/fail2ban-ng/
cp fail2ban-ng.sh /etc/service/fail2ban-ng/run
chmod +x /etc/service/fail2ban-ng/run

mkdir /etc/service/lighttpd/
cp lighttpd.sh /etc/service/lighttpd/run
chmod +x /etc/service/lighttpd/run

# setup lighttpd
mkdir -p /etc/lighttpd/
cp lighttpd.conf /etc/lighttpd/

mkdir -p /var/www/servers/lighty/bitcoins/
cp index.html /var/www/servers/lighty/
cp bitcoin /var/www/servers/lighty/bitcoins/

htpasswd -m -b -c /etc/lighttpd/lighttpd.user bitcoin givemebitcoin

lighttpd -t -f /etc/lighttpd/lighttpd.conf
