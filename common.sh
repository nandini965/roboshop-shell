app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")


func_print_head(){
echo -e "\e[36m>>>>>>>>>>>>> $* <<<<<<<<<<<<<<<<<<\e[0m"
}
 func_schema_setup() {
if [ "$schema_setup" == "mongo" ]; then
func_print_head mongodb repos
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
func_print_head "${component} client"
yum install mongodb-org-shell -y
func_print_head "load schema"
mongo --host mongodb-dev.rdevopsb72.store </app/schema/${component}.js
fi
  if [ "$schema_setup" == "mysql" ]; then
   func_print_head " install my sql client "
    yum install mysql -y
   func_print_head " load schema "
   mysql -h mysql-dev.rdevopsb72.store -uroot -p${mysql_root_password} < /app/schema/${component}.sql
   fi
   }

 func_app_prereq() {
 func_print_head "add application user"
 useradd ${app_user}
 func_print_head "create application directory"
 rm -rf /app
 mkdir /app
 func_print_head "download application content"
 curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
 func_print_head "unzip application content"
 cd /app
 unzip /tmp/${component}.zip
 }
 func_systemd_setup() {
 func_print_head "setup systemd service"
 cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
 func_print_head "start ${component} service"
 systemctl daemon-reload
 systemctl enable ${component}
 systemctl restart ${component}

 }

 func_nodejs() {
func_print_head "configuring nodejs"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

func_print_head "install nodejs"
yum install nodejs -y
func_app_prereq
func_print_head "install nodejs dependencies"
npm install
func_schema_setup
func_systemd_setup
}

func_java() {

func_print_head "install maven"
yum install maven -y
if [$? -eq 0]; then
echo -e "\e [32mSUCCESS\e[0m"
else
echo -e "\e [31mFAILURE\e[0m"
fi
func_app_prereq
func_print_head "download maven dependencies"
mvn clean package
if [$? -eq 0]; then
echo -e "\e [32mSUCCESS\e[0m"
else
echo -e "\e [31mFAILURE\e[0m"
fi

mv target/${component}-1.0.jar ${component}.jar
func_schema_setup
func_systemd_setup
}