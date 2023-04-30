
script_path=$(dirname $0)
source ${script_path}/common.sh
echo -e "\e[36m<<<<<<<<<<<<<<<<< configuring nodejs <<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[36m<<<<<<<<<<<<<<<<< install nodejs <<<<<<<<<<<<<\e[0m"
yum install nodejs -y
echo -e "\e[36m<<<<<<<<<<<<<<<<< add application user <<<<<<<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m<<<<<<<<<<<<<<<<< create app directory <<<<<<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m<<<<<<<<<<<<<<<<< download app content <<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
echo -e "\e[36m<<<<<<<<<<<<<<<<< unzip app content <<<<<<<<<<<<<\e[0m"
unzip /tmp/user.zip
cd /app
echo -e "\e[36m<<<<<<<<<<<<<<<<< install nodejs dependencies <<<<<<<<<<<<<\e[0m"
npm install
echo -e "\e[36m<<<<<<<<<<<<<<<<< create application directory <<<<<<<<<<<<<\e[0m"
cp $script_path/user.service /etc/systemd/system/user.service
echo -e "\e[36m<<<<<<<<<<<<<<<<< start user service <<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user
echo -e "\e[36m<<<<<<<<<<<<<<<<< copy mongodb repo <<<<<<<<<<<<<\e[0m"
cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m<<<<<<<<<<<<<<<<< install mongodb client <<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[36m<<<<<<<<<<<<<<<<< load schema <<<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.rdevopsb72.store </app/schema/user.js
