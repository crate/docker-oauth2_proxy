## Dockerfile For The oauth2_proxy


This repository contains a Dockerfile for the Bitly
[oauth2_proxy](https://github.com/bitly/oauth2_proxy/).


### Usage

Create a file <config-dir>/oauth2_proxy.cfg for configuration. Start a docker
container with the configuration mounted:

```bash
docker run -d -p 4180:4180 -v <config-dir>:/conf registry.cr8.net/crate/oauth2_proxy
```


### Deployment

Building a docker image:

```bash
docker build -t registry.cr8.net/crate/oauth2_proxy:latest .
```

Pushing the image to the registry:

```bash
docker push registry.cr8.net/crate/oauth2_proxy:latest
```


