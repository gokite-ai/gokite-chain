#!/bin/bash

set -euo pipefail

AVAGO_DATA_DIR=${AVAGO_DATA_DIR:-$HOME/.avalanchego}

# Set default plugin dir if not set
# if [ -z "${AVAGO_PLUGIN_DIR:-}" ]; then
#     export AVAGO_PLUGIN_DIR="/plugins/"
# fi

# Write BLS key if provided
if [ -n "${BLS_KEY_BASE64:-}" ]; then
    mkdir -p "$AVAGO_DATA_DIR/staking"
    echo "$BLS_KEY_BASE64" | base64 -d > "$AVAGO_DATA_DIR/staking/signer.key"
fi



# Function to convert ENV vars to flags
get_avalanchego_flags() {
    local flags=""
    while IFS= read -r line; do
        name="${line%%=*}"
        value="${line#*=}"
        if [[ $name == AVAGO_* ]]; then
            flag_name=$(echo "${name#AVAGO_}" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
            flags+="--$flag_name=$value "
        fi
    done < <(env)
    echo "$flags"
}

EXTRA_FLAGS=$(get_avalanchego_flags)
echo "Extra flags: $EXTRA_FLAGS"

# Launch avalanchego with dynamic flags
/usr/local/bin/avalanchego $EXTRA_FLAGS
