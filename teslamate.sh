# 用于centos/ubuntu环境安装teslamate

# 1. 安装docker和docker-compose
if [ ! -f "/usr/bin/docker" ]; then
  echo "docker is to be intalled!"
  curl -sSL https://get.daocloud.io/docker | sh
else
  echo "docker is already intalled!"
fi
systemctl daemon-reload
systemctl start docker

if [ ! -f "/usr/local/bin/docker-compose" ]; then
  echo "docker-compose is to be intalled!"
  curl -L https://get.daocloud.io/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
else
  echo "docker-compose is already intalled!"
fi
chmod +x /usr/local/bin/docker-compose

# 2. 创建目录
if [ ! -d "/opt/teslamate" ]; then
  mkdir /opt/teslamate
else
  rm -fr /opt/teslamate
  mkdir /opt/teslamate
fi
cd /opt/teslamate

# 3. 下载配置文件并安装启动
rm -f docker-compose-1.yml
wget https://raw.githubusercontent.com/eecsfuture/TeslaMate/main/docker-compose.yml
rm -f .env1
wget https://raw.githubusercontent.com/eecsfuture/TeslaMate/main/.env
read -p "请输入您的IP或域名: " FQDN
cat .env1 | sed "s/localhost/$FQDN/" > .env
read -p "请输入您的用户名:密码: " mypasswd
rm -f .htpasswd
echo $mypasswd > .htpasswd
/usr/local/bin/docker-compose pull
/usr/local/bin/docker-compose up -d

# 4.check and finish！
lsof -i:443

# 5. 删除docker镜像
# docker ps -a | awk '{print $1 }'|xargs docker stop
# docker ps -a | grep "Exited" | awk '{print $1 }'|xargs docker rm
# docker images | awk '{print $3 }'|xargs docker rmi
