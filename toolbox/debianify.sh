#!/bin/bash
cat <<EOF > /etc/apt/sources.list
deb http://ftp.de.debian.org/debian/ unstable main non-free contrib
EOF
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 605C66F00D6C9793
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get  -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' --yes dist-upgrade
cat /home/ubuntu/.ssh/authorized_keys > /root/.ssh/authorized_keys
