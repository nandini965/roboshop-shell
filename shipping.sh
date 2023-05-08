script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1
echo -e "\e[36m>>>>>>>>>>>>> install maven <<<<<<<<<<<<<<\e[0m"
yum install maven -y
echo -e "\e[36m>>>>>>>>>>>>> add application user <<<<<<<<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>>>>>> create app directory <<<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>>>>>> download app content <<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
echo -e "\e[36m>>>>>>>>>>>>> unzip app content <<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip
cd /app
mvn clean package
echo -e "\e[36m>>>>>>>>>>>>> move shipping content <<<<<<<<<<<<<<\e[0m"
mv target/shipping-1.0.jar shipping.jar
echo -e "\e[36m>>>>>>>>>>>>> copy systemd <<<<<<<<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service
echo -e "\e[36m>>>>>>>>>>>>> download my sql client <<<<<<<<<<<<<<\e[0m"
yum install mysql -y
echo -e "\e[36m>>>>>>>>>> load schema <<<<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.rdevopsb72.store -p${mysql_root_password} < /app/schema/shipping.sql
echo -e "\e[36m>>>>>>>>>> start shipping service <<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping