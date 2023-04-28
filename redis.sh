echo -e "\e[36m>>>>>>>>>>> install  redis client <<<<<<<<<<<<<\e[0n"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
echo -e "\e[36m>>>>>>>>>> install redis repos <<<<<<<<<<<\e[0n"
yum install redis -y
echo -i -e"/e[36m>>>>>>>>> update redis listen address <<<<<<<<<\e[0n"
sed -i -e 's|127.0.0.1|0.0.0.o|' /etc/redis.conf /etc/redis/redis.conf
echo -e "\e[36m>>>>>>>>>>>>>> start redis service<<<<<<<<<<<\e[0n"
systemctl enable redis
systemctl restart redis