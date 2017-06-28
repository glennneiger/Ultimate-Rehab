#!/bin/bash

set -euo pipefail

SOURCE=$( readlink "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}" )
DIR=$( cd "$( dirname "$SOURCE" )" && pwd )
UR_MODE="${UR_MODE:-prod}"

# Bundler expects application directory as pwd
cd "$DIR"

# Stop
su app -c 'ps --no-headers -u app -o pid,cmd |
            { grep "[u]ltimate-rehab" || true; } |
            awk '"'"' { print $1 } '"'"' |
            xargs -I{} kill {}'
# Start
su app <<EOF
    UR_MODE="$UR_MODE" nohup bundle exec ruby "$DIR/backend/renewal_email.rb" &
    UR_MODE="$UR_MODE" nohup bundle exec ruby "$DIR/backend/renew_account.rb" &
    UR_MODE="$UR_MODE" nohup bundle exec ruby "$DIR/backend/main.rb" &
    UR_MODE="$UR_MODE" nohup bundle exec ruby "$DIR/spa/server.rb" &
EOF
