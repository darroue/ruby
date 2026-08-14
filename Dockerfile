FROM ubuntu:latest

ARG packages
ARG ruby_version
ARG asdf_version
ARG platform

WORKDIR /root

RUN apt-get update \
  && apt-get install -y wget gnupg2 lsb-release \
  && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && apt-get update \
  && apt-get install -y --no-install-recommends $packages \
  && ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so \
  && rm -rf /var/lib/apt/lists /var/cache/apt/archives

ARG platform
# Install asdf system-wide from official release
RUN curl -LO "https://github.com/asdf-vm/asdf/releases/download/${asdf_version}/asdf-${asdf_version}-linux-${platform}.tar.gz" \
  && tar -xzf "asdf-${asdf_version}-linux-${platform}.tar.gz" -C /opt \
  && rm "asdf-${asdf_version}-linux-${platform}.tar.gz" \
  && mv /opt/asdf /usr/local/bin/asdf \
  && chmod +x /usr/local/bin/asdf \
  && mkdir -p /opt/asdf \
  && echo 'export ASDF_DIR="/opt/asdf"' >> /etc/profile \
  && echo 'export PATH="/usr/local/bin:/root/.asdf/shims:$PATH"' >> /etc/profile

# Set environment for current session
ENV ASDF_DIR="/opt/asdf"
ENV PATH="/usr/local/bin:/root/.asdf/shims:$PATH"

# Install asdf plugins and Ruby version
RUN asdf plugin add nodejs \
  && asdf plugin add ruby \
  && asdf plugin add redis \
  && asdf set ruby $ruby_version \
  && asdf install ruby $ruby_version

ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"
