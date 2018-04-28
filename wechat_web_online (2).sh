#!/bin/bash
cd /home/ops/erp/wechat_web
git pull origin master
composer install
yarn install
php artisan migrate:web
npm run dev
