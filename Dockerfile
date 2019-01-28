FROM alpine:3.8

LABEL       maintainer="https://github.com/yubose"

# apache2-webdav is needed to let apache2 to load mod_dav_svn
RUN mkdir /run/apache2 \
        && apk --no-cache --update add apache2 apache2-webdav mod_dav_svn subversion \
        && mkdir -p /var/www/svn \
        && mkdir -p /var/log/apache2 \
        && sed -i.orig -e "s/#ServerName.*:80/ServerName localhost:80/" /etc/apache2/httpd.conf \
        && rm -rf /var/cache/apk/*

# subversion.conf allows to access subversion service via http protocol.
# more customization is need to tailor the needs for specific repository layout.
# this configuration file should be modified before, build the docker image
ADD subversion.conf /etc/apache2/conf.d/

# -v host:/var/log/httpd:/var/log/apache2 for storing log infos.
# -v host:/data/svn:/var/www/svn for store svn db
# following to line is for documentation purpose
VOLUME      ["/var/log/apache2", "/var/www/svn"]
EXPOSE  80

# Run httpd in foreground so that the container does not quit
# soon after start
# To run this container in the back ground use the -d option
#
#     $ sudo docker run -d hyugecloud/alpine-httpd-svn
#
# docker container run -d --name alpine-httpd-svn -p 3690:80 -v ~/log/httpd/:/var/log/apache2/ -v ~/data/svn/:/var/www/svn/ hyugecloud/alpine-httpd-svn
# after the container start running
# docker container exec -it alpine-httpd-svn sh to config the svn repository
# svnadmin create /var/www/svn/stuff
# chown -R apache.apache /var/www/svn/stuff
# since the /var/www/svn is attached to the host file system
# even container is destroyed, the svn repository is saved on the host machine

# Start httpd process when docker container run 
ENTRYPOINT  ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]
