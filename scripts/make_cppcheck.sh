#!/bin/bash

echo 'make_cppcheck.sh script...'
for target in $(make help | grep cppcheck | grep -v '\<all_cppcheck\>' | awk '{print $2}'); do
    mkdir $target
    make $target > $target/cppcheck-result.log 2> $target/cppcheck-result.xml
    sed -i -e "s@/opt/$1/@@g" $target/cppcheck-result.xml
done

