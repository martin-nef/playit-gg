FROM debian:bookworm-slim

ARG TARGETARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
    # install playit binary for current target architecture
    && case "$TARGETARCH" in \
        amd64) PLAYIT_ARCH="amd64" ;; \
        arm64) PLAYIT_ARCH="aarch64" ;; \
        *) echo "Unsupported TARGETARCH: $TARGETARCH" && exit 1 ;; \
    esac \
    && curl -fL "https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-${PLAYIT_ARCH}" \
        -o /usr/local/bin/playit \
    && chmod +x /usr/local/bin/playit \
    # strip build-time packages and clean caches
    && apt-get purge -y curl \
    && apt-get autoremove -y --purge \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/playit"]
CMD ["--secret_wait", "--stdout"]
