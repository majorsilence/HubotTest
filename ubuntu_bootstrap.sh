#!/usr/bin/env bash
set -e # exit on first error
set -u # exit on using unset variable

function initilize_ubuntu()
{

    apt-get upgrade -y
    apt-get install npm node nodejs git redis-server -y
    ln -s /usr/bin/nodejs /usr/bin/node
    npm install -g hubot coffee-script yo generator-hubot forever forever-service
    cd /root

}


function copy_hubot_yoda
{
	mkdir -p /opt/hubot/yoda

	if [ -d "/vagrant" ]; then
		# runnint in vagrant, copy file
		cp -R /vagrant/yoda/* /opt/hubot/yoda
	fi
	
}

function upstart_script()
{

    HUBOTYODA="/etc/init/hubotyoda.conf"
    rm -rf $HUBOTYODA
    touch $HUBOTYODA

    echo "# hubot" >> $HUBOTYODA
    echo "" >> $HUBOTYODA
    echo "description \"Hubot Slack bot\"" >> $HUBOTYODA
    echo "author \"Peter Gill <peter@majorsilence.com>\"" >> $HUBOTYODA
    echo "" >> $HUBOTYODA
    echo "start on filesystem or runlevel [2345]" >> $HUBOTYODA
    echo "stop on runlevel [!2345]" >> $HUBOTYODA
    echo "" >> $HUBOTYODA
    echo "# Path to Hubot installation" >> $HUBOTYODA
    echo "env HUBOT_DIR='/opt/hubot/yoda'" >> $HUBOTYODA
    echo "env HUBOT='bin/hubot'" >> $HUBOTYODA
    echo "env ADAPTER='slack'" >> $HUBOTYODA
    echo "env LOGFILE='/var/log/hubot/hubot.log'" >> $HUBOTYODA
    echo "# Name (and local user) to run Hubot as" >> $HUBOTYODA
    echo "env HUBOT_USER='hubot'" >> $HUBOTYODA
    echo "# httpd listen port" >> $HUBOTYODA
    echo "env PORT='8080'" >> $HUBOTYODA
    echo "" >> $HUBOTYODA
    echo "# Slack specific variables" >> $HUBOTYODA
    echo "env HUBOT_SLACK_TOKEN=<YOUR TOKEN HERE>" >> $HUBOTYODA
    echo "" >> $HUBOTYODA
    echo "# Keep the process alive, limit to 5 restarts in 60s" >> $HUBOTYODA
    echo "respawn" >> $HUBOTYODA
    echo "respawn limit 5 60" >> $HUBOTYODA
    echo "" >> $HUBOTYODA
    echo "exec start-stop-daemon --start --chuid \${HUBOT_USER} --chdir \${HUBOT_DIR} \
--exec \${HUBOT_DIR}\${HUBOT} -- --name \${HUBOT_USER} --adapter \${ADAPTER} \
2>&1 | ( while read line; do echo \"\$(date): \${line}\"; done ) > \${LOGFILE}" >> $HUBOTYODA

    service hubotyoda start 
}


configurefirewall()
{
	yes | ufw enable
	ufw allow 8080/tcp
	yes | ufw allow ssh

	# requires iptables-persistent is installed
	# See http://www.thomas-krenn.com/en/wiki/Saving_Iptables_Firewall_Rules_Permanently
	echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
	echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
	apt-get install -y iptables-persistent
	iptables-save > /etc/iptables/rules.v4

	/var/lib/dpkg/info/iptables-persistent.postinst;
}

configurefail2ban()
{
	# fail2ban - protect ssh
	# See https://www.digitalocean.com/community/articles/how-to-protect-ssh-with-fail2ban-on-ubuntu-12-04 if you want to make any edits to the config
	apt-get install -y fail2ban
	rm -rf /etc/fail2ban/jail.local
	cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

	service fail2ban restart
}


initilize_ubuntu
configurefirewall
configurefail2ban
copy_hubot_yoda
upstart_script

