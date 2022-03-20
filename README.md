
<div align="center">
  <a href="https://www.pokt.network">
    <img src="https://user-images.githubusercontent.com/16605170/74199287-94f17680-4c18-11ea-9de2-b094fab91431.png" alt="Pocket Network logo" width="340"/>
  </a>
</div>

# Pocket blockchain snapshots 
Snapshots for pocket blockchain data


## Overview

This snapshots take places every 12 hours and current name format for them is `pocket-network-data-hhdd-rc-x.x.x.x` for both .tar and .tar.gz respectively

Also, every 12 hours all of our example and download links gets updated via a script so you always get the latest one. If for any reason the latest doesn't work. you can feel free to take a old snapshot from the commit history

Below are the mechanisms in order to download a snapshot of our datadir using storj


### Usage 

#### Download via direct link


[Compressed](https://link.us1.storjshare.io/raw/jvxzqfsuiwzqoc2bmkd5gyye4ypa/pocket-public-blockchains/pocket-network-data-1220-rc-0.6.3.6.tar.gz)

[Tar](https://link.us1.storjshare.io/raw/ju3inj2jecmdfedxb577ymlgg4kq/pocket-public-blockchains/pocket-network-data-1220-rc-0.6.3.6.tar)



#### In-place wget and extract

Extracts the .tar on the fly without needing 2x the space


#### Tar 

```bash

cd node1/data

wget -qO- https://link.us1.storjshare.io/raw/ju3inj2jecmdfedxb577ymlgg4kq/pocket-public-blockchains/pocket-network-data-1220-rc-0.6.3.6.tar | tar xvf -

```

#### Download and extract via uplink

This method requires 2x of the space required for the blockchain data. But it's the most fastest download method

We assume you have downloaded uplink and that you exported the env variable below:

```bash
export UPLINK_DOWN=147A7s3UVY6g4DhxdatsM7QMofNBJJfvcq5w9XuYjU2HrmEbr4JSbRy3NQu3mijqk7T8in1PYEAdcf11dd5yhJ4eDAn4UMppBgqcN49f2tHVcGhRV2McpvyTm4U22uXH35h14JA1YXiGdUFDss7ThTnFnPYY8uRTxmtG2UrdW9LZkmuJysNF1sU8anEGcZnGQuYWViAzVx2VwtYTrYQE5CXPQotB2rnGwFaUY9vVeTCKFC8yiwZLHxhPJdZaexrZPbBTaf1xvmuyarMchkxvbn8K7pLXfw7n2xGArJavvRK86Nj1SrRr5ws9ku9i24WbGddKWz4SNaZgUH63Wm65yK8m91kgeHLDhhhR
```

##### Tar 
 
```bash
uplink --access $UPLINK_DOWN cp sj://pocket-public-blockchains/pocket-network-data-1220-rc-0.6.3.6.tar ./pocket.tar --parallelism 5

tar xvf pocket.tar -C node1/data
```

##### Compresssed
 
```bash
uplink --access $UPLINK_DOWN cp sj://pocket-public-blockchains/pocket-network-data-1220-rc-0.6.3.6.tar.gz ./pocket.tar.gz --parallelism 5

tar zxvf pocket.tar.gz -C node1/data
```


#### Download and extracts via wget


This methods require 2x of the space required for the blockchain data (approx 105gb for the time of this writting)

#### Compressed

```bash

wget -O pocket.tar.gz https://link.us1.storjshare.io/raw/jvxzqfsuiwzqoc2bmkd5gyye4ypa/pocket-public-blockchains/pocket-network-data-1220-rc-0.6.3.6.tar.gz

tar zxvf pocket.tar -C node1/data

```


#### Tar 

```bash

wget -O pocket.tar https://link.us1.storjshare.io/raw/ju3inj2jecmdfedxb577ymlgg4kq/pocket-public-blockchains/pocket-network-data-1220-rc-0.6.3.6.tar

tar xvf pocket.tar -C node1/data

```

#### Download via Rclone 

##### Script 

Assuming you have rclone installed: 


```bash

rclone config # Will show the rclone config location. copy the location and replace it with our rclone.config
cp rclone.config ~/.config/rclone/rclone.conf 

time rclone copy --progress --s3-upload-concurrency 32 --s3-chunk-size 256M  downloader:pocket-public-blockchains/pocket-network-data-1220-rc-0.6.3.6.tar ./

mkdir -p node1/data
tar xvf ./pocket-network-data-RC-0.6.3.6.tar -C node1/data

```

or just:

```bash
sh download.sh 
```

##### Docker rclone

You can build/run the docker image, which will download/untar the pocket blockchain snapshot on the folder ./node1/data


```bash
docker build -t pocket-blockchain-downloader . --no-cache && docker run -v  $(pwd)/node1/:/root/node1  -it pocket-blockchain-downloader
``` 


## License

This project is licensed under the MIT License; see the [LICENSE.md](LICENSE.md) file for details.
