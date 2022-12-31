COMPONENT=frontend
CONTENT="*"
source Common.sh

PRINT "Install Nginx"
yum install nginx -y &>>$LOG
STAT $?

APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE #DOWNLOADING APP CODE IS GOING TO THE LOCATON AND DOWNLOADING ALL THE CODE , REMOVING PREVIOUS STUFF AND AGAIN DOING UNZIP

mv frontend-main/static/* .

PRINT "COPY CONFIGURATION FILE"
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG

PRINT "Update roboshop configuration"
sed -i -e '/catalogue/ s/localhost/dev-catalogue.sarbjeet310.online/'  -e '/user/ s/localhost/dev-user.sarbjeet310.online/' -e '/cart/ s/localhost/dev-cart.sarbjeet310.online/' -e '/shipping/ s/localhost/dev-shipping.sarbjeet310.online/' -e '/payment/ s/localhost/dev-payment.sarbjeet310.online/' /etc/nginx/default.d/roboshop.conf
STAT $?

PRINT "Enable Service nginx"
systemctl enable nginx &>>$LOG

PRINT "Restart service nginx"
systemctl restart nginx &>>$LOG
