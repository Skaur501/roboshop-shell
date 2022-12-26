curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

useradd roboshop

curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"
cd /home/roboshop
rm -rf user
unzip /tmp/user.zip
mv user-main user
cd /home/roboshop/user
npm install

sed -i -e 's/REDIS_ENDPOINT/redis.devops69.online/' -e 's/MONGO_ENDPOINT/mongo.devops69.online/' systemd.service
systemctl daemon-reload
systemctl restart user
systemctl enable user