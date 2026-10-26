FROM ruby:3.4.12-bookworm@sha256:9d1b22f2341dc96a1cd2f4f4495a31c19495b42ed243f1338e60075210025fd4

EXPOSE 4567:4567
EXPOSE 35729:35729

WORKDIR /usr/src/gems

COPY ./Gemfile /usr/src/gems
COPY Gemfile.lock /usr/src/gems

RUN apt-get update && apt-get install -y nodejs

RUN bundle install

WORKDIR /usr/src/docs

CMD [ "bundle", "exec", "--gemfile=/usr/src/gems/Gemfile", "middleman", "server" ]
