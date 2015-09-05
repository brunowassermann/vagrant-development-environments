#!/usr/bin/env bash

###############################################################################
#
# Simple Ubuntu development VM
# Version 0.1
# Author Bruno Wassermann
#
###############################################################################

echo "Setting up nameserver..."
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

echo "Running update and installing common tools..."
apt-get update
apt-get install -y xclip
apt-get install -y vim
apt-get install -y curl
apt-get install -y git

echo "Installing tmux 2.0..."
apt-get install -y python-software-properties software-properties-common
add-apt-repository -y ppa:pi-rho/dev
apt-get update
apt-get install -y tmux

echo "Setting locale..."
echo "LC_ALL=\"en_US.UTF8\"" > /etc/default/locale

echo "Installing project pre-requisites..."

echo "Setting project PATH..."

echo "Installing Java..."
apt-get install -y openjdk-7-jdk
echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> /home/vagrant/.bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin" >> /home/vagrant/.bashrc

echo "Starting ssh-agent..."
echo 'eval `ssh-agent -s`' >> /home/vagrant/.bashrc
