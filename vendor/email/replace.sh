#!/usr/bin/env bash

cd dist
sed -e 's=http://zazo-friendfinder.dev=<%\= Figaro.env.friendfinder_base_url %>=g' index.html > index.html.tmp && mv index.html.tmp index.html
sed -e 's=#replace-action-link-unsubscribe=<%\= @data.unsubscribe_link %>=g' index.html > index.html.tmp && mv index.html.tmp index.html
sed -e 's=#replace-action-link-ignore=<%\= @data.ignore_link %>=g' index.html > index.html.tmp && mv index.html.tmp index.html
sed -e 's=#replace-action-link-add=<%\= @data.add_link %>=g' index.html > index.html.tmp && mv index.html.tmp index.html
sed -e 's=#replace-track-email=<%\= @data.track_email %>=g' index.html > index.html.tmp && mv index.html.tmp index.html
sed -e 's=Your Friend=<%\= @data.contact.name %>=g' index.html > index.html.tmp && mv index.html.tmp index.html
sed -e 's=Owner=<%\= @data.owner.first_name %>=g' index.html > index.html.tmp && mv index.html.tmp index.html
cd ..
