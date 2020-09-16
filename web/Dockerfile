       FROM ubuntu:bionic-20200713 #ubuntu 18.04
 MAINTAINER nz <nostafu.z@gmail.com>
        #ENV user rathena #bisa diganti
        #ENV HOME /home/\$user
       USER root
	    ADD 000-default.conf /
        WORKDIR /usr/bin/rathena/
		RUN mkdir /datastore/ \
            && mkdir /datastore/etc-apache2/ \
			&& mkdir /datastore/var-www-html/ \
			&& mkdir /datastoresetup/ \
            && mkdir /datastoresetup/etc-apache2/ \
			&& mkdir /datastoresetup/var-www-html/
		RUN apt-get update \
			&& apt-get upgrade -y
		RUN apt-get install -y apache2 \ \
		                       php7.2 \
							   libapache2-mod-php \
							   php-apcu
		RUN git clone https://github.com/rathena/FluxCP.git /var/www/html/fluxcp
		RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
		    && rm -rf /var/www/html \
			&& chmod -R 777 /var/www/html/fluxcp/data \
            && chown -R 33:33 /var/www/html/fluxcp/data \
			&& chmod -R 777 /datastore \
            && chown -R 33:33 /datastore \
			&& a2enmod rewrite \
			&& mv -f /000-default.conf /etc/apache2/sites-available/ \
			&& rsync -az /etc/apache2/ /datastoresetup/etc-apache2/ \
			&& rsync -az /var/www/html/fluxcp/ /datastoresetup/var-www-html/
		WORKDIR /
		EXPOSE 80 443 3306 5121 6121 6900
		VOLUME /datastore/
		VOLUME /etc/apache2/
		VOLUME /var/www/html/
		   ENV PHP_UPLOAD_MAX_FILESIZE 10M
           ENV PHP_POST_MAX_SIZE 10M
		CMD bash
 ENTRYPOINT /apache.sh