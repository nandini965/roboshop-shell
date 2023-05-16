script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "install nginx
yum install nginx -y &>>$log_file
 func_stat_check $?

func_print_head "copy configuration file"
cp $script_path /etc/nginx/default.d/roboshop. &>>$log_file
 func_stat_check $?

func_print_head "remove old content"
rm -rf /usr/share/nginx/html/* &>>$log_file
 func_stat_check $?
func_print_head "download frontned content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_stat_check $?

func_print_head "create file"
cd /usr/share/nginx/html &>>$log_file
 func_stat_check $?

func_print_head " unzip frontend content"
unzip /tmp/frontend.zip &>>$log_file
 func_stat_check $?

func_print_head "start frontend service"

systemctl enable nginx
systemctl restart nginx