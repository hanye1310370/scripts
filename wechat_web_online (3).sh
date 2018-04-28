#!/bin/bash
export PATH=/usr/local/node-v7.10.1-linux-x64/bin/:$PATH
if [ $# -lt 1 ]; then
  echo "usage: $0 <branch>"
  echo  "\033[31m $0  请输入分支名称.......\033[0m"
  exit 1
fi
branch_name=`echo $1`
repo_dir=/home/qa/wechat_web
# get branches and tags list
echo "cd $repo_dir && git fetch origin && git fetch --tags origin"
cd $repo_dir || exit
git fetch origin || exit
git fetch --tags origin

echo "git rev-parse origin/$branch_name ...."
sha=`git rev-parse origin/$branch_name 2>/dev/null`
if [ $? != 0 ];then
  echo "git rev-parse tags/$branch_name ...."
  sha=`git rev-parse tags/$branch_name 2>/dev/null`
  if [ $? != 0 ];then
    echo "==== can not found $branch_name ====" && rm $lock && exit
  else
    # it is tag
    bt=tag
  fi
else
  # it is branch
  bt=branch
fi

[ -z "$sha" ] && echo '$sha is NULL'  && exit

# Updating git
echo "git reset --hard $sha ......."
git reset --hard $sha || exit
git clean -q -d -f

composer install
yarn install
php artisan  migrate:web
php artisan queue:restart
npm run dev
git checkout $branch_name