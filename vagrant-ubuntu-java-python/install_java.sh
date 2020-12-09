#!/usr/bin/env bash

echo "Installing Java..."
curl -s "https://get.sdkman.io" | bash
source '/home/vagrant/.sdkman/bin/sdkman-init.sh' && yes | sdk install java 11.0.9.open-adpt
echo "TODO pick JDK version from env var"
