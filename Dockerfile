FROM zazo/rails

RUN apt-get -y -q install cron redis-server
RUN rake assets:precompile RAILS_ENV=production

EXPOSE 80
CMD bin/start.sh
