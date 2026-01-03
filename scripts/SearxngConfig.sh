#!/bin/bash

SEARXNG_REPO_CONFIGS="/searxng_repo_configs"
SEARXNG_ETC_DIR="/searxng"
PUBLIC_HTML_DIR="/html"

#Copy the searxng configs
ls -al $SEARXNG_REPO_CONFIGS
cp -r $SEARXNG_REPO_CONFIGS/* $SEARXNG_ETC_DIR/.
chmod -R 755 $SEARXNG_ETC_DIR
chown -R 977:977 $SEARXNG_ETC_DIR
