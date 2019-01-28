This is only 16MB alpine based httpd access enabled subversion server.
j
DocumentRoot is as /var/www/localhost/htdocs, it could map to host directory as startup.
/var/log/apache2 is the log direct, mapping it to a directory is recommend for the sanity of the container.

Start this container
docker container run -d --name alpine-httpd-svn -p 3690:80 -v ~/log/httpd/:/var/log/apache2/ -v ~/data/svn/:/var/www/svn/ hyugecloud/alpine-httpd-svn

# after the container start running
# docker container exec -it alpine-httpd-svn sh to config the svn repository
# svnadmin create /var/www/svn/stuff
# chown -R apache.apache /var/www/svn/stuff
# since the /var/www/svn is attached to the host file system
# even container is destroyed, the svn repository is saved on the host machine

curl http://localhost

Following response
<html><body><h1>It works!</h1></body></html>
should be return from the default index.html at the DocumentRoot

You can use browser to access the repository at 
http://localhost:3690/repos/stuff
you will see "stuff - Revision 0: /" in browser
