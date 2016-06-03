#!/bin/sh
service cron start
bundle exec whenever -w
rake db:migrate
foreman start
