FROM hexpm/elixir:1.12.3-erlang-24.1.2-alpine-3.14.2 as otp-builder

# Alpine dependencies
RUN apk --no-cache add inotify-tools

# Erlang dependencies
RUN mix local.rebar --force && \
    mix local.hex --force

WORKDIR /app

# Hex dependencies
COPY . ./
RUN mix deps.get

CMD ["mix", "phx.server"]
