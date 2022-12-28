STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo Check the error in $LOG File
 fi
}

PRINT()
{
  echo "-----------$1-------" >>${LOG}
  echo -e "\e[32m$1\e[0m"
}

DOWNLOAD_APP_CODE() {
    PRINT "Download Zip folder"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/roboshop-devops-project/$COMPONENT/archive/main.zip" &>>$LOG
    STAT $?

    PRINT "GO TO PATH"
    cd $APP_LOC &>>$LOG
    STAT $?

    PRINT "Remove previous version of app"
    rm -rf ${CONTENT} &>>$LOG
    STAT $?
}

LOG=/tmp/$COMPONENT.log
rm -f $LOG

NODEJS() {
  APP_LOC= cd /home/roboshop
  CONTENT=$COMPONENT
  PRINT "Download Nodejs Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
  STAT $?

  PRINT "install node js"
  yum install nodejs -y &>>$LOG
  STAT $?

  PRINT "ROBOSHOP USER"
  id roboshop &>>$LOG
   if [ $? -ne 0 ]; then
   useradd roboshop &>>$LOG
  fi
  STAT $?

  DOWNLOAD_APP_CODE

  PRINT "Unzip Folder"
  unzip /tmp/$COMPONENT.zip &>>$LOG
  STAT $?

  PRINT "Rename folder"
  mv $COMPONENT-main $COMPONENT
  STAT $?

  PRINT "Go to Path $COMPONENT"
  cd $COMPONENT &>>$LOG
  STAT $?

  PRINT "Install NPM"
  npm install &>>$LOG
  STAT $?

  PRINT "Configure Redis endpoint and catalogue endpoint"
  sed -i -e 's/REDIS_ENDPOINT/redis.devops69.online/' -e 's/CATALOGUE_ENDPOINT/caralogue.devops69.online/' /home/roboshop/$COMPONENT/systemd.service &>>$LOG
  STAT $?

  PRINT "Configure systemd file"
  mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service &>>$LOG
  STAT $?

  PRINT "Daemon-Reload"
  systemctl daemon-reload &>>$LOG
  STAT $?

  PRINT "Restart $COMPONENT"
  systemctl restart $COMPONENT &>>$LOG
  STAT $?

  PRINT "Enable $COMPONENT"
  systemctl enable $COMPONENT &>>$LOG
  STAT $?
}

