FROM debian:sid-slim

ENV TZ=Asia/Shanghai

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y apt-transport-https ca-certificates procps curl net-tools \
    && curl -L http://sourceforge.net/projects/leanote-bin/files/2.6.1/leanote-linux-amd64-v2.6.1.bin.tar.gz/download >> /usr/local/leanote-linux-amd64.bin.tar.gz \
    && curl https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.0.1.tgz >> /usr/local/mongodb-linux-x86_64-3.0.1.tgz \
    && tar xzvf /usr/local/mongodb-linux-x86_64-3.0.1.tgz -C /usr/local \
    && tar xzvf /usr/local/leanote-linux-amd64.bin.tar.gz -C /usr/local \
    && cp /usr/local/mongodb-linux-x86_64-3.0.1/bin/* /usr/local/bin/ \
    && rm -rf /usr/local/leanote-linux-amd64.bin.tar.gz \
    && rm -rf mongodb-linux-x86_64-3.0.1.tgz \
    && rm -rf /var/lib/apt/lists/* /usr/local/mongodb-linux-x86_64-3.0.1

ADD run.sh /usr/local/leanote/bin/run.sh
ADD app.conf /usr/local/leanote/conf/app.conf

RUN chmod +x /usr/local/leanote/bin/run.sh

EXPOSE 9000

VOLUME /usr/local/leanote/public/upload /usr/local/leanote/init/

WORKDIR  /usr/local/leanote/bin

ENTRYPOINT ["sh", "run.sh"]