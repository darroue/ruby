ARG image

FROM $image

ARG packages

ENV SECRET_KEY_BASE=21fb7205d746fd4e093291cc8fc9c87d
ENV RAILS_MASTER_KEY=ae25e2db6bbb94865c5109ea0ccf6b88b28cd2fee3c34174d1a41c7ddf039247168f79a6c90d4d2169d37ae65406080ddc7e47a8dd52b41027ed06df00430ecf
ENV RAILS_ENV=production
ENV NODE_ENV=production

WORKDIR /root

RUN apt-get update \
  && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
  && npm install -g yarn \
  && apt-get install -y $packages \
  && rm -rf /var/lib/apt/lists/*
