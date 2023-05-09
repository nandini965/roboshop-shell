script_path=$(dirname $0)
script=$(realpath "$0")
source ${script_path}/common.sh

yum install mongodb-org -y
cp mongo.repo /etc/yum.repos.d/mongo.repo
systemctl enable mongod
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
systemctl restart mongod


