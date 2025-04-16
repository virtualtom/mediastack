FROM lscr.io/linuxserver/calibre-web:latest

# Install Calibre and dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    xz-utils \
    libgl1 \
    libglib2.0-0 \
    libegl1 \
    libopengl0 \
    libxcb-cursor0 \
    libxkbcommon0 && \
    wget -nv https://download.calibre-ebook.com/6.29.0/calibre-6.29.0-x86_64.txz && \
    mkdir -p /opt/calibre && \
    tar -xvf calibre-6.29.0-x86_64.txz -C /opt/calibre && \
    ln -s /opt/calibre/ebook-convert /usr/bin/ebook-convert && \
    ln -s /opt/calibre/calibredb /usr/bin/calibredb && \
    rm -rf calibre-6.29.0-x86_64.txz /var/lib/apt/lists/*
COPY scripts/entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh
ENTRYPOINT ["/custom-entrypoint.sh"]
