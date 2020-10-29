#!/bin/bash

. $RVM_PATH/scripts/rvm

export BUNDLE_PATH=$BUILD_PATH/bundle
bundle install --path $BUNDLE_PATH
exec $@

