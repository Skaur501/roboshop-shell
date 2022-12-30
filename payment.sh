COMPONENT=rabbitmq
source Common.sh

PYTHON




useradd roboshop

cd /home/roboshop
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip"
unzip /tmp/payment.zip
mv payment-main payment




cd /home/roboshop/payment
pip3 install -r requirements.txt


    Update `CARTHOST` with cart server ip

    Update `USERHOST` with user server ip

    Update `AMQPHOST` with RabbitMQ server ip.

