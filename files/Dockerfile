FROM alpine:latest
RUN apk --no-cache add dhcprelay tzdata
EXPOSE 67 67/udp
ENTRYPOINT ["dhcprelay", "-d"]
