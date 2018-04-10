FROM golang:1.9.3

ENV CONFD_VERSION 0.11.0

# Download and install confd tool
RUN cd /usr/src \
  && mkdir -p $GOPATH/src/github.com/kelseyhightower \
  && curl -SLO "https://github.com/kelseyhightower/confd/archive/v$CONFD_VERSION.tar.gz" \
  && tar xvzf "v$CONFD_VERSION.tar.gz" -C "$GOPATH/src/github.com/kelseyhightower" \
  && rm  -rf "/usr/src/v$CONFD_VERSION.tar.gz" \
  && cd "$GOPATH/src/github.com/kelseyhightower/confd-$CONFD_VERSION" \
  && go get github.com/constabulary/gb/... \
  && ./build . \
  && ./install \
  && bash -c "mkdir -pv /etc/confd/{conf.d,templates}"

# Pgbouncer version
ENV PGBOUNCER_VERSION 1.8.1
ENV PGBOUNCER_TAR_URL https://pgbouncer.github.io/downloads/files/${PGBOUNCER_VERSION}/pgbouncer-${PGBOUNCER_VERSION}.tar.gz
ENV PGBOUNCER_SHA_URL ${PGBOUNCER_TAR_URL}.sha256

# Expose pgbouncer port
EXPOSE 6432

# Install build dependencies
RUN apt-get update -y --fix-missing
RUN apt-get install -y automake build-essential libevent-dev libssl-dev pkg-config postgresql-client libc-ares-dev
RUN apt-get purge -y --auto-remove
RUN rm -rf /var/lib/apt/lists/*

# Download source code
RUN curl -SLO ${PGBOUNCER_TAR_URL} \
&& curl -SLO ${PGBOUNCER_SHA_URL} \
&& cat pgbouncer-${PGBOUNCER_VERSION}.tar.gz.sha256 | sha256sum -c - \
&& tar -zxf pgbouncer-${PGBOUNCER_VERSION}.tar.gz \
&& chown root:root pgbouncer-${PGBOUNCER_VERSION}

# Build pgbouncer source code
RUN cd pgbouncer-${PGBOUNCER_VERSION} \
&& ./configure --prefix=/usr/local \
--with-libevent=libevent-prefix \
--with-cares=cares-prefix \
--with-openssl=openssl-prefix \
&& make && make install

# Create pgbouncer config directory
RUN mkdir -p /etc/pgbouncer

# Create pgbouncer group
RUN groupadd -r pgbouncer
RUN useradd -r -g pgbouncer pgbouncer

# Make sure pgbouncer user can read and write log files
RUN mkdir -p /var/log/pgbouncer
RUN mkdir -p /var/run/pgbouncer
RUN chown -R pgbouncer:pgbouncer /var/log/pgbouncer
RUN chown -R pgbouncer:pgbouncer /var/run/pgbouncer

# Copy templates to conf.d directory
COPY conf.d/* /etc/confd/conf.d/
COPY templates/* /etc/confd/templates/
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
