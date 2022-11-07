FROM debian:10.12

LABEL maintainer "rorym@mccune.org.uk"

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    debconf-utils && \
    echo mariadb-server mysql-server/root_password password vulnerables | debconf-set-selections && \
    echo mariadb-server mysql-server/root_password_again password vulnerables | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    mariadb-server \
    php \
    php-mysql \
    php-pgsql \
    php-pear \
    php-gd \
    libcurl4 \
    wget \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY php.ini /etc/php5/apache2/php.ini
COPY dvwa /var/www/html

COPY config.inc.php /var/www/html/config/

RUN wget https://github.com/DataDog/dd-trace-php/releases/latest/download/datadog-setup.php -O datadog-setup.php
RUN php datadog-setup.php --php-bin=all --enable-appsec --enable-profiling

RUN chown www-data:www-data -R /var/www/html && \
    rm /var/www/html/index.html

RUN service mysql start && \
    sleep 3 && \
    mysql -uroot -pvulnerables -e "CREATE USER app@localhost IDENTIFIED BY 'vulnerables';CREATE DATABASE dvwa;GRANT ALL privileges ON dvwa.* TO 'app'@localhost;"

EXPOSE 80

RUN echo 'SetEnv DD_AGENT_HOST datadog-agent' > /etc/apache2/conf-enabled/environment.conf
RUN echo 'SetEnv DD_TRACE_AGENT_PORT 8126' >> /etc/apache2/conf-enabled/environment.conf
RUN echo 'SetEnv DD_ENV workshop' >> /etc/apache2/conf-enabled/environment.conf
RUN echo 'SetEnv DD_SERVICE dvwa' >> /etc/apache2/conf-enabled/environment.conf
RUN echo 'SetEnv DD_APPSEC_ENABLED true' >> /etc/apache2/conf-enabled/environment.conf


COPY main.sh /
ENTRYPOINT ["/main.sh"]
