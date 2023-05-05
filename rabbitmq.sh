script=$(realpath "$0")
script_path=$(dirname $0)
source common.sh
rabbitmq_appuser_password=$1
echo -e "\e[36m>>>>>>>>>>>>> download erlang repo <<<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
echo -e "\e[36m>>>>>>>>>>>>> install erlang -y <<<<<<<<<<<<<<\e[0m"
yum install erlang -y
echo -e "\e[36m>>>>>>>>>>>>> download rabbitmq repo <<<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
echo -e "\e[36m>>>>>>>>>>>>> install rabbitmq <<<<<<<<<<<<<<\e[0m"
yum install rabbitmq-server -y
echo -e "\e[36m>>>>>>>>>>>>> start rabbitmq.service <<<<<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
echo -e "\e[36m>>>>>>>>>>>>> useradd  <<<<<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / ${rabbitmq_appuser_password}