#!/bin/bash

# Capture Verbose Output

set -o errexit
set -o nounset
set -o pipefail

sudo yum update -y
sudo yum install epel-release
sudo yum install ansible
