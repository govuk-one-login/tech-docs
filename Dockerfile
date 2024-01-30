FROM debian:bullseye-slim as base
RUN apt update && apt install -y build-essential wget autoconf
RUN wget https://github.com/postmodern/ruby-install/releases/download/v0.9.3/ruby-install-0.9.3.tar.gz \
  && tar -xzvf ruby-install-0.9.3.tar.gz \
  && cd ruby-install-0.9.3/ \
  && make install
RUN ruby-install -p https://github.com/ruby/ruby/pull/9371.diff ruby 3.3.0
ENV PATH="/opt/rubies/ruby-3.3.0/bin:${PATH}"

EXPOSE 4567:4567
EXPOSE 35729:35729

WORKDIR /usr/src/gems

COPY ./Gemfile /usr/src/gems

RUN apt-get update && apt-get install -y nodejs

RUN bundle install

WORKDIR /usr/src/docs

CMD [ "bundle", "exec", "--gemfile=/usr/src/gems/Gemfile", "middleman", "server" ]
