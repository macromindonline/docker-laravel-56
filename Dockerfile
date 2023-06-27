FROM macromind/docker-apache-php72:latest
LABEL description="Laravel 5.6"

RUN apt update && apt install fontconfig libxrender1 xfonts-75dpi xfonts-base xvfb wkhtmltopdf -y && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/*
ADD conf/000-docker.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-docker
COPY apache2-foreground /usr/local/bin/
RUN sed -i -e 's/\r$//' /usr/local/bin/apache2-foreground
EXPOSE 80
WORKDIR /var/www/html/
CMD ["apache2-foreground"]