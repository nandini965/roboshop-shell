app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_nodejs() {

echo -e "\e[36m>>>>>>>>>>>>>configuring nodejs<<<<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[36m>>>>>>>>>>>>>>install nodejs<<<<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y
echo -e "\e[36m>>>>>>>>>>>>>>add application user<<<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>>>>> create application directory<<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>>> download app content<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app
echo -e "\e[36m>>>>>>>>>>>>>>unzip app content<<<<<<<<<<<<<<<<<<\e[0m"
unzip /tmp/${component}.zip
cd /app
echo -e "\e[36m>>>>>>>>>>>>>>install nodejs dependencies<<<<<<<<<<<<<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>>>>>>>copy cart client<<<<<<<<<<<<<<<<<<\e[0m"
cp $script_path/${component}.service /etc/systemd/system/${component}.service
echo -e "\e[36m>>>>>>>>>>>>>> start cart service<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}
}