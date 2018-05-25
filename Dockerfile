FROM debian:stable
MAINTAINER dianlujitao "dianlujitao@gmail.com"

RUN set -x \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y wget gcc libc-dev make apt-transport-https ca-certificates unzip \
    # nginx dependencies
    libpcre3-dev zlib1g-dev zlib1g-dev \
# new directory for storing sources and .deb files
    && tempDir="$(mktemp -d)" \
    && chmod 777 "$tempDir" \
# (777 to ensure APT's "_apt" user can access it too)
    \
# install libfastcommon
    && ( \
        cd "$tempDir" \
        && wget https://codeload.github.com/happyfish100/libfastcommon/zip/master -O libfastcommon-master.zip \
        && unzip libfastcommon-master.zip \
        && cd libfastcommon-master \
        && /bin/bash make.sh \
        && /bin/bash make.sh install \
    ) \
    && rm -rf "$tempDir"/* \
    \
# install fastdfs
    && ( \
        cd "$tempDir" \
        && wget https://codeload.github.com/happyfish100/fastdfs/zip/master -O fastdfs-master.zip \
        && unzip fastdfs-master.zip \
        && cd fastdfs-master \
        && /bin/bash make.sh \
        && /bin/bash make.sh install \
    ) \
    && rm -rf "$tempDir"/* \
    \
# install nginx & fastdfs nginx module
    && ( \
        cd "$tempDir" \
        && wget https://codeload.github.com/happyfish100/fastdfs-nginx-module/zip/master -O fastdfs-nginx-module-master.zip \
        && unzip fastdfs-nginx-module-master.zip \
        && wget https://nginx.org/download/nginx-1.14.0.tar.gz \
        && tar -xzvf nginx-1.14.0.tar.gz \
        && cd nginx-1.14.0 \
        && /bin/bash configure --add-module=../fastdfs-nginx-module-master/src \
        && make && make install \
    ) \
# purge leftovers from building
    && rm -rf "$tempDir" \
# insert fastdfs nginx module config into nginx.conf
    && sed -i '0,/location \/ {/s/location \/ {/location \/M00 {\n\t\t\troot \/opt\/fastdfs\/storage\/data;\n\t\t\tngx_fastdfs_module;\n\t\t}\n\n\t\t&/' /usr/local/nginx/conf/nginx.conf

EXPOSE 80 23000 22122

STOPSIGNAL SIGTERM

COPY start.sh /usr/bin/

#make the start.sh executable 
RUN chmod 777 /usr/bin/start.sh

ENTRYPOINT ["/usr/bin/start.sh"]
