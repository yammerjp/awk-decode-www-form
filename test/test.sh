#!/bin/bash

set -e

diff <(gawk -f ../decode-www-form.awk -f ../sample.awk 1.in) 1.ok
diff <(gawk -f ../decode-www-form.awk -f ../sample.awk 2.in) 2.ok

echo "All tests passed"
