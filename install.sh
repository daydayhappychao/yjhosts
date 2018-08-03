mkdir /usr/local/yjhosts
chmod -R 777 /usr/local/yjhosts
chmod -R 777 .
cp -r * /usr/local/yjhosts/
ln -s /usr/local/yjhosts/run.sh /usr/local/bin/yjhosts
echo "安装完成, 使用 yjhosts 命令体验"
