FROM centos:centos7
EXPOSE 8080
#Script that creates index file in run directory
COPY create_index.sh /var/run/web/create_index.sh
#Make script executable
RUN chmod +x /var/run/web/create_index.sh
#Create index file ahead of time
RUN touch /var/run/web/index.html
#Update perms to make index file writable by everyone
RUN chmod 777 /var/run/web/index.html
#Change to non-priviledged user
USER 1001
#Switch directories, run the script, then fire up the python test server
CMD cd /var/run/web && bash create_index.sh && python -m SimpleHTTPServer 8080

