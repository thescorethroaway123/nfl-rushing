FROM hexpm/elixir:1.12.3-erlang-24.1.2-alpine-3.14.2 as otp-builder

ENV MIX_ENV=prod

WORKDIR /build

# Alpine dependencies
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache git

# Erlang dependencies
RUN mix local.rebar --force && \
    mix local.hex --force

# Hex dependencies
COPY mix.* ./
RUN mix deps.get --only prod
RUN mix deps.compile

# Compile app
ARG APP_NAME
ARG APP_VERSION

ENV APP_NAME=${APP_NAME} \
    APP_VERSION=${APP_VERSION}

# Compile codebase
COPY config config
COPY lib lib
COPY priv priv
RUN mix compile

# Build OTP release
COPY rel rel
RUN mix release

#
# Step 4 - build a lean runtime container
#
FROM alpine:3.14.2

ARG APP_NAME
ARG APP_VERSION

ENV APP_NAME=${APP_NAME} \
    APP_VERSION=${APP_VERSION}

# Install Alpine dependencies
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache bash openssl libgcc libstdc++ ncurses-libs

WORKDIR /opt/rush

# Copy the OTP binary from the build step
COPY --from=otp-builder /build/_build/prod/${APP_NAME}-${APP_VERSION}.tar.gz .
RUN tar -xvzf ${APP_NAME}-${APP_VERSION}.tar.gz && \
    rm ${APP_NAME}-${APP_VERSION}.tar.gz

# Copy Docker entrypoint
COPY priv/scripts/docker-entrypoint.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

# Create non-root user
RUN adduser -D rush && \
    chown -R rush: /opt/rush
USER rush

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]
