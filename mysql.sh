# -z is going to be true if the value 1 is empty otherwise it will be false
if [ -z "$1" ]; then
  echo Input argument Password is needed
  exit
fi

COMPONENT=mysql
source Common.sh
ROBOSHOP_MYSQL_PASSWORD=$1

#this stat function will check if $1 is equal to 1 then its true otherwise its false. $1 means first argument
STAT() {
  if [ $1 -eq 0 ]; then
    echo SUCCESS
else
    echo FAILURE
    exit
 fi
}

PRINT() {
  echo -e "\e[32m$1\e[0m"
}

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
if [ $? -ne 0 ]; then
  echo "uninstall plugins validate password" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>$LOG
fi
STAT $?


