#!/bin/bash
cat << EOF > /var/run/web/index.html
<html>
  <head>
    <title>My Test app</title>
  </head>
  <body>
    <h1>Hello World</h1>
    <p>This is my local application</p>
    <p>Version 1.0.2</p>
    <p>Hostname of container is $(hostname)</p>
    <p>This container was started at $(date)</p>
  </body>
</html>
EOF