# Concrete5.7 for Docker
Docker image of Concrete5.7 with Apache2.4 and PHP 5.6 based on the official Debian Jessie image

#### Concrete5 is an open source content management system for web content

Concrete5 was designed for ease of use, for users with a minimum of technical skills. It features in-context editing (the ability to edit website content directly on the page, rather than in an administrative interface). Editable areas are defined in concrete5 templates which allow editors to insert 'blocks' of content. These can contain simple content (text and images) or have more complex functionality, for example image slideshows, comments systems, lists of files, maps etc. Further addons can be installed from the concrete5 Marketplace to extend the range of blocks available for insertion. Websites running concrete5 can be connected to the concrete5 website, allowing automatic upgrading of the core software and of any addons downloaded or purchased from the Marketplace.

## Quickstart:

#### Create a minimal Data Container 
MariaDB will use the initially empty /var/lib/mysql directory and Concrete5 will use /var/www/html and /etc/apache2, which will be populated by the docker-entrypoint script. 
```
docker create -it --name C5-DATA \
-v /var/lib/mysql \
-v /var/www/html \
-v /etc/apache2 \
tianon/true true
```
The container does not need to be started or running for sharing its data.

#### Create a Database 
This initializes one database for use with Concrete5. Remember replacing the the_root_password and the_db_user_password with real passwords.
```
docker run -d --name db \
--restart=always \
--volumes-from C5-DATA \
-e MYSQL_ROOT_PASSWORD=the_db_root_password \
-e MYSQL_USER=c5dbadmin \
-e MYSQL_PASSWORD=the_db_user_password \
-e MYSQL_DATABASE=c5db \
mariadb
```
#### Run Concrete5
It  will be linked to the MariaDB: The link between the c5mariadb and the Concrete5 container causes the /etc/hosts file in the Concrete5 container to be continually updated with the current IP of the c5mariadb container.
```
docker run -d --name=Concrete5 \
--restart=always \
--volumes-from C5-DATA \
--link db:db \
-p 80:80 \
-p 443:443 \
chriswayg/concrete5.7
```				   

#### Docker-Compose
Alternatively to the above, using docker-compose create the data volumes, database and Concrete5.7 containers all in one step:

```
$ cd c5
$ cat docker-compose.yml
DB-DATA:
  image: tianon/true
  volumes:
    - /var/lib/mysql

db:
  image: mariadb
  restart: always
  volumes_from:
  - DB-DATA
  environment:
  - MYSQL_ROOT_PASSWORD=the_db_root_password
  - MYSQL_USER=c5dbadmin
  - MYSQL_PASSWORD=the_db_user_password
  - MYSQL_DATABASE=c5db

WEB-DATA:
  image: tianon/true
  volumes:
    - /etc/apache2
    - /var/www/html

web:
  image: chriswayg/concrete5.7
  restart: always
  ports:
  - "80:80"
  - "443:443"
  links:
  - db
  volumes_from:
  - WEB-DATA
  
$ docker-compose up -d
```

#### Concrete5 Setup
Visit your Concrete5 site at ```https://example.com``` for initial setup.

On the setup page, set your site-name and admin user password and enter the following

		Database Information:
		Server:          db
		MySQL Username:  c5dbadmin
		MySQL Password:  the_db_user_password
		Database Name:   c5db
#### Data will persist
The Concrete5 and MariaDB application containers can be removed (even with ```docker rm -f -v```), upgraded and reinitialized without loosing website or database data, as all website data is stored in the DATA containers.

To find out where the data is stored on disk, check with ```docker inspect C5-DATA | grep -A1 Source```

---
###### License:
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
