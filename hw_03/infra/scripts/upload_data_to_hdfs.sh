#!/bin/bash

hdfs dfs -mkdir -p /user/ubuntu/data
hadoop distcp s3a://otus-mlops-bucket-632bf4e5c90b8d6f/ /user/ubuntu/data
hdfs dfs -ls /user/ubuntu/data
