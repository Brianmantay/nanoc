FROM ruby:2.3
RUN mkdir -p /user/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app/blog
EXPOSE 3000
RUN bundle install
CMD bundle exec nanoc -v && bundle exec nanoc view






