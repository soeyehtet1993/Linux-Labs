#!/bin/bash
sudo add-apt-repository -y ppa:gns3/ppa
sudo apt update                                
sudo apt install -y gns3-gui gns3-server
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y gns3-iou
