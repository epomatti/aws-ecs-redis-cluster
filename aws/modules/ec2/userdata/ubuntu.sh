#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Update the instance packages
apt update && apt upgrade -y

# Required dependencies
apt install -y zip unzip openssl pwgen

# Install the AWS CLI
architecture="aarch64"
curl "https://awscli.amazonaws.com/awscli-exe-linux-$architecture.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
