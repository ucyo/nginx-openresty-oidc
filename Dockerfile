FROM ubuntu:focal
MAINTAINER Ugur Cayoglu <cyglu@aol.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
	wget \
	gnupg \
	ca-certificates \
	git \
	curl \
	sudo \
	lsb-release

RUN curl -O http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key
RUN echo "deb http://nginx.org/packages/mainline/ubuntu/ $(lsb_release -sc) nginx" >> /etc/apt/sources.list
RUN echo "deb-src http://nginx.org/packages/mainline/ubuntu/ $(lsb_release -sc) nginx" >> /etc/apt/sources.list

RUN wget https://openresty.org/package/pubkey.gpg -O openresty_signing.key  && apt-key add openresty_signing.key
RUN echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" \
    | sudo tee /etc/apt/sources.list.d/openresty.list

RUN apt-get update -y && apt-get install nginx luarocks openresty -y


# All configuration and logs are saved here
WORKDIR /nginx
RUN mkdir /nginx/logs /nginx/conf
COPY nginx.conf /nginx/conf/nginx.conf

# Output logs to stderr/stdout for fetching by docker logs
RUN ln -sf /dev/stderr /nginx/logs/error.log
RUN ln -sf /dev/stdout /nginx/logs/access.log

ENV PATH=/usr/local/openresty/nginx/sbin:$PATH
CMD ["nginx", "-p", "/nginx", "-g", "daemon off;"]
