# global default
ARG fnum=ops001.cloud.zingbox.com:5000/zc-daily/frontend:v0.3_1813

FROM ops001.cloud.zingbox.com:5000/nginx:0.7
ENV TENGINE_VERSION 2.2.2

# Fork of https://github.com/kairyou/alpine-tengine

VOLUME ["/var/cache/nginx"]

COPY --from=ops001.cloud.zingbox.com:5000/tengine-zb:3.0  /etc/nginx/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /etc/nginx/sites-enabled
#ADD default /etc/nginx/sites-enabled/default
# keep http2 from 0.7
COPY --from=ops001.cloud.zingbox.com:5000/nginx:0.7  /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default
COPY --from=ops001.cloud.zingbox.com:5000/nginx:0.7  /etc/nginx/ssl/cert.pem /etc/nginx/ssl/cert.pem
COPY --from=ops001.cloud.zingbox.com:5000/nginx:0.7  /etc/nginx/ssl/key.pem /etc/nginx/ssl/key.pem

FROM ${fnum} AS base
FROM scratch

COPY --from=base  /usr/local/nginx/html /etc/nginx/html
CMD chmod uog+r /etc/nginx/html

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
