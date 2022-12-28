Source common.sh

PRINT "Download Nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
STAT $?

PRINT "install node js"
yum install nodejs -y
STAT $?

PRINT "ROBOSHOP USER"
useradd roboshop
STAT $?

PRINT "Download Zip folder"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
STAT $?

PRINT "GO TO PATH"
cd /home/roboshop
STAT $?

PRINT "Remove previous version of app"
rm -rf cart
STAT $?

PRINT "Unzip Folder"
unzip /tmp/cart.zip
STAT $?

PRINT "Rename folder"
mv cart-main cart
STAT $?

PRINT "Go to Path cart"
cd cart
STAT $?

PRINT "Install NPM"
npm install
STAT $?

PRINT "Configure Redis endpoint and catalogue endpoint"
sed -i -e 's/REDIS_ENDPOINT/redis.devops69.online/' -e 's/CATALOGUE_ENDPOINT/caralogue.devops69.online/' /home/roboshop/cart/systemd.service
STAT $?

PRINT "Configure systemd file"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
STAT $?

PRINT "Daemon-Reload"
systemctl daemon-reload
STAT $?

PRINT "Restart Cart"
systemctl restart cart
STAT $?

PRINT "Enable Cart"
systemctl enable cart
STAT $?