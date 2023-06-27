FROM macromind/docker-apache-php72:latest
LABEL description="Laravel 5.6"

RUN apt update && apt install fontconfig libxrender1 xfonts-75dpi xfonts-base -y && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*
ADD wkhtmltox_0.12.6-1.bionic_amd64.deb /root/
RUN dpkg -i /root/wkhtmltox_0.12.6-1.bionic_amd64.deb && rm /root/wkhtmltox_0.12.6-1.bionic_amd64.deb
ADD conf/000-docker.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-docker
COPY apache2-foreground /usr/local/bin/
EXPOSE 80

WORKDIR /var/www/html/
CMD ["apache2-foreground"]
