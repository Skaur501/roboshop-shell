# -z is going to be true if the value 1 is empty otherwise it will be false
if [ -z "$1" ]; then
  echo Input argument Password is needed
  exit
fi

Roboshop_mysql_password=$1

#this stat function will check if $1 is equal to 1 then its true otherwise its false. $1 means first argument
STAT() {
  if [ $1 -eq 0 ]; then
    eco SUCCESS
else
    echo FAILURE
    exit
fi
}

echo -e "\e[32mDownloading MySQL Repo File\e[0m" # to add color to heading
#echo Downloading MYSQL Repo File
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
STAT [? #Stat question mark means exit status on the curl command . that stat function will go to the first argument

echo -e "\e[32mdisable MYSQL 8 version repo\e[0m"
#echo disable MYSQL 8 version repo
dnf module disable mysql -y
STAT [?

echo -e "\e[32mInstall MYSQL\e[0m" # to add color to heading
#echo Install MYSQL // to display message
yum install mysql-community-server -y
STAT [?

echo -e "\e[32menable MYSQL\e[0m"
#echo enable MYSQL
systemctl enable mysqld
STAT [?

echo -e "\e[32mrestart MYSQL\e[0m"
#echo restart MYSQL
systemctl restart mysqld
STAT [?

echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}
if [ $? -ne 0 ] #if $? is not equal to 0 , commands will only get executed if condition is true . when our condition is true when Roboshop@1 is not set. suppose if you execute the query and output is 1 that means password is not reset
then
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROBOSHOP_MYSQL_PASSWORD}';" > /tmp/root-pass-sql
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"

fi