app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")


print_head(){
echo -e "\e[36m>>>>>>>>>>>>> $* <<<<<<<<<<<<<<<<<<\e[0m"
}
 func_nodejs() {
print_head "configuring nodejs"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "install nodejs"
yum install nodejs -y

print_head "add application user"
useradd ${app_user}

print_head "create application directory"
mkdir /app

print_head "download app content"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip cd /app

print_head "unzip app content"
unzip /tmp/${component}.zip
cd /app

print_head "install nodejs dependencies"
npm install

print_head "copy cart client"
cp $script_path/${component}.service /etc/systemd/system/${component}.service

print_head "start cart service"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}
 }
