COMPONENT=mongodb
source Common.sh

PRINT "Download YUM repo File"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG

PRINT "Install Mongodb"
yum install -y mongodb-org &>>$LOG

PRINT "Substitute the value of 127.0.0.1 in config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG

PRINT "Enable Mongodb service"
systemctl enable mongod &>>$LOG

PRINT "Restart Mongodb Service"
systemctl restart mongod &>>$LOG

cd $APP_LOC &>>$LOG
  rm -rf ${CONTENT} &>>$LOG

APP_LOC=/tmp
CONTENT=mongodb-main
DOWNLOAD_APP_CODE

cd mongodb-main &>>$LOG

PRINT "Load catalouge schema"
mongo < catalogue.js &>>$LOG

PRINT "Load user schema"
mongo < users.js &>>$LOG
