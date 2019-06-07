FROM nginx
EXPOSE 80
RUN apt update && apt install -y wget
COPY *.svg /usr/share/nginx/html/
COPY index_cdf.html /usr/share/nginx/html/index.html
COPY images/health/static_page_health_check.sh /usr/bin
