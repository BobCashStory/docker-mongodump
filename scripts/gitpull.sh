#!/bin/bash

source /etc/profile
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
export TERM=${TERM:-dumb}

#----------------------------------------
# Please set the following variable section
# Please set up working directories, use','split
# eg:path="/root/test/path1,/root/test/path2"
path="/usr/src/app"
#----------------------------------------

# Do not edit the following section

# Check if user is root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must run this script as root.${CEND}"; exit 1; } 2>&1

# Check if directory path exists
if [[ "${path}" = "" ]]; then 
    echo "${CFAILURE}Error: You must set the correct directory path.Exit.${CEND}" 2>&1
    exit 1
fi

# Check if command git exists
if ! [ -x "$(command -v git)" ]; then
    echo "${CFAILURE}Error: You may not install the git.Exit.${CEND}" 2>&1
    exit 1
fi

# Check where is command git
git_path=`which git`

# Start to deal the set dir
OLD_IFS="$IFS" 
IFS="," 
dir=($path) 
IFS="$OLD_IFS" 

echo "Start to git pull this script." 2>&1

for every_dir in ${dir[@]} 
do
    cd ${every_dir}
    work_dir=`pwd`
    echo "---------------------------------" 2>&1
    echo "Start to deal" ${work_dir} 2>&1
    ${git_path} pull
    echo "---------------------------------" 2>&1
done

install.sh 2>&1
prepare.sh 2>&1

# Kill current app 
PID=`ps -eaf | grep node | grep -v grep | awk '{print $2}'`
if [[ "" !=  "$PID" ]]; then
  echo "killing $PID"
  kill -9 $PID
fi

echo "All done,thanks for your use." 2>&1