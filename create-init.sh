#!/bin/bash

set -eux

echo "#!/usr/bin/bash" > scratch-space/init
echo "exec /usr/bin/bash" >> scratch-space/init
chmod +x scratch-space/init

