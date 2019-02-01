FROM centos:centos7
EXPOSE 8080
USER 1001
#COPY index.html /var/run/web/index.html
COPY bash_create_index.sh ./
RUN chmod 755 bash_create_index.sh
CMD bash create_index.sh && cd /var/run/web && python -m SimpleHTTPServer 8080

