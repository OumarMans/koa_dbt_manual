FROM alpine:3.14.6
MAINTAINER koami

RUN apk add --update --no-cache nano openjdk8 unzip openvpn bash

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

# set timezone
ENV TZ 'Europe/Berlin'
RUN apk add --update tzdata && cp /usr/share/zoneinfo/$TZ /etc/localtime

# add openvpn config

COPY vpnconfig.ovpn /etc/openvpn/
COPY vpnlogin.txt /etc/openvpn/
RUN chmod 0644 /etc/openvpn/vpnlogin.txt
RUN touch /etc/openvpn/vpnstatus.log
RUN chmod 0644 /etc/openvpn/vpnstatus.log

# google service account token
ENV TOKEN_PATH /home/secrets/gToken.p12
ADD gToken.p12 $TOKEN_PATH


ENV JOBS_PATH /home/jobs
ADD jobs $JOBS_PATH

ENV CRON_PATH /home/crons/
ADD crons $CRON_PATH
RUN chmod -R +x $CRON_PATH
ENV CRON_LOG /var/log/cron.log
RUN touch $CRON_LOG
ENV CRON_SCHEDULE /var/spool/cron/crontabs/root
ADD schedule_cron $CRON_SCHEDULE
RUN chmod 0644 $CRON_SCHEDULE


CMD /bin/sh -c /home/crons/vpncheck && crond -l 8 -d 8 && tail -f $CRON_LOG


# Fact_Deliveries Refresh_CurrentYear_Deliveries_0.1
ENV FD_PATH $JOBS_PATH/Refresh_CurrentYear_Deliveries
ENV FD_RUN $FD_PATH/Refresh_CurrentYear_Deliveries/Refresh_CurrentYear_Deliveries_run.sh
RUN mkdir -p $FD_PATH && unzip -qq $JOBS_PATH/Refresh_CurrentYear_Deliveries_0.1.zip -d $FD_PATH && rm $JOBS_PATH/Refresh_CurrentYear_Deliveries_0.1.zip
RUN chmod +x $FD_RUN


EXPOSE 8080