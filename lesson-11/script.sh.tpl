#!/bin/bash
yum -y update
yum -y install httpd

ip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

current_date=$(date)

cat <<EOF > /var/www/html/index.html
<html>
  <body bgcolor="black">
    <style> #center { text-align: center; } </style>
    <div id="center">
      <h2><font color="gold">built by Terraform <font color="white">1.0</font></h2><br><p>
      <font color="gold">Server PrivateIP: <font color="white">$ip</font><br><br>
      <font color="white">
      <b>Current date $current_date</b><br>
      <b>Version 0.1</b>
    </div>
  </body>
</html>
EOF

sudo service httpd start
chkconfig httpd on
