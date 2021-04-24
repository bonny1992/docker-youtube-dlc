FROM alpine:3.12

# https://github.com/Yelp/dumb-init/releases
ARG DUMB_INIT_VERSION=1.2.2

RUN set -x \
 && apk add --no-cache \
        ca-certificates \
        curl \
        dumb-init \
        ffmpeg \
        gnupg \
        python3 \
    # Install youtube-dl
    # https://github.com/rg3/youtube-dl
 && curl -Lo /usr/local/bin/youtube-dlc https://github.com/blackjack4494/yt-dlc/releases/latest/download/youtube-dlc \
 && chmod a+rx /usr/local/bin/youtube-dlc \
    # Requires python -> python3.
 && ln -s /usr/bin/python3 /usr/bin/python \
    # Clean-up
 && apk del curl gnupg \
    # Create directory to hold downloads.
 && mkdir /downloads \
 && chmod a+rw /downloads \
    # Sets up cache.
 && mkdir /.cache \
 && chmod 777 /.cache

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

WORKDIR /downloads

VOLUME ["/downloads"]

# Basic check.
RUN dumb-init youtube-dlc --version

ENTRYPOINT ["dumb-init", "youtube-dlc"]
CMD ["--help"]