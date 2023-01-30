#!/bin/bash

# stop cron
/etc/init.d/cron stop

# kill process running by dexsrv
ps -ef | grep dexsrv | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep dexsrv | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep dexsrv | grep -v grep | awk '{print $2}' | xargs kill

# kill process running by /var/www/html
ps -ef | grep /var/www/html | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep /var/www/html | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep /var/www/html | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep /var/www/html | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep /var/www/html | grep -v grep | awk '{print $2}' | xargs kill

sleep 10

# repeat again to make sure
# kill process running by dexsrv
ps -ef | grep dexsrv | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep dexsrv | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep dexsrv | grep -v grep | awk '{print $2}' | xargs kill

# kill process running by /var/www/html
ps -ef | grep /var/www/html | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep /var/www/html | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep /var/www/html | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep /var/www/html | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep /var/www/html | grep -v grep | awk '{print $2}' | xargs kill

sleep 5

# backup html existing
cd /var/www/ && mv html /home/dexip/html-old

# clone from git app-virtualiztic
git clone http://172.16.0.30:9999/virtualiztic/app-virtualiztic.git

# move cloned project to html
mv /var/www/app-virtualiztic /var/www/html

# cd to html and checkout development
cd /var/www/html && git checkout development

# copy file from html/install to server
cd /var/www/html && \
cp install/datafile/* /var/www/html/ && \
cp install/database/db-ve.db /var/www/html/ && \
mysql -u root --password=p@55w0rd < /var/www/html/install/database/virtualiztic.sql && \
#cp install/etc/multipath.conf /etc/multipath.conf && \
#cp install/etc/rc.local /etc/rc.local && \
cp install/etc/snmp/snmpd.conf /etc/snmp/snmpd.conf && \
#cp install/etc/nginx/sites-available/ /etc/nginx/sites-available/ -R && \
cp install/crontabs/root  /var/spool/cron/crontabs/root

# copy optional
cd /home/dexip/html-old/ && \
cp active_directory.json alertconfig.xml api-code.txt  api-code-ver.txt cluster.json config.xml history.json host-location.json  ip_localhost.txt db-ve.db /var/www/html/. && \
cp lcs/* /var/www/html/lcs/.

# running script
cd /var/www/html/ && php install/updatefile/*.php

# change ownership
chmod -R 775 /var/www/html && chown www-data:www-data /var/www/html -R

# run cron
/etc/init.d/cron start
