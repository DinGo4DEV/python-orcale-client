ARG VERSION=3.11.4-slim
ARG ARTIFACT=python
ARG HOST="docker.io"
FROM --platform=linux/amd64 $HOST/$ARTIFACT:$VERSION 
ADD instantclient-basiclite-linux.x64-19.12.0.0.0dbru.zip /opt
RUN  apt-get update -y && \
     apt-get upgrade -y && \
     apt-get dist-upgrade -y && \
     apt-get -y autoremove && \
     apt-get clean
RUN apt-get install -y --no-install-recommends \
    unzip \
    libaio1 \ 
    ;
WORKDIR /opt
RUN unzip /opt/instantclient-basiclite-linux.x64-19.12.0.0.0dbru.zip \
    && sh -c "echo /opt/instantclient_19_12 > \
      /etc/ld.so.conf.d/oracle-instantclient.conf" \
    && rm -f /opt/instantclient-basiclite-linux.x64-19.12.0.0.0dbru.zip
RUN rm -f /etc/localtime \
&& ln -sv /usr/share/zoneinfo/Hongkong /etc/localtime \
&& echo "Hongkong" > /etc/timezone
ENV LD_LIBRARY_PATH=/opt/instantclient_19_12:$LD_LIBRARY_PATH
ENV PATH==/opt/instantclient_19_12:$PATH
RUN pip install oracledb
CMD ["python"]