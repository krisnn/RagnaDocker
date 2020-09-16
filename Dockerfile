       FROM ubuntu:bionic-20200713 #ubuntu 18.04
 MAINTAINER nz <nostafu.z@gmail.com>
       USER root
	    ENV HOME /root
        ADD boottime.sh /
        ADD 000-default.conf /
        ADD my.cnf /
        ADD database/import.sql /
        ADD launch-athena.sh /
        ADD reset-athena.sh /
        ADD backup-athena.sh /
        ADD import-athena.sh /
        WORKDIR /usr/bin/rathena/
		RUN mkdir /datastore/ \
            && mkdir /datastore/usr-bin-rathena/ \
            && mkdir /datastoresetup/ \
            && mkdir /datastoresetup/usr-bin-rathena/ \
		RUN apt-get update \
			&& apt-get upgrade -y
		RUN apt-get install -y build-essential \
		                       zlib1g-dev \
							   libpcre3-dev
		RUN git clone https://github.com/rathena/FluxCP.git /usr/bin/rathena
		RUN git clone https://github.com/rathena/rathena.git /usr/bin/rathena
		RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
            && rm -rf /var/www/html \
		RUN ./configure --enable-epoll=yes --enable-prere=no --enable-vip=no --enable-packetver=20180620 \
		    && make clean \
			&& make server \
			&& service mysql start \
			&& chmod a+x /usr/bin/rathena/*-server \
		    && chmod a+x /usr/bin/rathena/athena-start \
            && chmod a+x /*.sh \
			&& chmod -R 777 /var/www/html/fluxcp/data \
            && chown -R 33:33 /var/www/html/fluxcp/data \
			&& chmod -R 777 /datastore \
            && chown -R 33:33 /datastore \
			&& rsync -az /usr/bin/rathena/ /datastoresetup/usr-bin-rathena/
			&& rsync -az /etc/apache2/ /datastoresetup/etc-apache2/ \
            && rsync -az /etc/mysql/ /datastoresetup/etc-mysql/ \
            && rsync -az /usr/bin/rathena/ /datastoresetup/usr-bin-rathena/ \
            && rsync -az /var/lib/mysql/ /datastoresetup/var-lib-mysql/ \
            && rsync -az /var/www/html/fluxcp/ /datastoresetup/var-www-html/
		RUN a2enmod rewrite \
		    && mv -f /000-default.conf /etc/apache2/sites-available/ \
            && mv -f /my.cnf /etc/mysql/conf.d/ \
		RUN apt-get -yqq remove gcc make \
            apt-get -yqq autoremove
		ENV DEBIAN_FRONTEND interactive
		WORKDIR /
		EXPOSE 80 443 3306 5121 6121 6900
		VOLUME /datastore/
	    VOLUME /etc/apache2/
        VOLUME /etc/mysql/
        VOLUME /usr/bin/rathena/
        VOLUME /var/lib/mysql/
        VOLUME /var/www/html/
		ENV PHP_UPLOAD_MAX_FILESIZE 10M
        ENV PHP_POST_MAX_SIZE 10M
        CMD bash
        ENTRYPOINT /boottime.sh