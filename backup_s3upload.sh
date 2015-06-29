#!/bin/bash
#

set -o pipefail

BACKUP_DIR=/media/ephemeral0/work/backup/xtradb/
S3_BUCKET=s3://yourbacket/yourfolder/
TAR_FILE=`date +'%Y-%m-%d_%H-%M'`.xbstream.gz

## Delete old files
find $BACKUP_DIR -type f -a ! -name $TAR_FILE | xargs rm -rf

## Backup
innobackupex --user='root' --slave-info --stream=xbstream $BACKUP_DIR |  pigz > $BACKUP_DIR$TAR_FILE
if [ $? != 0 ]; then
  echo "backup failuer!"
  exit 1
fi

## Upload s3
s3cmd put $BACKUP_DIR/$TAR_FILE $S3_BUCKET
if [ $? != 0 ]; then
  echo "s3 upload failuer!"
  exit 1
fi

## Delete s3
s3cmd del `s3cmd ls $S3_BUCKET | grep .gz | sort -k4 | head -n 1 | awk '{print $4}'`
if [ $? != 0 ]; then
  echo "s3 delete failuer!"
  exit 1
fi
