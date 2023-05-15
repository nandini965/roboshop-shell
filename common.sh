app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log

func_print_head() {
echo -e "\e[36m>>>>>>>>>>>>> $* <<<<<<<<<<<<<<<<<<\e[0m"
echo -e "\e[36m>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<\e[0m" &>>$log_file
}

   func_stat_check() {
if [ $1 -eq 0 ]; then
   echo -e "\e[32mSUCCESS\e[0m"
else
   echo -e "\e[31mFAILURE\e[0m"
   echo "refer log_file /tmp/roboshop.log/ for more information"
   exit 1
fi
}
 func_schema_setup() {
if [ "$schema_setup" == "mongo" ]; then
func_print_head "copy mongodb repo"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_stat_check $?

func_print_head "install mongodb client"
 yum install mongodb-org-shell - &>>$log_file
 func_stat_check $?

func_print_head "load schema"
 mongo --host mongodb_dev.rdevopsb72.store </app/schema/${component}.js &>>$log_file
func_stat_check $?
fi
 if [ "$schema_setup" == "mysql" ]; then
 func_print_head " install mysql client "
yum install mysql -y &>>$log_file
func_stat_check $? &>>$log_file

 func_print_head "load schema"
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$log_file
func_stat_check $?
 fi
 }
 func_app_prereq() {
 func_print_head "add application user"
 id ${app_user} &>>/tmp/roboshop.log
if [ $? -ne 0 ]; then
 useradd ${app_user} &>>/tmp/roboshop.log
 fi
 func_stat_check $?

 func_print_head "create application directory"
 rm -rf /app &>>$log_file
 mkdir /app &>>$log_file
 func_stat_check $?

 func_print_head "download application content"
 curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
 func_stat_check $?

 func_print_head "unzip application content"
 cd /app &>>$log_file
 unzip /tmp/${component}.zip &>>$log_file
 func_stat_check $?

 }


 func_systemd_setup() {
 func_print_head "setup systemd service"
 cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
 func_stat_check $?

 func_print_head "start ${component} service"
 systemctl daemon-reload
 systemctl enable ${component}
 systemctl restart ${component}
 func_stat_check $?
}

 func_nodejs() {
func_print_head "configuring nodejs"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
func_stat_check $?

func_print_head "install nodejs"
yum install nodejs -y &>>$log_file
func_stat_check $?

func_app_prereq

func_print_head "install nodejs dependencies"
npm install &>>$log_file
func_stat_check $?

func_schema_setup
func_systemd_setup



}

func_java() {

func_print_head "install maven"
yum install maven -y &>>$log_file
func_stat_check $?

func_app_prereq
func_print_head "download maven dependencies"
mvn clean package &>>$log_file
func_stat_check $?

mv target/${component}-1.0.jar ${component}.jar &>>$log_file
func_systemd_setup

}


func_python() {
   func_print_head "install python3"
  yum install python36 gcc python3-devel -y &>>log_file
  func_stat_check $?

  func_app_prereq


  func_print_head "download app content"
  curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>$log_file
  func_stat_check $?

  func_print_head "install app requirements"
  pip3.6 install -r requirements.txt &>>$log_file
  func_stat_check $?

  func_print_head "update passwords in system service file"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/${component}.service &>>$log_file
  func_stat_check $?
 func_systemd_setup

}
func_erlang() {

    func_print_head  "download erlang repo"
  curl -s https://packagecloud.io/install/repositories/component/erlang/script.rpm.sh | bash
   func_stat_check $?

    func_print_head "install erlang -y"
  yum install erlang -y
   func_stat_check $?

  func_print_head "download component repo"
  curl -s https://packagecloud.io/install/repositories/${component}/${component}-server/script.rpm.sh | bash
   func_stat_check $?

   func_print_head "install component service"
  yum install ${component}-server -y
   func_stat_check $?

  func_systemd_setup

  func_print_head "useradd"
  componentctl add_user roboshop ${rabbitmq_appuser_password}
  componentctl set_permissions -p / roboshop ".*" ".*" ".*"
 func_stat_check $?
 }
