FROM debian:wheezy
MAINTAINER Thomas Recloux <thomas.recloux@gmail.com>

RUN apt-get update && \
        apt-get -y install mysql-client apache2 php5 php5-mysql libapache2-mod-php5 php5-curl php5-gd unzip wget less vim libjpeg62 gifsicle optipng pngquant libwebp-dev libwebp2 libjpeg-progs php-apc && \
        apt-get clean && \
        wget http://static.jonof.id.au/dl/kenutils/pngout-20130221-linux.tar.gz && \
        tar -zxvf pngout-20130221-linux.tar.gz && \
        cp pngout-20130221-linux/x86_64/pngout /usr/local/bin/ && \
        rm -r pngout-20130221-linux/x86_64/pngout pngout-20130221-linux.tar.gz


ADD apache-vhost.conf /etc/apache2/sites-available/vhost
RUN a2dissite default && \ 
    a2ensite vhost && \ 
	a2enmod rewrite headers && \
	echo "apc.enabled = 1" > /etc/php5/apache2/php.ini  && \
	echo "apc.include_once_override = 0" > /etc/php5/apache2/php.ini  && \
	echo "apc.shm_size = 256" > /etc/php5/apache2/php.ini

VOLUME /var/www
VOLUME /var/log/apache2

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

CMD /usr/sbin/apache2 -D FOREGROUND
