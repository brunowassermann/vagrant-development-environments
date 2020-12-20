#!/usr/bin/env bash

echo "Installing Poetry..."
sudo apt-get install -y python3-distutils
sudo apt-get install -y python3-apt
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3
echo '' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$HOME/.poetry/bin' >> /home/vagrant/.bashrc
echo "TODO add support for zsh"
