#!/usr/bin/env bash

###############################################################################
#
# Simple Ubuntu development VM for Java and Python (maybe)
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
apt-get install -y zip
apt-get install -y unzip

echo "Installing tmux 2.0..."
apt-get update
apt-get install -y tmux

echo "Setting locale..."
echo "LC_ALL=\"en_US.UTF8\"" > /etc/default/locale

echo "Installing project pre-requisites..."

echo "Setting project PATH..."

echo "Starting ssh-agent..."
echo 'eval `ssh-agent -s`' >> /home/vagrant/.bashrc

echo "TODO install zsh and configure"
echo "TODO install nvim and configure"
echo "TODO clone dotfiles and install"
