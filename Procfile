web: puma
nginx: service nginx start
redis: redis-server
resque: TERM_CHILD=1 QUEUES=* rake resque:work
