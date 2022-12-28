COMPONENT=mongodb
source Common.sh

PRINT "Download YUM repo File"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$log

PRINT "Install Mongodb"
yum install -y mongodb-org &>>$log

PRINT "Substitute the value of 127.0.0.1 in config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$log

PRINT "Enable Mongodb service"
systemctl enable mongod &>>$log

PRINT "Restart Mongodb Service"
systemctl restart mongod &>>$log

cd $APP_LOC &>>$LOG
  rm -rf ${CONTENT} &>>$LOG

APP_LOC=/tmp
CONTENT=mongodb-main
DOWNLOAD_APP_CODE

cd mongodb-main &>>$LOG

PRINT "Load catalouge schema"
mongo < catalogue.js &>>$log

PRINT "Load user schema"
mongo < users.js &>>$log
