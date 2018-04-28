root@iZ2zeb1kcfbotalsu02k64Z:/home/qa# cat wechat_web_online.sh 
export PATH=/usr/local/node-v7.10.1-linux-x64/bin/:$PATH
cd ./wechat_web
git pull origin master
composer install
yarn install
php artisan  migrate:web   //web代表项目名
npm run dev
