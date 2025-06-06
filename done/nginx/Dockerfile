FROM ghcr.io/jauderho/alpine:3.21.3@sha256:97544ae64f3bad300d3130639f26ffa5465257222c0dc58e08be0276d017df68

# https://nginx.org/en/download.html
#ENV BUILD_VERSION 1.21.3

# https://www.openssl.org/source
#ENV OPENSSL_VERSION 3.0.0

# https://www.pcre.org/
#ENV PCRE_VERSION 8.45

ARG BUILD_VERSION
ARG OPENSSL_VERSION
ARG PCRE_VERSION
ARG ZLIB_URL=https://github.com/cloudflare/zlib.git
ARG BROTLI_URL=https://github.com/google/ngx_brotli.git
ARG PATCHES_URL=https://github.com/jauderho/patches.git

RUN \
  build_pkgs="build-base linux-headers openssl-dev pcre-dev wget zlib-dev perl-dev lld ccache openssl pcre zlib git" && \
  runtime_pkgs="ca-certificates tzdata" && \
  apk add --no-cache ${build_pkgs} ${runtime_pkgs} && \
  cd /tmp && \
  wget -O - http://nginx.org/download/nginx-${BUILD_VERSION}.tar.gz --tries=3 | tar zxf - -C /tmp && \
  wget -O - https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz --tries=3 | tar xzf  - -C /tmp && \
  wget -O - https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz --tries=3 | tar xzf  - -C /tmp && \
  git clone --depth 1 ${ZLIB_URL} /tmp/zlib && \
  cd /tmp/zlib && \
  ./configure && \
  git clone --depth 1 ${BROTLI_URL} /tmp/ngx_brotli && \
  cd /tmp/ngx_brotli && \
  git submodule update --init && \
  git clone --depth 1 ${PATCHES_URL} /tmp/patches && \
  cd /tmp/nginx-${BUILD_VERSION} && \
  echo "Patching..." && \
  patch -p1 < /tmp/patches/nginx/nginx__dynamic_tls_records_1015008.patch && \
  patch -p1 < /tmp/patches/nginx/nginx_hpack_push_1.15.3.patch && \
  patch -p1 < /tmp/patches/nginx/nginx-1.15.4-reprioritize-chacha-openssl-1.1.1.patch && \
  patch -p1 < /tmp/patches/nginx/nginx-1.15.4-reprioritize-chacha-openssl-1.1.1.patch && \
  PATH="/usr/lib/ccache:$PATH" && \
  ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_v2_module \
    --with-http_v2_hpack_enc \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --without-http_autoindex_module \
    --without-http_ssi_module \
    --with-file-aio \
    --with-threads \
    --add-module=/tmp/ngx_brotli \
    --with-cc-opt='-fuse-ld=lld -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2'  \
    --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed' \
    --with-openssl=/tmp/openssl-${OPENSSL_VERSION} \
    --with-openssl-opt="enable-ec_nistp_64_gcc_128 threads no-ssl no-tls1 no-tls1_1 no-weak-ssl-ciphers no-tests" \
    --with-pcre-jit \
    --with-pcre=/tmp/pcre-${PCRE_VERSION} \
    --with-zlib=/tmp/zlib \
    && \
  make && \
  ccache -s && \
  strip objs/nginx && \
  make install && \
  sed -i -e 's/#access_log  logs\/access.log  main;/access_log \/dev\/stdout;/' -e 's/#error_log  logs\/error.log  notice;/error_log stderr notice;/' /etc/nginx/nginx.conf && \
  addgroup -S nginx && \
  adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx && \
  rm -rf /tmp/* && \
  apk del ${build_pkgs} && \
  rm -rf /var/cache/apk/*

#    --with-cc-opt='-fuse-ld=lld -O3 -march=native -pipe -flto -ffat-lto-objects -fomit-frame-pointer -fstack-protector-all -fexceptions --param=ssp-buffer-size=4 -grecord-gcc-switches -fPIE -pie -fno-semantic-interposition -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wformat-security -Wno-error=strict-aliasing -Wextra -Wp,-D_FORTIFY_SOURCE=2' \
#    --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' \

LABEL org.opencontainers.image.authors "Jauder Ho <jauderho@users.noreply.github.com>"
LABEL org.opencontainers.image.url "https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.documentation "https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.source "https://github.com/jauderho/dockerfiles"
LABEL org.opencontainers.image.title "jauderho/nginx"
LABEL org.opencontainers.image.description "nginx is a web server"

COPY files/index.html /etc/nginx/html/
COPY files/nginx.conf /etc/nginx/nginx.conf

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443
HEALTHCHECK NONE

ENTRYPOINT ["nginx"]

# Notes
#
# Use the following to enable streaming
#    --with-stream \
#    --with-stream_ssl_module \
#    --with-stream_ssl_preread_module \
#    --with-stream_realip_module \
