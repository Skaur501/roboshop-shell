if [ -z "$1" ]; then # -z is going to be true if the value 1 is empty otherwise it will be false
  echo Input argument Password is needed
  exit
fi

COMPONENT=mysql
source Common.sh

ROBOSHOP_MYSQL_PASSWORD=$1

#this stat function will check if $1 is equal to 1 then its true otherwise its false. $1 means first argument

PRINT "Downloading MYSQL Repo File"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG
STAT $? #Stat question mark means exit status on the curl command . that stat function will go to the first argument

PRINT "Disable MYSQL 8 version repo"
dnf module disable mysql -y &>>$LOG
STAT $?

PRINT "Install mysql server"
yum install mysql-community-server -y &>>$LOG
STAT $?

PRINT "Enable mysqld"
systemctl enable mysqld &>>$LOG
STAT $?

PRINT "Restart mysqld"
systemctl restart mysqld &>>$LOG
STAT $?

echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}
if [ $? -ne 0 ] #if $? is not equal to 0 , commands will only get executed if condition is true . when our condition is true when RoboShop@1 is not set. suppose if you execute the query and output is 1 that means password is not reset
then
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROBOSHOP_MYSQL_PASSWORD}';" > /tmp/root-pass-sql
  DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
  cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" &>>$LOG
fi

PRINT "Uninstall validate plugin password"
echo "show plugins" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} | grep validate_password &>>$LOG
if [ $? -eq 0 ]; then
  echo " uninstall plugin validate_password;" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>$LOG
fi
STAT $?

APP_LOC=/tmp
CONTENT=mysql-main
DOWNLOAD_APP_CODE

cd mysql-main &>>$LOG

PRINT "Load shipping schema"
mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} <shipping.sql &>>$LOG
STAT $?
