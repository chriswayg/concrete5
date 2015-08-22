# Concrete5.7 for Docker
Docker image of Concrete5.7 with Apache2.4 and PHP 5.6 based on the official Debian Jessie Image

##### Concrete5 is an open source content management system for publishing content on the Web.

Concrete5 was designed for ease of use, for users with a minimum of technical skills. It features in-context editing (the ability to edit website content directly on the page, rather than in an administrative interface). Editable areas are defined in concrete5 templates which allow editors to insert 'blocks' of content. These can contain simple content (text and images) or have more complex functionality, for example image slideshows, comments systems, lists of files, maps etc. Further addons can be installed from the concrete5 Marketplace to extend the range of blocks available for insertion. Websites running concrete5 can be connected to the concrete5 website, allowing automatic upgrading of the core software and of any addons downloaded or purchased from the Marketplace.

## Quickstart:

Create a Database (replacing the the_db_user_password with a real password).

		docker run -d --name c5mariadb \
				   -e MYSQL_ROOT_PASSWORD=the_root_password \
				   -e MYSQL_USER=c5dbadmin \
				   -e MYSQL_PASSWORD=the_db_user_password \ 
				   -e MYSQL_DATABASE=c5db \
				   mariadb

Run Concrete5, which will be linked to the mariadb (modify public ports as nedded)

		docker run -d --name=Concrete5 \
				   --link c5mariadb \
				   -p 8080:80 \
				   -p 8443:443 \
				   chriswayg/concrete5.7
				   
Visit your Concrete5 site at h&#8203;ttps://example.com:8443 for testing

On the setup page set your site name and admin user password and enter the following

		Database Information:
		Server:          c5mariadb
		MySQL Username:  c5dbadmin
		MySQL Password:  the_db_user_password
		Database Name:   c5db

See the [Docker Hub](https://hub.docker.com/r/chriswayg/concrete5.7/) entry for this container.

---
###### License:
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
