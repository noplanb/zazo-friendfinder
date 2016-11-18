FROM zazo/rails

RUN apt-get -y -q update
RUN apt-get -y -q install cron redis-server
RUN rake assets:precompile

EXPOSE 80
CMD bin/start.sh
