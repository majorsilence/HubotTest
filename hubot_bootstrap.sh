#!/usr/bin/env bash
set -e # exit on first error
set -u # exit on using unset variable


# This script is used if you want to initilize a new hubot.
# I generally use this on windows machines to generate my hubot before I 
# commit it to git

function initialize_setup()
{
    npm install -g hubot coffee-script yo generator-hubot forever forever-service hubot-slack

    mkdir -p yoda
    cd yoda
    yo hubot --defaults --name="yoda" --adapter="slack" --owner="Peter Gill <peter@majorsilence.com>"
  
}


initialize_setup
