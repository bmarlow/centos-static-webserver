FROM centos:centos7
EXPOSE 8080
#Script that creates index file in run directory
COPY create_index.sh /tmp/create_index.sh
#Make script executable
RUN chmod +x /tmp/create_index.sh
#Create index file ahead of time
RUN touch /tmp/index.html
#Update perms to make index file writable by everyone
RUN chmod 777 /tmp/index.html
#Change to non-priviledged user
#USER 1001
#Switch directories, run the script, then fire up the python test server
CMD cd /tmp && bash create_index.sh && python -m SimpleHTTPServer 8080

