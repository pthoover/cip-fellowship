FROM rocker/r-ver:latest

ARG CMDSTAN_VER=2.33.1
WORKDIR /opt

RUN apt update && \
    apt install -y curl && \
    apt install -y git && \
    apt install -y openmpi-bin && \
    apt install -y libopenmpi-dev && \
    apt install -y libglpk40 && \
    apt install -y libxt6 && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --branch v${CMDSTAN_VER} --depth 1 --recurse-submodules --shallow-submodules https://github.com/stan-dev/cmdstan.git
COPY ./cmdstan_make_local ./cmdstan/make/local
RUN cd cmdstan && \
    make build

ENV CMDSTAN=/opt/cmdstan

RUN install2.r --error --skipinstalled lme4 brms dplyr
RUN Rscript -e 'install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))'
RUN rm -rf /tmp/downloaded_packages

RUN echo "#!/bin/bash" > /usr/local/bin/entrypoint && \
    echo "export PATH=\$PATH:\$CMDSTAN/bin" >> /usr/local/bin/entrypoint && \
    echo 'exec Rscript "$@"' >> /usr/local/bin/entrypoint && \
    chmod a+x /usr/local/bin/entrypoint

WORKDIR /home/work
ENTRYPOINT ["entrypoint"]
