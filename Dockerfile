FROM debian:bookworm-slim
LABEL maintainer="rshmyrev <rshmyrev@gmail.com>"

# Install required deps
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      libegl1 \
      libgl1 \
      libpulse0 \
 && rm -rf /var/lib/apt/lists/*

# Install Tribler dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libgmp-dev \
    libssl-dev \
    libx11-6 \
    python3 \
    python3-libtorrent \
    python3-minimal \
    python3-pip \
    python3-pyqt5 \
    python3-pyqt5.qtsvg \
    python3-scipy \
    vlc \
    x11-utils \
 && rm -rf /var/lib/apt/lists/*

# Install Tribler
ARG VERSION=7.13.0
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      wget \
 && update-ca-certificates \
 && wget https://github.com/Tribler/tribler/releases/download/v"${VERSION}"/tribler_"${VERSION}"_all.deb \
    -O /tmp/tribler.deb \
 && apt-get install -y --no-install-recommends \
    /tmp/tribler.deb \
 && rm -rf /var/lib/apt/lists/* /tmp/*

# Create a user and directories
RUN adduser user \
 && mkdir -p /data /downloads \
 && ln -s /data      /home/user/.Tribler \
 && ln -s /downloads /home/user/Downloads \
 && chown -R user:user /data /downloads /home/user

VOLUME ["/data", "/downloads"]
WORKDIR /home/user
USER user
ENTRYPOINT ["/usr/bin/tribler"]
