#!/bin/sh 
set -e

abort()
{
    if [ "$?" = "0" ]
    then
        return
    else
      echo >&2 '
      ***************
      *** ABORTED ***
      ***************
      '
      echo "An error occurred on line $1. Exiting..." >&2
      exit 1
    fi
}

summaryOfServices()
{
  echo_msg "Current Services in CF_SPACE"
  cf services | tail -n +4
}

summaryOfApps()
{
  echo_msg "Current Apps in CF_SPACE"
  cf apps | tail -n +4
}

echo_msg()
{
  echo ""
  echo "************** ${1} **************"
}

cf_login()
{
  cf --version
  cf login -a $api -u $username -p $password -o $organization -s $space $ssl
}

exitIfNull()
{
  if [ -z "${1}" ]
  then
    echo ${2}
    exit 1
  fi
}

checkAppIsDeployed()
{
  URL=`cf apps | grep $1 | xargs | cut -d " " -f 6`
  exitIfNull $URL
}

checkSpringBootAppOnPCF()
{
  checkAppIsDeployed $1

  running=`curl -s $URL/health | grep '"status" : "UP"'`
  exitIfNull $running
}