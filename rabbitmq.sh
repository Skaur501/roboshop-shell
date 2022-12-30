COMPONENT=rabbitmq
source Common.sh

PRINT " Install repo for erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>$LOG
STAT $?

PRINT "Install erland"
yum install erlang -y &>>$LOG
STAT $?

PRINT "Install RPM package for erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
STAT $?

PRINT "Install rabbitmq"
yum install rabbitmq-server -y &>>$LOG
STAT $?

PRINT "enable Rabbitmq"
systemctl enable rabbitmq-server &>>$LOG
STAT $?

PRINT "reStart Rabbitmq"
systemctl restart rabbitmq-server &>>$LOG
STAT $?

PRINT "Add user"
rabbitmqctl add_user roboshop roboshop123 &>>$LOG
STAT $?

PRINT "Set user tags"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG
STAT $?

PRINT "Set Permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
STAT $?



