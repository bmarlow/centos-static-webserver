FROM centos:centos7
EXPOSE 8080
USER 1001
#COPY index.html /var/run/web/index.html
COPY create_index.sh ./
RUN chmod 755 create_index.sh
CMD ./create_index.sh && cd /var/run/web && python -m SimpleHTTPServer 8080

