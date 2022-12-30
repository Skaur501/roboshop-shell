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
#set-hostname -skip-apply $COMPONENT

DOWNLOAD_APP_CODE() {
  if [ ! -z "$APP_USER" ]; then
    PRINT "adding application USER"
    id roboshop &>>$LOG
  if [ $? -ne 0 ]; then
    useradd roboshop &>>$LOG
  fi
    STAT $?
  fi

    PRINT "Download app component"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
    STAT $?

    PRINT "Remove previous version of app"
    cd $APP_LOC &>>$LOG
    rm -rf ${CONTENT} &>>$LOG
    STAT $?

    PRINT "Unzip Folder"
    unzip -o /tmp/${COMPONENT}.zip &>>$LOG
    STAT $?

    PRINT "Move shipping to main"
    mv ${COMPONENT}-main ${COMPONENT} &>>$LOG
    STAT $?

    SYSTEMD_SETUP
}

SYSTEMD_SETUP() {
  PRINT "Configure Endpoints for systemd file"
  sed -i -e 's/REDIS_ENDPOINT/dev-redis.sarbjeet310.online/' -e 's/CATALOGUE_ENDPOINT/catalogue.sarbjeet310.online/' -e 's/USERHOST/user.sarbjeet310.online/' -e 's/USERHOST/dev-payment.sarbjeet310.online/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  STAT $?

  PRINT "Daemon-Reload systemd"
  systemctl daemon-reload &>>$LOG
  STAT $?

  PRINT "Restart"
  systemctl restart ${COMPONENT} &>>$LOG
  STAT $?

  PRINT "Enable"
  systemctl enable ${COMPONENT} &>>$LOG
  STAT $?
}

NODEJS() {
  APP_LOC=/home/roboshop
  CONTENT=${COMPONENT}
  APP_USER=roboshop

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

  PRINT "Rename folder"
  mv ${COMPONENT}-main ${COMPONENT}
  cd ${COMPONENT}

  PRINT "Install NPM"
  npm install &>>$LOG
  STAT $?

  SYSTEMD_SETUP
}

JAVA() {
    APP_LOC=/home/roboshop
    CONTENT=${COMPONENT}
    APP_USER=roboshop

    PRINT "Install Maven"
    yum install maven -y  &>>$LOG
    STAT $?

    DOWNLOAD_APP_CODE

    PRINT "Download Maven Dependencies"
    mvn clean package &>>$LOG
    STAT $?

    PRINT "Download target component"
    mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>$LOG
    STAT $?

    SYSTEMD_SETUP
}



