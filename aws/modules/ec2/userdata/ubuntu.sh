#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Update the instance packages
apt update && apt upgrade -y

# Required dependencies
apt install -y zip unzip openssl pwgen

# Install the AWS CLI
snap install aws-cli --classic
