FROM macromind/docker-apache-php72:latest
MAINTAINER MACROMIND Online <idc@macromind.online>
LABEL description="Laravel 5.6"

RUN apt-get update && apt-get install wkhtmltopdf && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY wkhtmltox_0.12.6-1.bionic_amd64.deb /root/
RUN dpkg -i /root/wkhtmltox_0.12.6-1.bionic_amd64.deb
ADD conf/000-docker.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-docker
COPY apache2-foreground /usr/local/bin/

EXPOSE 80

WORKDIR /var/www/html/

CMD ["apache2-foreground"]
