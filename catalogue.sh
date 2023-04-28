echo -e "\e[36m>>>>>>>>> configuring nodejs.repos <<<<<<<<<<<\e[0n"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[36m>>>>>>>>>> install nodejs <<<<<<<<<\e[0n"
yum install nodejs -y
echo -e"\e[36m>>>>>>>>>>> application user <<<<<<<<<<<<\e[0n"
useradd roboshop
echo -e "\e[36m>>>>>>>>>>>>> create application directory <<<<<<<<<<<<\e[0n"
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>> download app content <<<<<<<<<<<<<<\e[0n"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
echo -e "\e[36m>>>>>>>>>>>>>>unzip app content<<<<<<<<<<<<<<<<<<\e[0n"
unzip /tmp/catalogue.zip
echo -e "\e[36m>>>>>>>>>>>>>> install nodejs dependencies <<<<<<<<<<<<<\e[0n"
cd /app
npm install
echo -e "\e[36m>>>>>>>>>>>>>>> copy catalogue systemD file <<<<<<<<<<<<<<<<<\e[0n"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service
echo -e "\e[36m>>>>>>>>>>>>>> start catalogue service <<<<<<<<<<<<<\e[0n"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
echo -e "\e[36m>>>>>>>>>>>>>>>>> copy mongodb repo <<<<<<<<<<<<<<<<<\e[0n"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>>>>>> install mongodb client <<<<<<<<<<<<<\e[0n"
yum install mongodb-org-shell -
echo -e "\e[36m>>>>>>>>>>>>>>>> load schema <<<<<<<<<<<<<<<\e[0n"
mongo --host mongodb-dev.rdevopsb72.store /app/schema/catalogue.js




