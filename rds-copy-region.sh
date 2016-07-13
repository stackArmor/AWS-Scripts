#!/bin/bash

# Set the current date for latest RDS snapshot
date_current=`date -u +%Y-%m-%d`

# Find the latest automated RDS snapshot for Indiggo database
aws rds describe-db-snapshots --snapshot-type "automated" --db-instance-identifier "indiggo" | grep `date +%Y-%m-%d` | grep rds | tr -d '",' | awk '{ print $2 }' > /tmp/indiggo-snapshot.txt

snapshot_name=`cat /tmp/indiggo-snapshot.txt`

target_snapshot_name=`cat /tmp/indiggo-snapshot.txt | sed 's/rds://'`

aws rds copy-db-snapshot --source-db-snapshot-identifier $snapshot_name --target-db-snapshot-identifier $target_snapshot_name-copy > /home/ec2-user/rds-snapshot-$date_current.log 2>&1

echo "-------------" >> /home/ec2-user/$date_current -results.txt

cat /home/ec2-user/rds-snapshot-$date_current.log >> /home/ec2-user/$date_current-results.txt

#cat /home/ubuntu/$date_current-results.txt | mail -s "[Daily RDS Snapshot Backup] $date_current" <email@foo.com>
rm /home/ec2-user/$date_current-results.txt
rm /home/ec2-user/rds-snapshot-$date_current.log


aws rds copy-db-snapshot --source-db-snapshot-identifier "arn:aws:rds:us-east-1:150676063069:snapshot:rds:indiggo-2016-07-11-04-30" --region us-west-1 --target-db-snapshot indiggo-2016-07-11-04-30-copy

