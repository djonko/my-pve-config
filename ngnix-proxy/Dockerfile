FROM jc21/mariadb-aria:latest
#COPY my.cnf /etc/mysql/my.cnf
#COPY timezone.cnf /etc/mysql/conf.d/timezone.cnf
RUN apk add -U tzdata
ENV TZ=America/Montreal
RUN cp /usr/share/zoneinfo/America/Montreal /etc/localtime
