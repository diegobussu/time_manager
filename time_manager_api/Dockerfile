FROM elixir:latest

RUN apt-get update && apt-get install -y postgresql-client

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix local.hex --force

RUN mix local.rebar --force

RUN mix deps.get
RUN mix deps.compile

RUN mix do compile

EXPOSE 4000

RUN chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]
