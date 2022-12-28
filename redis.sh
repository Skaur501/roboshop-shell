PRINT "Install rpm package"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG

PRINT "Enable redis"
dnf module enable redis:remi-6.2 -y &>>$LOG

PRINT "INSTALL REDIS"
yum install redis -y &>>$LOG

PRINT "Configure redis listener"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>$LOG

PRINT "Enable Redis"
systemctl enable redis &>>$LOG

PRINT "Restart Redis"
systemctl restart redis &>>$LOG