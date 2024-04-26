#!/usr/bin/env bash

## For linux

# ./env/bin/pelican content -o output -s pelicanconf.py
# ./env/bin/ghp-import output
# git push git@github.com:desertsniper87/desertsniper87.github.io.git gh-pages:master --force

## For Mac

pelican content -o output -s pelicanconf.py
ghp-import output
git push git@github.com:desertsniper87/desertsniper87.github.io.git gh-pages:master --force
