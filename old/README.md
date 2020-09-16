# RagnaDocker
rAthena, FluxCP, and the LAMP Stack

RagnaDocker allows you to spin up your own Ragnarok Server built off of rAthena in seconds!
The docker container is a snapshot instance of a server ready to go, right before the setup process begins.
While these instructions won't be going indepth on how to best utilize a rAthena server or a FluxCP instance, I will try to go into detail on how to start using them.

### Setting up RagnaDocker
Install Docker to your Docker Host Computer; instructions can be found here: https://docs.docker.com/install/
Add an local ip address for your Ragnarok Server Docker Container to use:
	
```bash
ip addr add 192.168.169.142 dev eth0
```
  
  This ties one of your ips to a networking device on your docker host.
After docker is running on your host computer, you can run this command which will not only download the Docker Image, but create a Docker Container for you to use that is bound to the specified ports/ip:
	
```bash
docker run -it -p 192.168.169.142:20000:80 -p 192.168.169.142:20001:443 -p 192.168.169.142:20002:3306 -p 192.168.169.142:20003:5121 -p 192.168.169.142:20004:6121 -p 192.168.169.142:20005:6900 -v ~/Desktop/datastore/:/datastore/ -v ~/Desktop/datastore/etc-apache2/:/datastore/etc/apache2/ -v ~/Desktop/datastore/etc-mysql/:/datastore/etc/mysql/ -v ~/Desktop/datastore/usr-bin-rathena/:/datastore/usr/bin/rathena/ -v ~/Desktop/datastore/var-lib-mysql/:/datastore/var/lib/mysql/ --name Aegis tvoll/ragnadocker
```

After running that command, you will be using the terminal within that Docker Container. Inside of here, you will learn how to start up your rAthena server.
	
```bash
./launch-athena.sh
```

This should run without errors, starting up your map-server, character-server, and the login-server.
Next, in your browser, you can enter in the IP or Hostname that you have given to your docker host:

```
http://192.168.169.142:20000/fluxcp/
```

This will bring up your FluxCP installation, which will act as your front-end website for your Ragnarok Server; allowing users to register for your server and obtain other information about your server.
	The password to use is: 
  
```
secretpassword
```

Next you will need to enter in the login information for FluxCP to update the MySQL database; both are:

```
ragnarok
```
	
You will now have FluxCP up an running.
On the menu sidebar, you can select the Server Status option to see that FluxCP recognizes that your Ragnarok Server is running.

### Stopping RagnaDocker
First we will want to stop rAthena smoothly. We can do this by finding the athena-start script and passing the stop command.

```bash
cd /usr/bin/rathena/
```

```bash
./rathena-start stop
```

Then from your docker host, in order to stop the docker container from running:

```bash
docker stop Aegis
```

### Running RagnaDocker
Since we already have an existing RagnaDocker container, we can run it by simply typing:

```bash
docker start -i Aegis
```

### Adding a FluxCP Admin
To begin working on your FluxCP website, you will need an account to use.
This account can also be used to log into your Ragnarok Server.
First we will need to log into your RagnaDocker's MySQL Database:

```bash
mysql -u ragnarok -p ragnarok
```

This will log you into the ragnarok database.
Next we can check and see what is inside of the login table (this is where all accounts are stored).

```
mysql> select * from ragnarok.login;
+------------+--------+-----------+-----+-------------------+----------+-------+------------+-----------------+------------+---------------------+------------+------------+-----------------+---------+----------------+----------+-----------+
| account_id | userid | user_pass | sex | email             | group_id | state | unban_time | expiration_time | logincount | lastlogin           | last_ip    | birthdate  | character_slots | pincode | pincode_change | vip_time | old_group |
+------------+--------+-----------+-----+-------------------+----------+-------+------------+-----------------+------------+---------------------+------------+------------+-----------------+---------+----------------+----------+-----------+
|          1 | s1     | p1        | S   | athena@athena.com |        0 |     0 |          0 |               0 |          2 | 2018-08-08 18:13:06 | 172.17.0.2 | 0000-00-00 |               0 |         |              0 |        0 |         0 |
+------------+--------+-----------+-----+-------------------+----------+-------+------------+-----------------+------------+---------------------+------------+------------+-----------------+---------+----------------+----------+-----------+
1 row in set (0.00 sec)
```

You can either Update the exisiting record or create your own new record.
Below I create a new admin account (using group_id 99) and give it the username of testing123 and the password of testing1234.

```
INSERT INTO ragnarok.login (userid, user_pass, group_id) VALUES ('testing123', 'testing1234', '99')
```

Then we can take a look at the results.

```
mysql> select * from ragnarok.login;
+------------+------------+-------------+-----+-------------------+----------+-------+------------+-----------------+------------+---------------------+------------+------------+-----------------+---------+----------------+----------+-----------+
| account_id | userid     | user_pass   | sex | email             | group_id | state | unban_time | expiration_time | logincount | lastlogin           | last_ip    | birthdate  | character_slots | pincode | pincode_change | vip_time | old_group |
+------------+------------+-------------+-----+-------------------+----------+-------+------------+-----------------+------------+---------------------+------------+------------+-----------------+---------+----------------+----------+-----------+
|          1 | s1         | p1          | S   | athena@athena.com |        0 |     0 |          0 |               0 |          2 | 2018-08-08 18:13:06 | 172.17.0.2 | 0000-00-00 |               0 |         |              0 |        0 |         0 |
|    2000000 | testing123 | testing1234 | M   |                   |       99 |     0 |          0 |               0 |          0 | 0000-00-00 00:00:00 |            | 0000-00-00 |               0 |         |              0 |        0 |         0 |
+------------+------------+-------------+-----+-------------------+----------+-------+------------+-----------------+------------+---------------------+------------+------------+-----------------+---------+----------------+----------+-----------+
2 rows in set (0.00 sec)
```

You can now log in with your new Admin credential onto your FluxCP instance!
Once you are logged in, you will see that you have an Admin Control Panel that will allow you to customize different aspects of your website.


