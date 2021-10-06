
<div align="center">
  <a href="https://www.pokt.network">
    <img src="https://user-images.githubusercontent.com/16605170/74199287-94f17680-4c18-11ea-9de2-b094fab91431.png" alt="Pocket Network logo" width="340"/>
  </a>
</div>

# Pocket blockchain snapshots 
Snapshots for pocket blockchain data


## Overview
Below are the mechanisms in order to download a snapshot of our datadir using storj 

### Usage 

#### Download via direct link

Download snapshot from [this link](https://link.us1.storjshare.io/s/jwxbskcxvdnbfnprydcycp5wjzfq/pocket-public-blockchains/pocket-network-data-0006-rc-0.6.3.6.tar)

Extract snapshot inside pocket network config data folder

```bash
tar -xvf ./pocket-network-data-RC-0.6.3.6.tar -C node1/data  # assuming node1/ is your pocket network datadir
```

#### Download via Rclone 

##### Script 

Assuming you have rclone installed: 

```bash

rclone config # Will show the rclone config location. copy the location and replace it with our rclone.config
cp rclone.config ~/.config/rclone/rclone.conf 

time rclone copy --progress --s3-upload-concurrency 32 --s3-chunk-size 256M  downloader:pocket-public-blockchains/pocket-network-data-RC-0.6.3.6.tar ./

mkdir -p node1/data

tar -xvf ./pocket-network-data-RC-0.6.3.6.tar -C node1/data 

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

