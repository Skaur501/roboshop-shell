STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo Check the error in $LOG File
    exit
 fi
}

PRINT()
{
  echo " -----------$1------- " >>${LOG}
  echo -e "\e[32m$1\e[0m"
}

LOG=/tmp/$COMPONENT.log
rm -f $LOG

DOWNLOAD_APP_CODE() {
    PRINT "Download app component"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/roboshop-devops-project/$COMPONENT/archive/main.zip" &>>$LOG
    STAT $?

    PRINT "Remove previous version of app"
    cd $APP_LOC &>>$LOG
    rm -rf ${CONTENT} &>>$LOG
    STAT $?

    PRINT "Unzip Folder"
    unzip -o /tmp/$COMPONENT.zip &>>$LOG
    STAT $?

    SYSTEMD_SETUP
}

SYSTEMD_SETUP() {
      PRINT "Move path"
      mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service &>>$LOG
      STAT $?

      PRINT " Reload Daemon"
      systemctl daemon-reload &>>$LOG
      STAT $?

      PRINT " Start $COMPONENT service"
      systemctl start $COMPONENT  &>>$LOG
      STAT $?

      PRINT "Enable $COMPONENT service"
      systemctl enable $COMPONENT &>>$LOG
      STAT $?
}

NODEJS() {
  APP_LOC=/home/roboshop
  CONTENT=$COMPONENT
  PRINT "Download Nodejs Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG
  STAT $?

  PRINT "install node js"
  yum install nodejs -y &>>$LOG
  STAT $?

  DOWNLOAD_APP_CODE

  mv $COMPONENT-main $COMPONENT &>>$LOG
  cd $COMPONENT &>>$LOG
  STAT $?

  PRINT "Install Ddependies for nodejs"
  npm install &>>$LOG
  STAT $?

  SYSTEMD_SETUP
}

JAVA() {
    APP_LOC=/home/roboshop
    CONTENT=$COMPONENT

    PRINT "Install Maven"
    yum install maven -y &>>$LOG
    STAT $?

    DOWNLOAD_APP_CODE

    PRINT "Download Maven Dependencies"
    mvn clean package &>>$LOG &&  mv target/$COMPONENT-1.0.jar $COMPONENT.jar &>>$LOG
    STAT $?

    SYSTEMD_SETUP
}



