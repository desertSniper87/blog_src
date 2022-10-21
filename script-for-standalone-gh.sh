#!/usr/bin/env


#git clone git@github.com:desertSniper87/desertSniper87.github.io.github
#mv desertSniper87.github.io .output-git

rm .output-git/* -r
cp output/* .output-git/ -r

cd .output-git
git commit -am 'master branch update'
git push origin master

