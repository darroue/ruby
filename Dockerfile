FROM ubuntu:latest

ARG packages
ARG commands
ARG ruby_version
ARG asdf_version

ENV RAILS_ENV=production

ENV SECRET_KEY_BASE=21fb7205d746fd4e093291cc8fc9c87d
ENV RAILS_MASTER_KEY=ae25e2db6bbb94865c5109ea0ccf6b88b28cd2fee3c34174d1a41c7ddf039247168f79a6c90d4d2169d37ae65406080ddc7e47a8dd52b41027ed06df00430ecf
ENV RAILS_SERVE_STATIC_FILES=1

WORKDIR /root

RUN apt-get update \
  && apt-get install -y --no-install-recommends $packages \
  && rm -rf /var/lib/apt/lists/*

# Install asdf system-wide from official release
RUN curl -LO "https://github.com/asdf-vm/asdf/releases/download/${asdf_version}/asdf-${asdf_version}-linux-amd64.tar.gz" \
  && tar -xzf "asdf-${asdf_version}-linux-amd64.tar.gz" -C /opt \
  && rm "asdf-${asdf_version}-linux-amd64.tar.gz" \
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
