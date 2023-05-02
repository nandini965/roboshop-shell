script=$(realpath "$0")
script_path=$(dirname $0)
source common.sh
echo -e "\e[36m>>>>>>>>>>>>> install golang -y <<<<<<<<<<<<<<\e[0m"
yum install golang -y
echo -e "\e[36m>>>>>>>>>>>>> add user application <<<<<<<<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>>>> create app directory <<<<<<<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>> download app content <<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
echo -e "\e[36m>>>>>>>>>>>>> unzip app content <<<<<<<<<<<<<<\e[0m"
unzip /tmp/dispatch.zip
cd /app
go mod init dispatch
go get
go build
echo -e "\e[36m>>>>>>>>>>>>> copy systemd <<<<<<<<<<<<<<\e[0m"
cp $script_path/dispatch.service /etc/systemd/system/dispatch.service
echo -e "\e[36m>>>>>>>>>>>>> start dispatch.service <<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch