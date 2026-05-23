FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
    # add playit GPG key and apt source
    && curl -SsL https://playit-cloud.github.io/ppa/key.gpg \
        | gpg --dearmor \
        > /etc/apt/trusted.gpg.d/playit.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" \
        > /etc/apt/sources.list.d/playit-cloud.list \
    # install playit
    && apt-get update \
    && apt-get install -y --no-install-recommends playit \
    # strip build-time packages and clean caches
    && apt-get purge -y curl gnupg \
    && apt-get autoremove -y --purge \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/playit"]
CMD ["--secret_wait", "--stdout"]
