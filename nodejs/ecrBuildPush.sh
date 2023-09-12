#!/bin/bash

account=$(aws sts get-caller-identity --query "Account" --output text)
region="us-east-2"
tag="awsredisapp"
repo="ecr-supercache"

docker build -t $tag .
docker tag $tag "$account.dkr.ecr.$region.amazonaws.com/$repo:latest"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin "$account.dkr.ecr.$region.amazonaws.com"
docker push "$account.dkr.ecr.$region.amazonaws.com/$repo:latest"
