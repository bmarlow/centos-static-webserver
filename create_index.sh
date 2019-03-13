#!/bin/bash

ENVIRONMENT=$(echo $hostname | cut -f 1 -d '-')

cat << EOF > /var/run/web/index.html
<html>
  <head>
    <title>My $ENVIRONMENT app</title>
  </head>
  <body>
    <h1>Hello World</h1>
    <p>This is my local application</p>
    <p>Version 2.0.0</p>
    <p>Hostname of container is $(hostname)</p>
    <p>This container was started at $(date)</p>
  </body>
</html>
EOF