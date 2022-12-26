curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

useradd roboshop

curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
cd /home/roboshop
unzip /tmp/cart.zip
mv cart-main cart
cd cart
npm install

sed -i -e 's/REDIS_ENDPOINT/redis.devops69.online/' -e 's/CATALOGUE_ENDPOINT/caralogue.devops69.online/' 
systemctl daemon-reload
systemctl restart cart
systemctl enable cart