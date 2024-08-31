#!/bin/bash
mkdir -p /etc/apache2/conf.d
mkdir -p /opt/mikrotik.upgrade.server
mkdir -p /opt/mikrotik.upgrade.server/tools
mkdir -p /opt/mikrotik.upgrade.server/repo
mkdir -p /opt/mikrotik.upgrade.server/repo/routeros/0.0
mkdir -p /opt/mikrotik.upgrade.server/tools/mikrotik.configs
mkdir -p /var/www/localhost/htdocs/mus
ln -s  /opt/mikrotik.upgrade.server/repo /var/www/localhost/htdocs/mus/repo
mv /etc/crontabs/root /etc/crontabs/root.orig
mv /root/crontabs.root.new /etc/crontabs/root
chmod 0600 /etc/crontabs/root
chown root:root /etc/crontabs/root
mv /root/cond.job.new /opt/mikrotik.upgrade.server/tools/mus-cron-job.sh
mv /etc/apache2/httpd.conf /etc/apache2/httpd.conf.orig
mv /etc/apache2/httpd.new.conf /etc/apache2/httpd.conf
mv /etc/apache2/conf.d/mpm.conf /etc/apache2/conf.d/mpm.conf.orig
mv /etc/apache2/conf.d/mpm.new.conf /etc/apache2/conf.d/mpm.conf
mv /root/mus.conf /etc/apache2/conf.d/
mv /root/upgrade.mikrotik.com.conf /etc/apache2/conf.d/
mv /root/status-update.cgi /var/www/localhost/cgi-bin
chown apache:apache /var/www/localhost/cgi-bin/status-update.cgi
chmod 0554 /var/www/localhost/cgi-bin/status-update.cgi
tar xvfz /root/webserver.data.tar.gz --directory /var/www/localhost/htdocs/mus/
rm /root/webserver.data.tar.gz
version=$( cat /root/version.info )
sed -i "s/VERSION/$version/g" /var/www/localhost/htdocs/mus/index-style/header.html
mv /etc/motd /etc/motd.orig
sed -i "s/VERSION/$version/g" /root/motd.new
mv /root/motd.new /etc/motd
mv /root/mikrotik.sync.repos.sh /opt/mikrotik.upgrade.server/tools/
mv /root/mikrotik.sync.repos.checker.sh /opt/mikrotik.upgrade.server/tools/
mv /root/status.gen.sh /opt/mikrotik.upgrade.server/tools/
mv /root/routeros.raw /opt/mikrotik.upgrade.server/tools/mikrotik.configs/
mv /root/routeros.0.00.conf /opt/mikrotik.upgrade.server/tools/mikrotik.configs/
mv /root/CHANGELOG.0.0 /opt/mikrotik.upgrade.server/repo/routeros/0.0/CHANGELOG
mv /root/last_completed.new /tmp/last_completed
mv /root/mus-documentation.pdf /var/www/localhost/htdocs/mus/doc/
rm /var/www/localhost/htdocs/mus/doc/coming_soon
chmod 0775 /opt/mikrotik.upgrade.server/tools/mikrotik.sync.repos.sh
chmod 0775 /opt/mikrotik.upgrade.server/tools/mikrotik.sync.repos.checker.sh
chmod 0775 /usr/local/bin/status.gen.sh
ln -s /opt/mikrotik.upgrade.server/tools/mikrotik.sync.repos.sh /usr/local/bin/mus-sync
ln -s /opt/mikrotik.upgrade.server/tools/mikrotik.sync.repos.checker.sh /usr/local/bin/mus-start
ln -s /opt/mikrotik.upgrade.server/tools/status.gen.sh /usr/local/bin/mus-status
chown -r apache:apache /var/www/localhost/htdocs/
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
rc-update add sshd 
rc-update add apache2
rc-service sshd start
rc-service apache2 start
rc-update add rsyslog
rc-service rsyslog start
rc-update add crond
rc-service crond start
sleep 15
/usr/local/bin/status.gen.sh
/opt/mikrotik.upgrade.server/tools/mikrotik.sync.repos.checker.sh
echo "****"
echo "'"
echo "Don't forget to set root-ssh password !!!"
echo "*"
echo "****"
echo "*"
echo "first_start.sh completed !"
echo "*"
echo "****"
rc-update del auto_init