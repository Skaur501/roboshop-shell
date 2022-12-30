COMPONENT=rabbitmq
source Common.sh
RABBITMQ_APP_USER_PASSWORD=$1

if [ -z "$1" ]; then #if $1 is emplty
  echo "Input password is empty"
  exit
fi

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

PRINT "Add application user"
rabbitmqctl add_user roboshop ${RABBITMQ_APP_USER_PASSWORD} &>>$LOG
STAT $?

PRINT "cONFIGURE APPLICATION USER TAG"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG
STAT $?

PRINT "Set Permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
STAT $?



