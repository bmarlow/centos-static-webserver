FROM centos:centos7
EXPOSE 8080
USER 1001
COPY index.html /var/run/web/index.html
CMD cd /var/run/web && python -m SimpleHTTPServer 8080

