# Concrete5.7 for Docker
Docker image of Concrete5.7 with Apache2.4 and PHP 5.6 based on the official Debian Jessie image

#### Concrete5 is an open source content management system for web content

Concrete5 was designed for ease of use, for users with a minimum of technical skills. It features in-context editing (the ability to edit website content directly on the page, rather than in an administrative interface). Editable areas are defined in concrete5 templates which allow editors to insert 'blocks' of content. These can contain simple content (text and images) or have more complex functionality, for example image slideshows, comments systems, lists of files, maps etc. Further addons can be installed from the concrete5 Marketplace to extend the range of blocks available for insertion. Websites running concrete5 can be connected to the concrete5 website, allowing automatic upgrading of the core software and of any addons downloaded or purchased from the Marketplace.

## Quickstart:

#### Create a Concrete5 Data Container 
MariaDB will use the initially empty /var/lib/mysql directory and Concrete5 will use /var/www/html and /etc/apache2, which already have the initial content of the image. 
```
docker create -it --name C5-DATA \
-v /var/lib/mysql \
chriswayg/concrete5.7 bash
```
The image does not need to be started or running for sharing its data. It can be started and attached to for examining the data inside the conatainer: ```docker start C5-DATA && docker attach C5-DATA```

#### Create a Database 
This initializes one database for use with Concrete5. Remember replacing the the_root_password and the_db_user_password with real passwords.
```
docker run -d --name c5mariadb \
--volumes-from C5-DATA \
-e MYSQL_ROOT_PASSWORD=the_root_password \
-e MYSQL_USER=c5dbadmin \
-e MYSQL_PASSWORD=the_db_user_password \ 
-e MYSQL_DATABASE=c5db \
mariadb
```
#### Run Concrete5
It  will be linked to the MariaDB: The link between the c5mariadb and the Concrete5 container causes the /etc/hosts file in the Concrete5 container to be continually updated with the current IP of the c5mariadb container.
```
docker run -d --name=Concrete5 \
--volumes-from C5-DATA \
--link c5mariadb:c5mariadb \
-p 80:80 \
-p 443:443 \
chriswayg/concrete5.7
```				   
Visit your Concrete5 site at ```https://example.com``` for initial setup.

#### Concrete 5 Initial Setup
On the setup page, set your site-name and admin user password and enter the following

		Database Information:
		Server:          c5mariadb
		MySQL Username:  c5dbadmin
		MySQL Password:  the_db_user_password
		Database Name:   c5db
#### Data will persist
The Concrete5 and c5mariadb application containers can be removed (even with ```docker rm -f -v```), upgraded and reinitialized without loosing website or database data, as all website data is stored in the C5-DATA container.

To find out where the data is stored on disk, check with ```docker inspect C5-DATA | grep -A1 Source```

---
###### License:
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
