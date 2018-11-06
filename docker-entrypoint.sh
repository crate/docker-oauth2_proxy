#!/bin/bash
set -e

# first arg is `-f` or `--some-option`
if [ "${1:0:1}" = '-' ]; then
    set -- oauth2_proxy "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'oauth2_proxy' -a "$(id -u)" = '0' ]; then
    exec su-exec oauth2_proxy "$0" "$@"
fi

if [ "$1" = 'oauth2_proxy' ]; then
    # if no configfile is provided, generate one based on the environment variables
    if [ ! -f /conf/oauth2_proxy.cfg ]; then
        # if undefined, populate selected environment variables with sane defaults
        : ${OAUTH2_PROXY_EMAIL_DOMAIN="*"}
        : ${OAUTH2_PROXY_HTTP_ADDRESS="0.0.0.0:4180"}
        : ${OAUTH2_PROXY_COOKIE_SECRET="$(date | md5sum | awk '{ print $1 }')"}

        # available config variables '
        VARS="
            approval-prompt
            authenticated-emails-file
            azure-tenant
            basic-auth-password
            client-id
            client-secret
            config
            cookie-domain
            cookie-expire
            cookie-httponly
            cookie-name
            cookie-refresh
            cookie-secret
            cookie-secure
            custom-templates-dir
            display-htpasswd-form
            email-domain
            footer
            github-org
            github-team
            google-admin-email
            google-group
            google-service-account-json
            htpasswd-file
            http-address
            https-address
            login-url
            pass-access-token
            pass-basic-auth
            pass-host-header
            pass-user-headers
            profile-url
            provider
            proxy-prefix
            redeem-url
            redirect-url
            resource
            request-logging
            scope
            signature-key
            skip-auth-regex
            skip-auth-preflight
            skip-provider-button
            ssl-insecure-skip-verify
            tls-cert
            tls-key
            upstream
            validate-url"
        for var in ${VARS}; do
            # config file variable names are with _ instead of -
            var="$(echo ${var} | sed -e 's/-/_/g')"
            # convert config variable name to bash compatible variable name
            # e.g. "approval-prompt" becomes "OAUTH2_PROXY_APPROVAL_PROMPT"
            env_var="OAUTH2_PROXY_$(echo ${var} | tr '[:lower:]' '[:upper:]')"
            # test for environment variable existence
            if [ ! -z ${!env_var+x} ]; then
                # list values need to be treated especially
                if [ "${var}" == "upstream" ] \
                || [ "${var}" == "email_domain" ]; then
                    # plural and list
                    echo "${var}s = [ " >> /conf/oauth2_proxy.cfg
                    # disable * expansion
                    set -f
                    for v in ${!env_var}; do
                        echo "  \"${v}\"," >> /conf/oauth2_proxy.cfg
                    done
                    set +f
                    echo "]" >> /conf/oauth2_proxy.cfg
                else
                    # unfortunately ${!var} is only available in bash and not sh
                    # that's why the alpine container installs bash as runtime dependency
                    #
                    # one variable uses a dash rather than underscore...
                    # https://github.com/bitly/oauth2_proxy/issues/609
                    # two variables have a different name in cfg compared to cli
                    if [ "$var" == "proxy_prefix" ]; then
                      echo "proxy-prefix = \"${!env_var}\"" >> /conf/oauth2_proxy.cfg
                    elif [ "$var" == "tls_cert" ]; then
                      echo "tls_cert_file = \"${!env_var}\"" >> /conf/oauth2_proxy.cfg
                    elif [ "$var" == "tls_key" ]; then
                      echo "tls_key_file = \"${!env_var}\"" >> /conf/oauth2_proxy.cfg
                    else
                      echo "${var} = \"${!env_var}\"" >> /conf/oauth2_proxy.cfg
                    fi
                fi
            fi
        done
        cat /conf/oauth2_proxy.cfg
    fi
fi

exec "$@"
