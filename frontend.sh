
script_path=$(dirname $0)
source ${script_path}/common.sh

source common.sh
yum install nginx -y
cp $script_path /etc/nginx/default.d/roboshop.conf
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
systemctl restart nginx
systemctl enable nginx