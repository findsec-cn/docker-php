#!/bin/sh

if [ ! -n "$1" ] ;then
    echo "./add_project.sh <项目域名> <PHP版本-默认PHP7>"
    echo "请输入项目域名及PHP版本，如：./add_project.sh foo.example.com 5"
    exit;
fi

PROJECT=$1
PHP_VERSION=$2
DIR=`dirname $0`

# 创建访问日志目录
mkdir -p ${DIR}/logs/access/$PROJECT

# 创建应用程序目录
mkdir -p ${DIR}/logs/app/$PROJECT
chmod -R 777 ${DIR}/logs/app/$PROJECT

# 创建应用程序缓存目录
mkdir -p ${DIR}/data/nginx/cache/$PROJECT
chmod -R 777 ${DIR}/data/nginx/cache/$PROJECT

# 创建应用程序数据目录
mkdir -p ${DIR}/data/nginx/data/$PROJECT
chmod -R 777 ${DIR}/data/nginx/data/$PROJECT

# 创建应用程序目录
mkdir -p ${DIR}/webapps/$PROJECT/htdocs

# 创建应用配置文件
cp ${DIR}/config/nginx/conf.d/example.com.conf.template ${DIR}/config/nginx/conf.d/${PROJECT}.conf
sed -i "s/foo.example.com/${PROJECT}/g" ${DIR}/config/nginx/conf.d/${PROJECT}.conf

# 默认添加的项目是PHP 7，如果指定版本为PHP 5需要修改配置
if (( ${PHP_VERSION} == 5 )); then
    sed -i 's/php7-fpm/php5-fpm/' ${DIR}/config/nginx/conf.d/${PROJECT}.conf
fi

# 重启Nginx服务
docker-compose restart nginx

