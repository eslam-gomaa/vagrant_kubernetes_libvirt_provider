#!/bin/bash
sudo sed -i -e 's/PS1=.*deb.*/PS1=\"\${debian_chroot:+(\$debian_chroot)}\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ 🍉 \"/g' /home/vagrant/.bashrc
sudo sed -i -e 's/PS1=.*deb.*/PS1=\"\${debian_chroot:+(\$debian_chroot)}\\[\\033[01;33m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ 👻 \"/g' /root/.bashrc
