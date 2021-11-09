#!/usr/bin/env bash
export PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/usr/local/bin/
export UPLINK_WRITE=<YOUR_WRITE_PERM_KEY>
export UPLINK_DOWN=147A7s3UVY6g4DhxdatsM7QMofNBJJfvcq5w9XuYjU2HrmEbr4JSbRy3NQu3mijqk7T8in1PYEAdcf11dd5yhJ4eDAn4UMppBgqcN49f2tHVcGhRV2McpvyTm4U22uXH35h14JA1YXiGdUFDss7ThTnFnPYY8uRTxmtG2UrdW9LZkmuJysNF1sU8anEGcZnGQuYWViAzVx2VwtYTrYQE5CXPQotB2rnGwFaUY9vVeTCKFC8yiwZLHxhPJdZaexrZPbBTaf1xvmuyarMchkxvbn8K7pLXfw7n2xGArJavvRK86Nj1SrRr5ws9ku9i24WbGddKWz4SNaZgUH63Wm65yK8m91kgeHLDhhhR

docker stop node11
rm -rf /root/node11/data/*.tar
rm -rf /root/node11/data/*.gz
cd /root/node11/data

# Tar file
tarname=$(date +"pocket-network-data-%H%d-rc-0.6.3.6.tar")
compressedname=$(date +"pocket-network-data-%H%d-rc-0.6.3.6.tar.gz")

tar -cvf  "$tarname" .
docker restart node11
#rclone copy --progress --s3-upload-concurrency 16 --s3-chunk-size 256M ./"$tarname"  uploader:pocket-public-blockchains/
uplink --access $UPLINK_WRITE cp ./"$tarname" sj://pocket-public-blockchains/"$tarname" --parallelism 5

rm *.tar

# Compressed file
tar -czvf  "$compressedname" *
#rclone copy --progress --s3-upload-concurrency 16 --s3-chunk-size 256M ./"$compressedname"  uploader:pocket-public-blockchains/
uplink --access $UPLINK_WRITE  cp ./"$compressedname" sj://pocket-public-blockchains/"$compressedname" --parallelism 5

rm *.gz

eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa

echo "Snapshot data uploaded at `data`"  >> /var/log/snapshot-log.txt
whoami >> /root/snapshot-log.txt
cd ~/
rm -rf ~/pocket-snapshots
git clone git@github.com:pokt-network/pocket-snapshots.git
cd pocket-snapshots

tarlink=$(uplink share --not-after=none --url --access "$UPLINK_WRITE"  sj://pocket-public-blockchains/"$tarname" |  grep "URL  " | awk  '{print $3}')


compressedlink=$(uplink share --not-after=none --url --access "$UPLINK_WRITE"  sj://pocket-public-blockchains/"$compressedname"  |  grep "URL  " | awk  '{print $3}')
sed -i -e 's,https:.*\(\.tar\|\.tar $\),'"$tarlink"',g' README.md
sed -i -e 's,https:.*\(\.tar.gz\|\.tar.gz $\),'"$compressedlink"',g' README.md
sed -i -e 's,pocket-network-data\(.*\)\([[:digit:]]\.tar\|[[:digit:]]\.tar $\),'"$tarname"',g' download.sh
sed -i -e 's,pocket-public-blockchains\/pocket-network-data\(.*\)\([[:digit:]]\.tar\|[[:digit:]]\.tar $\),pocket-public-blockchains\/'"$tarname"',g' README.md
sed -i -e 's,.io\/s,.io\/raw,g' README.md

git add README.md
git config --global user.name "uploaderbot"
git config --global user.email "uploaderbot@pokt.network"
git commit -m "updated pocket snapshot link with latest snapshot"
git push origin master
rm -rf ~/pocket-snapshots
echo "snapshot $name done" >> /root/snapshot-log.txt
date >> /root/snapshot-log.txt
