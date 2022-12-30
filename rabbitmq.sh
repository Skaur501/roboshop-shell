COMPONENT=rabbitmq
source Common.sh

PRINT " Install repo for erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>$LOG

PRINT "Install erland"
yum install erlang -y &>>$LOG

PRINT "Install RPM package for erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG

PRINT "Install rabbitmq"
yum install rabbitmq-server -y &>>$LOG

PRINT "enable Rabbitmq"
systemctl enable rabbitmq-server &>>$LOG

PRINT "reStart Rabbitmq"
systemctl restart rabbitmq-server &>>$LOG

PRINT "Add user"
rabbitmqctl add_user roboshop roboshop123 &>>$LOG

PRINT "Set user tags"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG

PRINT "Set Permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG



