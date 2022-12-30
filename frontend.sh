COMPONENT=frontend
CONTENT="*"
source Common.sh

PRINT "Install Nginx"
yum install nginx -y &>>$LOG
STAT $?

APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE #DOWNLOADING APP CODE IS GOING TO THE LOCATON AND DOWNLOADING ALL THE CODE , REMOVING PREVIOUS STUFF AND AGAIN DOING UNZIP

mv $COMPONENT-main/static/* .

PRINT "COPY CONFIGURATION FILE"
mv $COMPONENT-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG

PRINT "Enable Service nginx"
systemctl enable nginx &>>$LOG

PRINT "Restart service nginx"
systemctl restart nginx &>>$LOG
