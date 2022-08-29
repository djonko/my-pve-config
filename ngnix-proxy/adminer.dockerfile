FROM adminer:latest
RUN apk add -U tzdata
ENV TZ=America/Montreal
RUN cp /usr/share/zoneinfo/America/Montreal /etc/localtime
