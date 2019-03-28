# Docker PHP

Docker PHP 可以快速构建基于 Docker 的 PHP 本地开发环境，此套 LNMP 环境同时支持PHP 5 和PHP 7 。

## 版本及组件

* 当前版本：1.0
* 默认组件：PHP/FPM 7.2/5.6、Nginx 1.12、Mysql 5.7、Redis 4.0、Memcached 1.5

## 目录结构

    ├── add_project.sh  新建项目脚本（Linux）
    ├── build  镜像构建目录
    │   ├── memcached
    │   │   └── Dockerfile
    │   ├── mysql
    │   │   └── Dockerfile
    │   ├── nginx
    │   │   └── Dockerfile
    │   ├── php5
    │   │   └── Dockerfile
    │   ├── php7
    │   │   └── Dockerfile
    │   └── redis
    │       └── Dockerfile
    ├── config  服务配置目录
    │   ├── mysql
    │   │   ├── backup
    │   │   ├── config
    │   │   │   └── mysql.cnf
    │   │   ├── crontabs
    │   │   └── docker-entrypoint-initdb.d  数据库初始化脚本目录
    │   ├── nginx
    │   │   ├── conf.d
    │   │   │   ├── bar.example.com.conf
    │   │   │   ├── foo.example.com.conf
    │   │   │   └── example.com.conf.template
    │   │   ├── fastcgi_mysql
    │   │   ├── fastcgi_web
    │   │   └── nginx.conf
    │   ├── php5
    │   │   ├── php.ini
    │   │   └── php.ini-production
    │   ├── php7
    │   │   ├── php.ini
    │   │   └── php.ini-production
    │   └── redis
    │       └── redis.conf
    ├── data  服务数据目录
    │   ├── mysql  数据库数据存储目录
    │   ├── nginx
    │   │   ├── cache  应用缓存目录
    │   │   └── data  应用数据目录
    │   └── redis  缓存数据目录
    ├── docker-compose.yml  项目配置文件
    ├── logs 服务日志目录
    │   ├── access  Nginx访问日志目录
    │   │   ├── bar.example.com
    │   │   │   └── bar.example.com.log
    │   │   └── foo.example.com
    │   │       └── foo.example.com.log
    │   ├── app  应用日志目录
    │   │   ├── bar.example.com
    │   │   └── foo.example.com
    │   └── srv  服务日志目录
    │       ├── memcached
    │       ├── mysql
    │       │   └── error.log
    │       ├── nginx
    │       │   └── nginx_error.log
    │       ├── php5
    │       │   └── php_errors.log
    │       ├── php7
    │       │   └── php_errors.log
    │       └── redis
    │           └── redis.log
    ├── README.md
    └── webapps  应用代码目录
        ├── bar.example.com
        │   └── htdocs
        │       └── index.php
        └── foo.example.com
            └── htdocs
                └── index.php

## 安装 Docker 及相关工具

### 1、安装 docker 参考官方文档：https://docs.docker.com/install/

推荐安装 docker-ce=17.03.2

### 2、安装 docker-compose

    # 注意：你如果用的是非 root 用户，执行 curl 会提示没权限写入 /usr/local/bin 目录，可以先写入当前目录，再使用 sudo mv 过去
    curl -L https://get.daocloud.io/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

### 3、启动 Docker

    sudo service docker start
    sudo docker info

### 4、配置私有镜像仓库（重要）

    # 添加--insecure-registry启动参数，以CentOS 7为例，修改/usr/lib/systemd/system/docker.service
    ExecStart=/usr/bin/dockerd --insecure-registry=hub.example.com

### 5、配置 DockerHub 加速器（重要）

    # 阿里云加速器：每个人有对应的加速地址，访问 https://dev.aliyun.com ->【管理中心】-> 【DockerHub 镜像站点】配置加速器
    # 添加--registry-mirror启动参数，以CentOS 7为例，修改/usr/lib/systemd/system/docker.service
    ExecStart=/usr/bin/dockerd --insecure-registry=hub.example.com --registry-mirror=https://xxxxxx.mirror.aliyuncs.com

## 启动开发环境

### 启动 PHP 开发环境

    git clone http://github.com/ist0ne/docker-php.git

    cd docker-php

    # 配置应用目录(重要)、数据库密码、端口等
    vim .env
    
    # 给组件文件夹可写权限
    sudo chmod -R 777 data logs

    # 构建镜像并启动容器
    sudo docker-compose up --build -d

    # 仅启动容器
    sudo docker-compose up -d

    # 单独编译PHP容器
    sudo docker-compose build php7

    # 停止开发环境
    sudo docker-compose stop

    # 启动开发环境
    sudo docker-compose start

    # 销毁开发环境
    sudo docker-compose down


### 启动成功访问

修改hosts：

    127.0.0.1 foo.example.com bar.example.com

访问地址：http://foo.example.com 或者 http://bar.example.com

## 创建新项目

使用脚本创建新项目默认使用config/nginx/conf.d/example.com.conf.template配置模板，可以根据自己的需求修改模板

    # ./add_project.sh <项目域名> <PHP版本>
    # 默认创建PHP 7 项目
    ./add_project.sh foo.example.com 5

## 可能遇到的问题

### 常用操作命令

    # 查看当前启动的容器
    sudo docker ps
    
    # 启动部分服务在后边加服务名，不加表示启动所有，-d 表示在后台运行
    sudo docker-compose up [nginx|php|mysql|redis] -d
    
    # 停止和启动类似
    sudo docker-compose stop [nginx|php|mysql|redis]

    # 删除所有未运行的容器
    sudo docker rm $(docker ps -a -q)

    # 删除所有镜像，-f 可以强制删除
    sudo docker rmi $(docker images -q)

### 修改镜像文件怎么处理？
    
    # 比如在 php 里新增一个扩展
    # 1、更改对应的 docker-php/build/php7/Dockerfile
    # 2、重新构建镜像
    sudo docker-compose build [php7|...]

### 如何设置资源（mysql、redis）变量？

Nginx 资源环境变量定义在./docker-php/config/nginx/fastcgi_web 和 ./docker-php/config/nginx/fastcgi_mysql
其中./docker-php/config/nginx/fastcgi_mysql放置mysql资源相关环境变量，./docker-php/config/nginx/fastcgi_web存放除mysql以外的资源变量。

### 其他的坑

如果需要升级某些组件的版本需要注意载入对应版本的配置文件，修改对应的配置信息，比如 redis.conf 默认配置的出口 ip 为 127.0.0.1，这样的话 php 的容器是连不上的，需要修改成 0.0.0.0，另外也要注意修改对应的日志。

