#!/bin/bash

[ -z "${AWS_ACCESS_KEY_ID}" ] && { echo "S3-Restore: AWS_ACCESS_KEY_ID cannot be empty" && exit 1; }
[ -z "${AWS_SECRET_ACCESS_KEY}" ] && { echo "S3-Restore: AWS_SECRET_ACCESS_KEY cannot be empty" && exit 1; }
[ -z "${AWS_S3_BUCKET}" ] && { echo "S3-Restore: AWS_S3_BUCKET cannot be empty" && exit 1; }
[ -z "${AWS_S3_PREFIX}" ] && { echo "S3-Restore: AWS_S3_PREFIX cannot be empty" && exit 1; }

tmp_dir=/tmp/restore-s3
tmp_file=$tmp_dir/dump.gz

uri="s3://${AWS_S3_BUCKET}/${AWS_S3_PREFIX}"

if [ -z "${AWS_S3_KEY}" ]
then
  echo "S3-Restore: Searching last Backup in ${uri}"
  key=$(aws s3 ls ${uri}/ | sort | tail -n 1 | awk '{print $4}')
else
  echo "S3-Restore: Use defined key ${AWS_S3_KEY}"
  key=$AWS_S3_KEY
fi

filepath=$uri/$key
echo "S3-Restore: Filepath ${filepath}"

mkdir $tmp_dir
echo "S3-Restore: Downloading ${key}"
aws s3 cp $filepath $tmp_file

zcat $tmp_file \
        | mysql \
        -u root \
        -p${MYSQL_ROOT_PASSWORD} \
        ${MYSQL_DATABASE}

rm -rf $tmp_dir
