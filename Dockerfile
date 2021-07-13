FROM debian:buster-slim

ENV GRPCVERSION 1.24.0
ENV TYKVERSION 3.0.4
ENV TYKLANG ""

LABEL Description="Tyk Gateway docker image" Vendor="Tyk" Version=$TYKVERSION

RUN apt-get update \
 && apt-get install -y redis-server \
 && redis-server --daemonize yes 

RUN \
  apt-get update && \
  apt-get install -y ca-certificates && \
  apt-get clean

RUN apt-get update \
 && apt-get install -y procps \
 && apt-get install -y vim


RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            wget curl ca-certificates apt-transport-https gnupg unzip \
 && curl -L https://packagecloud.io/tyk/tyk-gateway/gpgkey -k | apt-key add - \
 && apt-get install -y --no-install-recommends \
            build-essential \
            python3-setuptools \
            libpython3.7 \
            python3.7-dev \
            jq \
 && rm -rf /usr/include/* && rm /usr/lib/x86_64-linux-gnu/*.a && rm /usr/lib/x86_64-linux-gnu/*.o \
 && rm /usr/lib/python3.7/config-3.7m-x86_64-linux-gnu/*.a \
 && wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && rm get-pip.py \
 && pip3 install protobuf grpcio==$GRPCVERSION \
 && apt-get purge -y build-essential \
 && apt-get autoremove -y \
 && rm -rf /root/.cache

 
# RUN dpkg --print-architecture 
#RUN curl -L https://packagecloud.io/tyk/tyk-gateway/gpgkey
# The application RUN command is separated from the dependencies to enable app updates to use docker cache for the deps

#RUN echo "deb https://packagecloud.io/tyk/tyk-gateway/packages/debian/ buster main" >> /etc/apt/sources.list.d/tyk_tyk-gateway.list
#RUN echo "deb-src https://packagecloud.io/tyk/tyk-gateway/packages/debian/ buster main" >> /etc/apt/sources.list.d/tyk_tyk-gateway.list

#RUN curl -sSF https://packagecloud.io/install/repositories/tyk/tyk-gateway/config_file.list?os=debian&dist=10&source=script
#RUN curl -sSF https://packagecloud.io/install/repositories/tyk/tyk-gateway/config_file.list?os=debian&dist=10&source=script >> /etc/apt/sources.list.d/tyk_tyk-gateway.list
#RUN cat /etc/apt/sources.list.d/tyk_tyk-gateway.list

RUN wget --no-check-certificate --content-disposition https://packagecloud.io/tyk/tyk-gateway/packages/debian/buster/tyk-gateway_3.0.4_amd64.deb/download.deb
#RUN curl -k https://packagecloud.io/tyk/tyk-gateway/packages/debian/buster/tyk-gateway_3.0.4_amd64.deb
RUN dpkg -i /*.deb && rm /*.deb

#RUN apt-get update \
# && apt-get install --allow-unauthenticated -f --force-yes -y tyk-gateway=3.0.4 \
# && rm -rf /var/lib/apt/lists/*

COPY ./tyk.standalone.conf /opt/tyk-gateway/tyk.conf
COPY ./entrypoint.sh /opt/tyk-gateway/entrypoint.sh
COPY ./apps/ /opt/tyk-gateway/apps/
COPY ./hcllab.crt /usr/local/share/ca-certificates/hcllab.crt
COPY ./policies.json /opt/tyk-gateway/policies/policies.json 


RUN chmod 755 /usr/local/share/ca-certificates/hcllab.crt
RUN export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin:/root/bin"
RUN update-ca-certificates

VOLUME ["/opt/tyk-gateway/"]

WORKDIR /opt/tyk-gateway/

EXPOSE 8080

ENTRYPOINT ["sh","/opt/tyk-gateway/entrypoint.sh"]
#CMD ["php-fpm7","-F"]
#ENTRYPOINT ["./entrypoint.sh"]
