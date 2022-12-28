Component=cart
source Common.sh

PRINT "Download Nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
STAT $?

PRINT "install node js"
yum install nodejs -y &>>$LOG
STAT $?

PRINT "ROBOSHOP USER"
useradd roboshop &>>$LOG
STAT $?

PRINT "Download Zip folder"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>$LOG
STAT $?

PRINT "GO TO PATH"
cd /home/roboshop &>>$LOG
STAT $?

PRINT "Remove previous version of app"
rm -rf cart &>>$LOG
STAT $?

PRINT "Unzip Folder"
unzip /tmp/cart.zip &>>$LOG
STAT $?

PRINT "Rename folder"
mv cart-main cart &>>$LOG
STAT $?

PRINT "Go to Path cart"
cd cart &>>$LOG
STAT $?

PRINT "Install NPM"
npm install &>>$LOG
STAT $?

PRINT "Configure Redis endpoint and catalogue endpoint"
sed -i -e 's/REDIS_ENDPOINT/redis.devops69.online/' -e 's/CATALOGUE_ENDPOINT/caralogue.devops69.online/' /home/roboshop/cart/systemd.service &>>$LOG
STAT $?

PRINT "Configure systemd file"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>$LOG
STAT $?

PRINT "Daemon-Reload"
systemctl daemon-reload &>>$LOG
STAT $?

PRINT "Restart Cart"
systemctl restart cart &>>$LOG
STAT $?

PRINT "Enable Cart"
systemctl enable cart &>>$LOG
STAT $?