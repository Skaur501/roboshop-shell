COMPONENT=redis
source Common.sh

PRINT "Install rpm package"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG
STAT $?

PRINT "Enable redis"
dnf module enable redis:remi-6.2 -y &>>$LOG
STAT $?

PRINT "INSTALL REDIS"
yum install redis -y &>>$LOG
STAT $?

PRINT "Configure redis listener"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>$LOG
STAT $?

PRINT "Enable Redis"
systemctl enable redis &>>$LOG
STAT $?

PRINT "Restart Redis"
systemctl restart redis &>>$LOG
STAT $?