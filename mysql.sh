script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
echo input mysql_root_password is missing
exit 1
fi

func_print_head "disable mysql client"
dnf module disable mysql -y &>>$log_file
func_stat_check $?

 func_print_head "copy mysql repo"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_stat_check $?

func_print_head "install app content"
yum install mysql-community-server -y &>>$log_file
func_stat_check $?

 func_print_head "start mysql"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
func_stat_check $?

func_print_head "reset password"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file
func_stat_check $?