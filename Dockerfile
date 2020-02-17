FROM nginx:1.17.8-alpine
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY build ./usr/share/nginx/html
EXPOSE 8080
HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:8080 || exit 1

