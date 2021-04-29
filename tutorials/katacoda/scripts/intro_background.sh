#!/bin/bash
apt update;
apt -y install python3-pip;

echo "done" >> /opt/.pipdep;

yes | pip3 install tensorflow==2.4.1;
yes | pip3 install numpy==1.20.2;

echo "done" >> /opt/.packages;