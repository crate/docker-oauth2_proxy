FROM golang:1.9 AS builder

WORKDIR /go/src/github.com/bitly/oauth2_proxy
#RUN git clone --branch v2.2 https://github.com/bitly/oauth2_proxy.git /go/src/github.com/bitly/oauth2_proxy/
RUN git clone https://github.com/bitly/oauth2_proxy.git /go/src/github.com/bitly/oauth2_proxy/

RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo .


FROM alpine:latest

RUN apk --no-cache add ca-certificates
COPY --from=builder /go/src/github.com/bitly/oauth2_proxy/oauth2_proxy /usr/local/bin
COPY --from=builder /go/src/github.com/bitly/oauth2_proxy/contrib/oauth2_proxy.cfg.example /etc/oauth2_proxy.cfg

ENTRYPOINT [ "oauth2_proxy" ]
CMD [ "-config=/etc/oauth2_proxy.cfg" ]

HEALTHCHECK CMD curl -f http://localhost:4180/ping || exit 1
