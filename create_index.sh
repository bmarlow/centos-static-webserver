#!/bin/bash

ENVIRONMENT=$(echo $hostname | cut -f 1 -d '-')

cat << EOF > /tmp/index.html
<html>
  <head>
    <title>My $ENVIRONMENT app</title>
  </head>
  <body>
    <h1>Hello Mano!</h1>
    <p>This is my local application</p>
    <p>Version 1.0.2</p>
    <p>Hostname of container is $(hostname)</p>
    <p>This container was started at $(date)</p>
  </body>
</html>
EOF
