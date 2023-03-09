FROM macromind/docker-apache-php72:latest
MAINTAINER MACROMIND Online <idc@macromind.online>
LABEL description="Laravel 5.6"

RUN apt-get update && apt-get install wkhtmltopdf xfonts-75dpi -y && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
ADD wkhtmltox_0.12.6-1.bionic_amd64.deb /root/
RUN dpkg -i /root/wkhtmltox_0.12.6-1.bionic_amd64.deb && rm /root/wkhtmltox_0.12.6-1.bionic_amd64.deb
ADD conf/000-docker.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-docker

EXPOSE 80

WORKDIR /var/www/html/

RUN rm -f /var/run/apache2/apache2.pid 
RUN apache2 -DFOREGROUND &
