#!/usr/bin/env bash

pelican content -o output -s pelicanconf.py
ghp-import output
git push git@github.com:desertsniper87/desertsniper87.github.io.git gh-pages:master --force

