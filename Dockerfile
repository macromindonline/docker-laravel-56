FROM macromind/docker-apache-php72:latest
LABEL description="Laravel 5.6 + ModSecurity (OWASP CRS) + RemoteIP"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       fontconfig libxrender1 xfonts-75dpi xfonts-base xvfb wkhtmltopdf \
       libapache2-mod-security2 curl ca-certificates \
    && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

# OWASP Core Rule Set 3.3.5 (mesma versão da imagem laravel-58).
# A regra 922 (REQUEST-922-MULTIPART-ATTACK) usa MULTIPART_PART_HEADERS,
# que exige ModSec >= 2.9.3; o Bionic traz 2.9.2, então removemos só esse
# arquivo de regra (mantém paridade total com o restante do CRS 3.3.5).
RUN mkdir -p /etc/modsecurity/crs \
    && curl -sL https://github.com/coreruleset/coreruleset/archive/v3.3.5.tar.gz \
       | tar -xz --strip-components=1 -C /etc/modsecurity/crs \
    && rm -f /etc/modsecurity/crs/rules/REQUEST-922-MULTIPART-ATTACK.conf \
    && cp /etc/modsecurity/crs/crs-setup.conf.example /etc/modsecurity/crs/crs-setup.conf \
    && cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf \
    && sed -i 's|SecRuleEngine DetectionOnly|SecRuleEngine On|' /etc/modsecurity/modsecurity.conf

ADD conf/000-docker.conf /etc/apache2/sites-available/
ADD conf/mpm_prefork.conf /etc/apache2/mods-available/
ADD conf/reqtimeout.conf /etc/apache2/mods-available/
COPY conf/security2.conf /etc/apache2/mods-available/security2.conf
COPY conf/remoteip.conf /etc/apache2/conf-available/remoteip.conf

RUN /usr/sbin/a2dissite '*' \
    && /usr/sbin/a2ensite 000-docker \
    && /usr/sbin/a2enmod headers security2 remoteip \
    && /usr/sbin/a2enconf remoteip

COPY apache2-foreground /usr/local/bin/
RUN sed -i -e 's/\r$//' /usr/local/bin/apache2-foreground \
    && chmod +x /usr/local/bin/apache2-foreground

EXPOSE 80
WORKDIR /var/www/html/
CMD ["apache2-foreground"]
