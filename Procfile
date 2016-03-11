web: puma
nginx: service nginx start
redis: redis-server
resque_add_contacts: TERM_CHILD=1 QUEUES=add_contacts rake resque:work
resque_update_contacts: TERM_CHILD=1 QUEUES=update_contacts COUNT=2 rake resque:work
