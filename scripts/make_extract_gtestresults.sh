#!/bin/sh

for f in $(find build -iname 'gtestresults.xml'); do
    sed -i 's@^build/@@g' $f
done

