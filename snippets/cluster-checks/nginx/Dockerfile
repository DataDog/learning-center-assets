FROM bitnami/nginx

## Allow to access the /status data from outside the pod 
RUN sed -i -e"s|^.*access_log.*||" /opt/bitnami/nginx/conf/nginx.conf
RUN sed -i -e"s|^.*allow.*||" /opt/bitnami/nginx/conf/nginx.conf
RUN sed -i -e"s|^.*deny.*||" /opt/bitnami/nginx/conf/nginx.conf