FROM debian:stable-slim
RUN apt-get update && apt-get install -y nginx \
    && rm -rf /var/lib/apt/lists/*
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]