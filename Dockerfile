FROM elixir:1.13.3

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y build-essential
RUN apt-get install -y inotify-tools
RUN apt-get install -y nodejs
RUN apt-get install -y npm

RUN mkdir /app
WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force
    
COPY mix.exs mix.lock ./
COPY apps ./apps/
COPY config ./config/

WORKDIR /app/apps/twitter_clone_web/assets
RUN npm i

WORKDIR /app
RUN mix deps.get

WORKDIR /app/apps/twitter_clone
RUN mix ecto.reset 

EXPOSE 4000

WORKDIR /app

CMD ["mix", "phx.server"]