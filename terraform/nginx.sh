#!/bin/bash
yum install -y nginx
systemctl start nginx
systemctl enable nginx

echo "Hello from Nginx" > /usr/share/nginx/html/index.html