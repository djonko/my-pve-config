FROM adminer:latest
USER root
RUN apk add -U tzdata
ENV TZ=America/Montreal
RUN cp /usr/share/zoneinfo/America/Montreal /etc/localtime
USER app
