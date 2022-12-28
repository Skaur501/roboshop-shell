COMPONENT=frontend
CONTENT="*"
source Common.sh

PRINT "Install Nginx"
yum install nginx -y &>>$LOG
STAT $?

APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE #DOWNLOADING APP CODE IS GOING TO THE LOCATON AND DOWNLOADING ALL THE CODE , REMOVING PREVIOUS STUFF AND AGAIN DOING UNZIP
exit

mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx
systemctl start nginx
