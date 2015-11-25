## oauth2_proxy Dockerfile


This repository contains **Dockerfile** of [oauth2_proxy](https://github.com/bitly/oauth2_proxy/) for [Docker](https://www.docker.com/).


### Base Docker Image

* [golang](https://hub.docker.com/_/golang/)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download [build](https://registry.hub.docker.com/u/crate/oauth2_proxy/) from public [Docker Hub Registry](https://registry.hub.docker.com/): `docker pull crate/oauth2_proxy`

   (alternatively, you can build an image from Dockerfile: `docker build -t="crate/oauth2_proxy" github.com/crate/docker-oauth2_proxy`)


### Usage

    create a file <config-dir>/oauth2_proxy.cfg for configuration

    docker run -d -p 4180:4180 -v <config-dir>:/conf crate/oauth2_proxy
