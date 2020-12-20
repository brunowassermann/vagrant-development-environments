# Sample Vagrant Development Environments

A few simple setups. Started with a headless Vagrant Ubuntu VM as well as
one that offers a GUI. More recently, added a Vagrant VM to play with remote development of Java and Python using Visual Studio Code.

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

Note: This setup may be out-of-date by now.

## Vagrant VM with GUI

For this, I have created my own Vagrant box as follows (adapted instructions from
<http://aruizca.com/steps-to-create-a-vagrant-base-box-with-ubuntu-14-04-desktop-gui-and-virtualbox/>).

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

  ```bash
  sudo apt-get install -y dkms
  sudo apt-get install -y build-essential linux-headers-$(uname -r)
  ```

  * With VM running, go to Devices -> Install Guest Additions CD image.
  * In case this does not work:

  ```bash
  sudo mount /dev/cdrom /mnt
  cd /mnt
  sudo ./VBoxLinuxAdditions.run
  sudo reboot
  ```

* Bring OS installation up-to-date:

  ```bash
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo shutdown -r now
  ```

* Once rebooted, add vagrant user to sudoers:

  ```bash
  sudo su -
  visudo
  vagrant ALL=(ALL) NOPASSWD:ALL
  ```

* Install Vagrant public keys:

  ```bash
  mkdir -p /home/vagrant/.ssh
  wget --no-check-certificate
  https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O
  /home/vagrant/.ssh/authorized_keys
  chmod 0676 /home/vagrant/.ssh
  chmod 0600 /home/vagrant/.ssh/authorized_keys
  chown -R vagrant /home/vagrant/.ssh
  ```

* Install and configure ssh server:

  ```bash
  sudo apt-get install -y openssh-server
  sudo vi /etc/ssh/sshd_config
  ```

  * Ensure the following are set:
    * port 22
    * PubkeyAuthentication yes
    * AuthorizedKeysFile %h/.ssh/authorized_keys
    * PermitEmptyPasswords no

  ```bash
  service ssh restart
  ```

* Compact:

  ```bash
  sudo dd if=/dev/zero of=/EMPTY bs=1M
  sudo rm -f /EMPTY
  # Shutdown the machine
  ```

* Create Vagrant base box and install (use the name of the VirtualBox VM):

  ```bash
  vagrant package --base Ubuntu-14.04.03-64-Desktop
  vagrant box add Ubuntu-14.04.03-64-Desktop package.box
  vagrant init Ubuntu-14.04.03-64-Desktop
  ```

* Enable gui and Vagrantfile.
* Edit Vagrantfile as required.
* Enjoy.

* To Dos:
  * May need to open settings in VirtualBox and disable and then enable
    USB before this works. Need to figure out what is going on here.
  * May want to use a more lightweight desktop environment (e.g., xfce).
  * Consider retesting and bringing clipboard support up-to-date (might work
    out-of-the-box today).
  
## Visual Studio Code Remove Development

Using Docker containers for that may be more convenient, but I wanted to give
remote development with virtual machines a try to simulate a common setup I face
at work (powerful VM to handle processing large amounts of data and/or run lots
of long-running Docker containers). Would be nice to have a fun alternative to
working on these setups via tmux or vnc.

I have played with a simple Java project built using Gradle and an even simpler
Python project using poetry to manage dependencies and virtual environments.

You need to install any required extensions on the remote VS Code server runtime
(e.g., Java language support, linters, language formatters, gradle, and so on)
and it looks like there is some setup and loading going on in the background
that takes some time before things start working in your window as expected.
Overall, though, this allows for a pretty sweet remote development setup.

One little quirk I noticed when trying remote Python development was that VS
Code would only pick up on my virtual environment when I opened my project
folder using `code .`. That is, first I set up the venv using something like
`poetry shell` and then had to run the command to open the local directory in VS
Code for it to be picked up.
