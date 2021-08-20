#!/bin/sh
cp /rclone.config   /root/.config/rclone/rclone.conf
time rclone copy --progress --s3-upload-concurrency 32 --s3-chunk-size 256M  downloader:pocket-public-blockchains/pocket-network-data-RC-0.6.3.6.tar /
mkdir -p /node1/data
tar -xvf pocket-network-data-RC-0.6.3.6.tar -C /node1/data 
