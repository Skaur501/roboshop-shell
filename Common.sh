STAT() {
  if [ $1 -ne 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[32mFAILURE\e[0m"
 fi
}

PRINT()
{
  echo -e "\e[32m$1\e[0m"
}