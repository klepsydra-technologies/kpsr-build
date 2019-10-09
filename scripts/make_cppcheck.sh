#!/bin/bash

echo 'make_cppcheck.sh script...'
echo '#!/bin/bash'
echo '#!/bin/bash' > copy_cppcheck.sh
for target in $(make help | grep cppcheck | grep -v '\<all_cppcheck\>' | awk '{print $2}'); do
    mkdir $target
    make $target > $target/cppcheck-result.log 2> $target/cppcheck-result.xml
    sed -i -e 's@/opt/$1/@@g' $target/cppcheck-result.xml
    echo "mkdir -p $target && docker cp \$1:/opt/$1/build/$target/cppcheck-result.xml $target"
    echo "mkdir -p $target && docker cp \$1:/opt/$1/build/$target/cppcheck-result.xml $target" >> copy_cppcheck.sh
done

