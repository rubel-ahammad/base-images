#!/usr/bin/env bash

# import basic functions
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${DIR}/scripts/functions.sh"

read -p "Enter Ubuntu Pro token: " pro_token
setup_pro_attach_config "${pro_token}" > "$(pro_attach_config_log_file)" 2>&1
echo 'Ubuntu Pro attach config: done!'
