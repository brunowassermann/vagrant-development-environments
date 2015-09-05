# Sample Vagrant Development Environments

A few simple setups. Currently contains a headless Vagrant Ubuntu VM as well as
one that offers a GUI.

A few notes:

## Synced folder
This Vagrantfile sets up a synced folder with the host. It maps the 
directory specified in an environment varialbe called 'SYNCED_FOLDER' to 
'/home/vagrant/development'. If SYNCED_FOLDER is not set, it will map to the
hosts's /tmp directory by default.

## Copying to the system clipboard
In order to be able to access the system clipboard in a headless Ubuntu VM, I
enable X11Forwarding in the Vagrantfile, run XQuartz on the OS X host and
install xclip in the VM. 
In addition, I have a .tmux.conf that makes use of xclip in order to copy its
selection buffer to the system clipboard.

## Vagrant VM with GUI
For this, I have created my own Vagrant box as follows (adapted instructions from
http://aruizca.com/steps-to-create-a-vagrant-base-box-with-ubuntu-14-04-desktop-gui-and-virtualbox/).

* Define VirtualBox VM.
  * Download appropriate Ubuntu ISO.
  * Define RAM (I use 4 GB).
  * Set shared clipboard to bidirectional.
  * Video memory 128 MB.
  * Define first network interface (adapter 1) to be NAT adapter.
  * Use dynamic virtual disk (VMDK). 
  * Load ISO as part of VM disk and and install.
  * Set user name and password to be 'vagrant'.
  * Unload ISO and restart or change boot order.
* Install Guest Additions:
  ```
  $ sudo apt-get install -y dkms
  $ sudo apt-get install -y build-essential linux-headers-$(uname -r)
  ```
  * With VM running, go to Devices -> Install Guest Additions CD image.
  * In case this does not work:
  ```
  $ sudo mount /dev/cdrom /mnt
  $ cd /mnt
  $ sudo ./VBoxLinuxAdditions.run
  $ sudo reboot
  ```
* Bring OS installation up-to-date:
  ```
  $ sudo apt-get update -y
  $ sudo apt-get upgrade -y
  $ sudo shutdown -r now
  ```
* Once rebooted, add vagrant user to sudoers:
  ```
  $ sudo su -
  $ visudo
  $ vagrant ALL=(ALL) NOPASSWD:ALL
  ```
* Install Vagrant public keys:
  ```
  $ mkdir -p /home/vagrant/.ssh
  $ wget --no-check-certificate
  https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O
  /home/vagrant/.ssh/authorized_keys
  $ chmod 0700 /home/vagrant/.ssh
  $ chmod 0600 /home/vagrant/.ssh/authorized_keys
  $ chown -R vagrant /home/vagrant/.ssh
  ```
* Install and configure ssh server:
  ```
  $ sudo apt-get install -y openssh-server
  $ sudo vi /etc/ssh/sshd_config
  ```
  * Ensure the following are set:
    * port 22
    * PubkeyAuthentication yes
    * AuthorizedKeysFile %h/.ssh/authorized_keys
    * PermitEmptyPasswords no
  ```
  $ service ssh restart
  ```
* Compact:
  ```
  $ sudo dd if=/dev/zero of=/EMPTY bs=1M
  $ sudo rm -f /EMPTY
  # Shutdown the machine
  ```
* Create Vagrant base box and install (use the name of the VirtualBox VM):
  ```
  $ vagrant package --base Ubuntu-14.04.03-64-Desktop
  $ vagrant box add Ubuntu-14.04.03-64-Desktop package.box
  $ vagrant init Ubuntu-14.04.03-64-Desktop
  ```
* Enable gui and Vagrantfile. 
* Edit Vagrantfile as required.
* Enjoy. 

* Todos
  * May need to open settings in VirtualBox and disable and then enable
    USB before this works. Need to figure out what is going on here.
  * May want to use a more lightweight desktop environment (e.g., xfce).


