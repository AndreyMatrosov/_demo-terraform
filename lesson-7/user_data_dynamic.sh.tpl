#!/bin/bash
yum -y update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2>Terraform dynamic file</h2><font color = "red">v1.0<br>
Owner ${f_name} ${l_name}<br>

%{ for x in names ~}
Name: ${x}<br>
%{ endfor ~}

</html>
EOF

sudo service httpd start
chkconfig httpd on
