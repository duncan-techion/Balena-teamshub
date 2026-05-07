FROM balenalib/intel-nuc-debian:bookworm-run

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    xinit \
    xserver-xorg \
    openbox \
    dbus-x11 \
    pulseaudio \
    alsa-utils \
    libnss3 \
    libxss1 \
    libasound2 \
    libgbm1 \
    ca-certificates \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
