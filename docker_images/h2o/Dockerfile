#FROM lkwg82/h2o-http2-server:v2.2.3
FROM alpine:3.7
MAINTAINER Lars K.W. Gohlke <lkwg82@gmx.de>

ENV URL     https://github.com/h2o/h2o.git
ENV VERSION  tags/v2.2.4

RUN apk update \
    && apk upgrade \
    # need for ocsp stapling \
    && apk add -U perl openssl \
    # just needed since v2
    && apk add -U libstdc++ \
    # save state before installed packages for building \
    && grep ^P /lib/apk/db/installed | sed -e 's#^P:##g' | sort > /before \
    && apk add -U build-base \
		  bison \
                  ca-certificates \
                  cmake \
                  git \
                  linux-headers \
		  ruby \
                  ruby-dev \
                  zlib-dev \
    && git clone $URL h2o \
    # build h2o \
    && cd h2o \
    && git checkout $VERSION \
    && cmake -DWITH_BUNDLED_SSL=on -DWITH_MRUBY=on \
    && make install \
    && cd .. \
    && rm -rf h2o \
    # remove packages installed just for building \
    && grep ^P /lib/apk/db/installed | sed -e 's#^P:##g' | sort > /after \
    && diff /before /after | grep -e "^+[^+]" | sed -e 's#+##g' | xargs -n1 apk del \
    && rm /before /after \
    && rm -rf /var/cache/apk/* \
    # just test it \
    && h2o -v
# cpコマンドを入れるため。
RUN apk add coreutils

ENV LANG ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8


# ルートディレクトリを作成
RUN mkdir -p /var/www/html

# 自己証明書を発行
RUN mkdir -p /etc/h2o/conf


RUN openssl genrsa 2048 > server.key \
 && openssl req -new -key server.key -subj "/C=JP/ST=Tokyo/L=Shibuya-ku/O=Hoge Inc./OU=web/CN=localhost" > server.csr \
 && openssl x509 -in server.csr -days 3650 -req -signkey server.key > server.crt \
 && cp server.crt /etc/h2o/conf/server.crt \
 && cp server.key /etc/h2o/conf/server.key \
 && chmod 755 -R /var/www/html \
 && chmod 400 /etc/h2o/conf/server.key

ADD ./conf/h2o.conf /etc/h2o/conf

RUN apk del coreutils

