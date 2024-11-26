#!/bin/sh
sudo apt update
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 63667EE74BBA1F0A08A698725BA31D57EF5975CA
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install openjdk-17-jre-headless -y
sudo apt install ca-certificates
sudo apt update
sudo apt install jenkins -y
sudo apt-get update -y
sudo apt update
sudo apt install terraform -y
echo 'clearing screen...' && sleep 5
clear
echo 'jenkins is installed'
echo 'this is the default password :' $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
sudo reboot
