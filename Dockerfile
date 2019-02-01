FROM centos:centos7
EXPOSE 8080
#COPY index.html /var/run/web/index.html
COPY create_index.sh create_index.sh
RUN chmod 755 create_index.sh
#RUN touch /var/run/web/index.html
USER 1001
CMD bash create_index.sh && cd /var/run/web && python -m SimpleHTTPServer 8080

