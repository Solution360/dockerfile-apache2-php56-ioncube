FROM debian:8

RUN apt-get update
RUN apt-get install -y wget curl openssh-server apache2 php5 php5-imagick php5-gd php5-mysql php5-xdebug unzip
RUN service apache2 restart

#configure XDebug
RUN echo [XDebug] >> /etc/php5/apache2/php.ini
RUN echo xdebug.remote_enable=1 >> /etc/php5/apache2/php.ini
RUN echo xdebug.remote_connect_back=1 >> /etc/php5/apache2/php.ini
RUN echo xdebug.idekey=netbeans-xdebug >> /etc/php5/apache2/php.ini

#install ioncube
RUN wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
RUN tar xvfz ioncube_loaders_lin_x86-64.tar.gz
RUN cp ioncube/*.so /usr/lib/php5/2*/
RUN echo zend_extension = /usr/lib/php5/2*/ioncube_loader_lin_5.6.so > /etc/php5/apache2/conf.d/00-ioncube.ini
RUN service apache2 restart

# Configure apache
RUN a2enmod rewrite
RUN a2enmod ssl
RUN chown -R www-data:www-data /var/www
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

EXPOSE 80
EXPOSE 443
EXPOSE 22

CMD cd /var/www/html/jtlshop
CMD chmod -R 777 *
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
