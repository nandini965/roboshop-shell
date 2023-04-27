yum install mongodb-org -y
cp mongo.repo /etc/yum.repos.d/mongo.repo
systemctl enable mongod
systemctl start mongod
### update 127.0.0.1 to 0.0.0.0

