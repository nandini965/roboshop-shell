script=$(realpath "$0")
script_path=$(dirname $"script")
source common.sh
yum install mongodb-org -y
cp mongo.repo /etc/yum.repos.d/mongo.repo
systemctl enable mongod
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
systemctl restart mongod


