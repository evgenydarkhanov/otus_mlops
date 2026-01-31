#!/bin/bash

hadoop distcp -m 40 /user/ubuntu/data.parquet s3a://otus-mlops-bucket-parquets-f02a83238337588f/data
