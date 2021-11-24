#!/usr/bin/env bash
basefile="install"
logfile="general.log"
timestamp=`date '+%Y-%m-%d %H:%M:%S'`

if [ "$#" -ne 1 ]; then
  msg="[ERROR]: $basefile failed to receive enough args"
  echo "$msg"
  echo "$msg" >> $logfile
  exit 1
fi

function setup-logging(){
  scope="setup-logging"
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  echo "$info_base removing old logs" >> $logfile

  rm -f $logfile

  echo "$info_base ended" >> $logfile

  echo "================" >> $logfile
}

function root-check(){
  scope="root-check"
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  #Make sure the script is running as root.
  if [ "$UID" -ne "0" ]; then
    echo "[$timestamp ERROR]: $basefile::$scope you must be root to run $0" >> $logfile
    echo "==================" >> $logfile
    echo "You must be root to run $0. Try the following"
    echo "sudo $0"
    exit 1
  fi

  echo "$info_base ended" >> $logfile
  echo "================" >> $logfile
}

function docker-check() {
  scope="docker-check"
  info_base="[$timestamp INFO]: $basefile::$scope"
  cmd=`docker -v`

  echo "$info_base started" >> $logfile

  if [ -z "$cmd" ]; then
    echo "$info_base docker not installed"
    echo "$info_base docker not installed" >> $logfile
  fi

  echo "$info_base ended" >> $logfile
  echo "================" >> $logfile

}

function docker-compose-check() {
  scope="docker-compose-check"
  info_base="[$timestamp INFO]: $basefile::$scope"
  cmd=`docker-compose -v`

  echo "$info_base started" >> $logfile

  if [ -z "$cmd" ]; then
    echo "$info_base docker-compose not installed"
    echo "$info_base docker-compose not installed" >> $logfile
  fi

  echo "$info_base ended" >> $logfile
  echo "================" >> $logfile

}
function usage() {
    echo ""
    echo "Usage: "
    echo ""
    echo "-u: start."
    echo "-d: tear down."
    echo "-h: Display this help and exit."
    echo ""
}
function decompress() {
    scope="decompress"
    info_base="[$timestamp INFO]: $basefile::$scope"

    echo "$info_base started" >> $logfile

    dir=$1

    filename=$2

    decompressed_folder=$3

    if [[ -d "$dir/$decompressed_folder" ]]; then

          echo "$info_base $filename already decompressed" >> $logfile

          echo "$info_base ended" >> $logfile

          echo "================" >> $logfile

          return
    fi

    echo "$info_base changing directory to $dir" >> $logfile

    cd ${dir}

    echo "$info_base decompress $dir/$filename " >> ../$logfile

    sudo tar -xf $filename

    echo "$info_base removing $filename " >> ../$logfile

    sudo rm -f $filename

    echo "$info_base changing directory back" >> ../$logfile

    cd ../

    echo "$info_base ended" >> $logfile

    echo "================" >> $logfile
}
function compress() {
    scope="compress"
    info_base="[$timestamp INFO]: $basefile::$scope"

    echo "$info_base started" >> $logfile

    dir=$1

    filename=$2

    decompressed_folder=$3

    if [[ -f "$dir/$filename" ]]; then

          echo "$info_base $decompressed_folder already compressed" >> $logfile

          echo "$info_base ended" >> $logfile

          echo "================" >> $logfile

          return
    fi

    echo "$info_base changing directory to $dir" >> $logfile

    cd ${dir}

    echo "$info_base compressing $dir/$decompressed_folder " >> ../$logfile

    sudo tar -czvf $filename $decompressed_folder

    echo "$info_base removing $decompressed_folder " >> ../$logfile

    sudo rm -Rf $decompressed_folder

    echo "$info_base changing directory back" >> ../$logfile

    cd ../

    echo "$info_base ended" >> $logfile

    echo "================" >> $logfile
}
function start-up(){

    local scope="start-up"
    local info_base="[$timestamp INFO]: $basefile::$scope"

    echo "$info_base started" >> $logfile

    decompress "db" "data_dump.tar.gz" "data_dump"

    echo "$info_base starting services" >> $logfile

    sudo docker-compose up --build

    echo "$info_base ended" >> $logfile

    echo "================" >> $logfile
}
function tear-down(){

    scope="tear-down"
    info_base="[$timestamp INFO]: $basefile::$scope"

    echo "$info_base started" >> $logfile

    compress "db" "data_dump.tar.gz" "data_dump"

    echo "$info_base starting services" >> $logfile

    sudo docker-compose down

    echo "$info_base ended" >> $logfile

    echo "================" >> $logfile
}

root-check
docker-check
docker-compose-check

while getopts ":udh" opts; do
  case $opts in
    u)
      setup-logging
      start-up ;;
    d)
      tear-down ;;
    h)
      usage
      exit 0 ;;
    /?)
      usage
      exit 1 ;;
  esac
done
