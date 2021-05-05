FROM ubuntu:focal
MAINTAINER Ugur Cayoglu <cyglu@aol.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends\
	wget \
	gnupg \
	ca-certificates \
	git \
	curl \
	sudo \
        make \
        gcc \
        gettext-base \
        libreadline-dev \
	lsb-release

# Install openresty
RUN wget https://openresty.org/package/pubkey.gpg -O openresty_signing.key  && apt-key add openresty_signing.key
RUN echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" \
    | sudo tee /etc/apt/sources.list.d/openresty.list
RUN apt-get update && apt-get install -y openresty unzip && \
    apt-get clean autoclean && apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*
 
# Install lua
WORKDIR /tmp
RUN curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz && \
    tar -zxf lua-5.3.5.tar.gz && \
    cd lua-5.3.5 && \
    make linux test && make install

# Install luarocks and lua-resty-openidc
RUN wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz && \
    tar zxpf luarocks-3.3.1.tar.gz && \
    cd luarocks-3.3.1 && \
    ./configure --with-lua-bin=/usr/local/bin && \
    make && make install
RUN luarocks install lua-resty-openidc

# All configuration and logs are saved here
WORKDIR /nginx
RUN mkdir /nginx/logs /nginx/conf
COPY nginx/conf/nginx.conf.template /nginx/conf/nginx.conf.template
COPY start.sh /nginx/start.sh

# Output logs to stderr/stdout for fetching by docker logs
RUN ln -sf /dev/stderr /nginx/logs/error.log
RUN ln -sf /dev/stdout /nginx/logs/access.log

ENV PATH=/usr/local/openresty/nginx/sbin:$PATH
CMD ["nginx", "-p", "/nginx", "-g", "daemon off;"]
