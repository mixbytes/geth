FROM golang:1.10-alpine as build

ARG VERSION=1.8.6

RUN apk add --no-cache curl make gcc musl-dev linux-headers

RUN mkdir /app && \
    curl https://codeload.github.com/ethereum/go-ethereum/tar.gz/v${VERSION} > /app/geth.tar.gz
RUN apk add --no-cache tar                                                              
RUN tar -zxvf  /app/geth.tar.gz -C /app/ --strip-components=1
RUN cd /app/ && make 

FROM alpine:latest
RUN apk add --no-cache ca-certificates sudo
COPY --from=build /app/build/bin/geth /usr/bin/geth
RUN adduser geth -h /data -u 1001 -g 'ethereum node' -S 
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 8545 8546 30303 30303/udp


ENTRYPOINT ["/usr/bin/entrypoint.sh"]
