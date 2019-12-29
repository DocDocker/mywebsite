#!/bin/bash
yum update -y
yum install git
git clone https://github.com/lucassha/mywebsite.git
cd mywebsite
docker build -t shannon-website .
docker run -d -p 80:8080 shannon-website

