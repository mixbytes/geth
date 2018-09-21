FROM golang:1.11-alpine as build

ARG VERSION=1.8.15

WORKDIR /app
RUN apk add --no-cache curl make gcc musl-dev linux-headers tar
RUN curl https://codeload.github.com/ethereum/go-ethereum/tar.gz/v${VERSION} > /app/geth.tar.gz
RUN tar -zxvf  /app/geth.tar.gz -C /app/ --strip-components=1
RUN make geth

FROM alpine:3.8
RUN apk add --no-cache ca-certificates sudo
COPY --from=build /app/build/bin/geth /usr/bin/geth
RUN adduser geth -h /data -u 1001 -g 'ethereum node' -S
COPY entrypoint.sh /usr/bin/entrypoint.sh
#RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 8545 8546 30303 30303/udp

ENTRYPOINT ["/bin/sh", "/usr/bin/entrypoint.sh"]
