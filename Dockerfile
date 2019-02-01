FROM centos:centos7
EXPOSE 8080
#COPY index.html /var/run/web/index.html
COPY create_index.sh /var/run/web/create_index.sh
#RUN chmod 755 create_index.sh
#RUN touch /var/run/web/index.html
#RUN bash create_index.sh
USER 1001
CMD cd /var/run/web && python -m SimpleHTTPServer 8080

