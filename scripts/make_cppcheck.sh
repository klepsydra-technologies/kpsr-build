#!/bin/bash
# Copyright 2023 Klepsydra Technologies AG
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo 'make_cppcheck.sh script...'
for target in $(make help | grep cppcheck | grep -v '\<all_cppcheck\>' | awk '{print $2}'); do
    mkdir $target
    make $target > $target/cppcheck-result.log 2> $target/cppcheck-result.xml
    sed -i -e "s@/opt/$1/@@g" $target/cppcheck-result.xml
done

