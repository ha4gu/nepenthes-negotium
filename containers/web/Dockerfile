FROM nginx:1.16
RUN rm -f /etc/nginx/conf.d/* \
  && rmdir /etc/nginx/conf.d/ \
  && rm -f /etc/nginx/nginx.conf \
  && rm -f /usr/share/nginx/html/* \
  && rmdir /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/nginx.conf
