#!/bin/bash

# TO DO:
# Get Cron Working
# Add custom logo ( inject /root/custom_logo.png:/usr/local/searxng/searx/static/themes/simple/img/searxng.png as a docker-compose volume for searxng )
# Add TOR upstream routing
# Add DNS Leak Exposer

# Prompt the user for specifics of the Instance
echo "Please enter the hostname of this instance."
read hostname
echo "Please enter an email address for LetsEncrypt to use."
read email
echo "How should this instance appear in browser tabs?"
read instanceName

# Install System Software
sudo apt update && apt upgrade -y
sudo apt install git docker.io docker-compose -y

# Clone and navigate to the Repository
sudo cd /root
sudo git clone https://github.com/searxng/searxng-docker.git
sudo cd searxng-docker

# Configure Environment Variables
sudo echo "SEARXNG_HOSTNAME=${hostname}" >> .env
sudo echo "LETSENCRYPT_EMAIL=${email}" >> .env

# Configure settings.yml
sudo sed -i "s|ultrasecretkey|$(openssl rand -hex 32)|g" searxng/settings.yml
sudo sed -i "s|image_proxy|true|g" searxng/settings.yml
sudo echo 'general:' >> searxng/settings.yml
sudo echo "  instance_name: '${instanceName}'" >> searxng/settings.yml
sudo echo 'search:' >> searxng/settings.yml
sudo echo '  autocomplete: "duckduckgo"' >> searxng/settings.yml
sudo echo '  formats:' >> searxng/settings.yml
sudo echo '    - html' >> searxng/settings.yml
sudo echo '    - json' >> searxng/settings.yml
sudo echo 'ui:' >> searxng/settings.yml
sudo echo '  theme_args:' >> searxng/settings.yml
sudo echo '    simple_style: dark' >> searxng/settings.yml

# Configure docker-compose.yaml
sed -i '/searxng:rw/a \
      - /root/custom_logo.png:/usr/local/searxng/searx/static/themes/simple/img/searxng.png' docker-compose.yaml

# Initialize Crontab
#crontab -l > searxngCron

# Write to Crontab
#echo "@reboot docker-compose -f /root/searxng-docker/docker-compose.yaml up -d" >> searxngCron

# Save Crontab
#crontab searxngCron

#sudo reboot