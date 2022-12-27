echo -e "\e[32mDownloading MySQL Repo File\e[0m"
echo Downloading MYSQL Repo File
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
if [ $? -ne 0 ]; then
    echo SUCCESS
else
    echo FAILURE
fi

echo -e "\e[32mdisable MYSQL 8 version repo\e[0m"
echo disable MYSQL 8 version repo
dnf module disable mysql -y
if [ $? -ne 0 ]; then
    echo SUCCESS
else
    echo FAILURE
fi

echo Install MYSQL
yum install mysql-community-server -y
if [ $? -ne 0 ] ; then
    echo SUCCESS
else
    echo FAILURE
fi

echo enable MYSQL
systemctl enable mysqld
if [ $? -ne 0 ]; then
    echo SUCCESS
else
    echo FAILURE
fi

echo restart MYSQL
systemctl restart mysqld
if [ $? -ne 0 ]; then
    echo SUCCESS
else
    echo FAILURE
fi

echo show databases | mysql -uroot -pRoboshop@1
if [ $? -ne 0 ] # if $? is not equal to 0 , commands will only get executed if condition is true . when our condition is true when Roboshop@1 is not set. suppose if you execute the query and output is 1 that means password is not reset
then
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';" > /tmp/root-pass-sql
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"

fi