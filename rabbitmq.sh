script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
echo input rabbitmq_appuser_password is missing
exit
fi

   func_print_head  " download erlang repo "
  curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
   func_stat_check $?

    func_print_head " download rabbitmq repo "
     curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
      func_stat_check $?

    func_print_head " install erlang & rabbitmq "
  yum install erlang -y rabbitmq-server -y &>>$log_file
 func_stat_check $?


  func_print_head "start rabbitmq service"
   systemctl enable rabbitmq-server &>>$log_file
   systemctl start rabbitmq-server &>>$log_file
    func_stat_check $?

  func_print_head "add application passwords in rabbitmq"
  rabbitmqctl add_user roboshop " ${rabbitmq_appuser_password} " &>>$log_file
  rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$log_file
 func_stat_check $?



