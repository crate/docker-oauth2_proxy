# oauth2_proxy Dockerfile

This repository contains **Dockerfile** of [oauth2_proxy](https://github.com/bitly/oauth2_proxy/) for [Docker](https://www.docker.com/).

## Usage

    create a file <config-dir>/oauth2_proxy.cfg for configuration

    docker run -d -p 4180:4180 -v <config-dir>:/conf crate/oauth2_proxy
