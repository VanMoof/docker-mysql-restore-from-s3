# mysql-restore-from-s3

This project is aimed as a drop-in replacement of the [official mysql image](https://hub.docker.com/_/mysql/) when you need to load a backup directly at the container first time launch.

You can automaticaly load the last backup found in a **prefix** defined or you can provider both **prefix** and **key**

It's ideal when you are on a development environment and you want to fire up a new container with the latest data, or simply when you need to create a database and load a backup directly. You can then on the followings update replace it with the corresponding mysql official image.

## Usage

All environment variable from [mysql parent image](https://hub.docker.com/_/mysql/) are available and the same rules apply.

There are mainly two use cases:

### Load single database backup

In this case you need to provide a `MYSQL_DATABASE` variable.
You can provide `MYSQL_USER` and `MYSQL_PASSWORD` variables too to create a new user with all privileges and the freshly imported backup.

```
docker run \
	-e AWS_ACCESS_KEY_ID="ACCESS_KEY" \
	-e AWS_SECRET_ACCESS_KEY="SECRET_ACCESS_KEY" \
	-e AWS_S3_BUCKET="S3_BUCKET" \
	-e AWS_S3_PREFIX="S3_BUCKET_PREFIX" \
	-e MYSQL_ROOT_PASSWORD="not_so_secure" \
	-e MYSQL_DATABASE="my_db_to_create_and_populate" \
	gargam974/mysql-restore-from-s3
```

### Load a backup that contains several database

**WARNING:** If your backup contains a `mysql` database, it will replace the one created with the image. In this case the `MYSQL_ROOT_PASSWORD` that you will provide will be replaced by the one contained in your backup as
user and permissions are stored there. You still need to provide one at the creation.

```
docker run \
	-e AWS_ACCESS_KEY_ID="ACCESS_KEY" \
	-e AWS_SECRET_ACCESS_KEY="SECRET_ACCESS_KEY" \
	-e AWS_S3_BUCKET="S3_BUCKET" \
	-e AWS_S3_PREFIX="S3_BUCKET_PREFIX" \
	-e MYSQL_ROOT_PASSWORD="not_so_secure" \
	gargam974/mysql-restore-from-s3
```

## ENV variables

* *AWS\_ACCESS\_KEY_ID* - **required**
* *AWS\_SECRET\_ACCESS_KEY* - **required**
* *AWS\_S3\_BUCKET* - **required**
* *AWS\_S3\_PREFIX* - **required**
* *AWS\_S3\_KEY* - not required. If you want to load a specific backup file in the prefix instead of the last one, use this.

## Contributions / remarks

Questions ? Issues ? Want to say that my english is bad ? Be my guest :  
https://github.com/Gargam/docker-mysql-restore-from-s3/issues
