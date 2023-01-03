COMPONENT=frontend
CONTENT="*"
source Common.sh

PRINT "Install Nginx"
yum install nginx -y &>>$LOG
STAT $?

APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE

mv frontend-main/static/* .

PRINT "Copy RoboShop Configuration File"
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT $?

PRINT "Update RoboShop Configuration"
sed -i -e '/catalogue/ s/localhost/dev-catalogue.sarbjeet310.online/'  -e '/user/ s/localhost/dev-user.sarbjeet310.online/' -e '/cart/ s/localhost/dev-cart.sarbjeet310.online/' -e '/shipping/ s/localhost/dev-shipping.sarbjeet310.online/' -e '/payment/ s/localhost/dev-payment.sarbjeet310.online/' /etc/nginx/default.d/roboshop.conf
STAT $?

PRINT "Enable Nginx Service"
systemctl enable nginx &>>$LOG
STAT $?

PRINT "Start Nginx Service"
systemctl restart nginx &>>$LOG
STAT $?
