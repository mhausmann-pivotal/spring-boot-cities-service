#!/bin/sh 
. $APPNAME/ci/scripts/common.sh

searchForCity()
{
  running=`curl -s $URL/cities/search/namei?q=Aldermoo2 | grep "SU3915"`
  exitIfNull $running "Could not find Aldemoor!"
}

main()
{
  cf_login
  summaryOfApps
  checkSpringBootAppOnPCF $APPNAME
  searchForCity
  echo "logging out"
  cf logout
}

trap 'abort $LINENO' 0
SECONDS=0
SCRIPTNAME=`basename "$0"`
main
printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
trap : 0
