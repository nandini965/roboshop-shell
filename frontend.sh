script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "install nginx
yum install nginx -y &>>$log_file
 func_stat_check $?

func_print_head "copy configuration file"
cp $script_path /etc/nginx/default.d/roboshop. &>>$log_file
 func_stat_check $?

func_print_head "clean old content"
rm -rf /usr/share/nginx/html/* &>>$log_file
 func_stat_check $?
func_print_head "extract app content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_stat_check $?

func_print_head " unzip frontend content"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
 func_stat_check $?

func_print_head "start frontend service"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
func_stat_check $?
