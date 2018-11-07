# oauth2_proxy

[oauth2_proxy](https://github.com/bitly/oauth2_proxy) is a reverse proxy and
static file server that provides authentication using Providers (Google,
GitHub, and others) to validate accounts by email, domain or group.

## Quickstart

To be able to start oauth2_proxy you need to configure an OAuth Provider first.
Instructions for Google and others are found on the [oauth2_proxy website](https://github.com/bitly/oauth2_proxy#google-auth-provider).
Note your `client-id` and `client-secret`.

In the minimal configuration you also need to specify the `upstream` you are
protecting.

```sh
$ docker run -d -p 4180:4180 \
    -e OAUTH2_PROXY_CLIENT_ID=... \
    -e OAUTH2_PROXY_CLIENT_SECRET=... \
    -e OAUTH2_PROXY_UPSTREAM=... \
    machinedata/oauth2_proxy
```

## Development

The image is built by Jenkins and pushed to the Crate.io container registry on
Azure. Jenkins will build a Docker image on each push to the master branch and
will tag it `latest`. It will also build images for each tag of the repository.

## Environment variables

It is very easy to configure oauth2_proxy via environment variables. If no
config file is present, the `docker-entrypoint.sh` script will create one
based on the passed environment variables.

- `OAUTH2_PROXY_CLIENT_ID`: the OAuth Client ID: ie: "123456.apps.googleusercontent.com"

- `OAUTH2_PROXY_CLIENT_SECRET`: the OAuth Client Secret

- `OAUTH2_PROXY_COOKIE_SECRET`: the seed string for secure cookies. To
  generate a strong cookie secret just run `python -c 'import os,base64; print base64.b64encode(os.urandom(18))'`.

- `OAUTH2_PROXY_EMAIL_DOMAIN`: authenticate emails with the specified domain
  (may be given multiple times). The default is "*" and will authenticate any
  email.

- `OAUTH2_PROXY_UPSTREAM`: the http url(s) of the upstream endpoint or file://
  paths for static files. Routing is based on the path


You can pass any variable that is specified on the [command line options](https://github.com/bitly/oauth2_proxy#command-line-options)
documentation.

- `OAUTH2_PROXY_APPROVAL_PROMPT`
- `OAUTH2_PROXY_AUTHENTICATED_EMAILS_FILE`
- `OAUTH2_PROXY_AZURE_TENANT`
- `OAUTH2_PROXY_BASIC_AUTH_PASSWORD`
- `OAUTH2_PROXY_CONFIG`
- `OAUTH2_PROXY_COOKIE_DOMAIN`
- `OAUTH2_PROXY_COOKIE_EXPIRE`
- `OAUTH2_PROXY_COOKIE_HTTPONLY`
- `OAUTH2_PROXY_COOKIE_NAME`
- `OAUTH2_PROXY_COOKIE_REFRESH`
- `OAUTH2_PROXY_COOKIE_SECURE`
- `OAUTH2_PROXY_CUSTOM_TEMPLATES_DIR`
- `OAUTH2_PROXY_DISPLAY_HTPASSWD_FORM`
- `OAUTH2_PROXY_FOOTER`
- `OAUTH2_PROXY_GITHUB_ORG`
- `OAUTH2_PROXY_GITHUB_TEAM`
- `OAUTH2_PROXY_GOOGLE_ADMIN_EMAIL`
- `OAUTH2_PROXY_GOOGLE_GROUP`
- `OAUTH2_PROXY_GOOGLE_SERVICE_ACCOUNT_JSON`
- `OAUTH2_PROXY_HTPASSWD_FILE`
- `OAUTH2_PROXY_HTTP_ADDRESS`
- `OAUTH2_PROXY_HTTPS_ADDRESS`
- `OAUTH2_PROXY_LOGIN_URL`
- `OAUTH2_PROXY_PASS_ACCESS_TOKEN`
- `OAUTH2_PROXY_PASS_BASIC_AUTH`
- `OAUTH2_PROXY_PASS_HOST_HEADER`
- `OAUTH2_PROXY_PROFILE_URL`
- `OAUTH2_PROXY_PROVIDER`
- `OAUTH2_PROXY_PROXY_PREFIX`
- `OAUTH2_PROXY_REDEEM_URL`
- `OAUTH2_PROXY_REDIRECT_URL`
- `OAUTH2_PROXY_RESOURCE`
- `OAUTH2_PROXY_REQUEST_LOGGING`
- `OAUTH2_PROXY_SCOPE`
- `OAUTH2_PROXY_SIGNATURE_KEY`
- `OAUTH2_PROXY_SKIP_AUTH_REGEX`
- `OAUTH2_PROXY_SKIP_PROVIDER_BUTTON`
- `OAUTH2_PROXY_TLS_CERT`
- `OAUTH2_PROXY_TLS_KEY`
- `OAUTH2_PROXY_VALIDATE_URL`

## Configuration file

The container is configured to start oauth2_proxy with `/conf/oauth2_proxy.cfg`
as config file. If a config file is mounted (preferably read-only), the
`OAUTH2_PROXY_` environment variables will be ignored. Use the [example config](https://github.com/bitly/oauth2_proxy/blob/master/contrib/oauth2_proxy.cfg.example)
to start:

```sh
$ curl -O https://raw.githubusercontent.com/bitly/oauth2_proxy/master/contrib/oauth2_proxy.cfg.example
$ mv oauth2_proxy.cfg.example oauth2_proxy.cfg
$ sed -i -e "s/# http_address = .*/http_address = \"0.0.0.0:4180\"/" oauth2_proxy.cfg.example
$ docker run -d \
             -v $(pwd)/oauth2_proxy.cfg.example:/conf/oauth2_proxy.cfg:ro \
             -p 4180:4180 machinedata/oauth2_proxy
```

## Volumes

- `/templates`: Path to place custom templates `sign_in.html` and `error.html`.
  You also need to set `custom-templates-dir` via config file or the
  `OAUTH2_PROXY_CUSTOM_TEMPLATES_DIR` environment variable.

## Ports

- `4180`: The default port where oauth2_proxy is listening. Can be changed via
  `http-address` (and/or `https_address`) setting and corresponding
  `OAUTH2_PROXY_` environment variable.
