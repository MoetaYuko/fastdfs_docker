# Dockerfile for fastdfs

This simple fastdfs docker image runs fastdfs tracker, storage and nginx extension at the same time. In most cases you don't want to do this, so this is mainly for demo use.

## Build the image

```bash
git clone https://github.com/dianlujitao/fastdfs_docker
cd fastdfs_docker
docker build -t fastdfs .
```

## Run the image

```bash
docker run -d --network=host \
	-v /opt/fastdfs:/opt/fastdfs \
	-v /path/to/your/storage.conf:/etc/fdfs/storage.conf \
	-v /path/to/your/tracker.conf:/etc/fdfs/tracker.conf \
	-v /path/to/your/mod_fastdfs.conf:/etc/fdfs/mod_fastdfs.conf \
	-v /path/to/your/http.conf:/etc/fdfs/http.conf \
	-v /path/to/your/mime.types:/etc/fdfs/mime.types \
	fastdfs
```

