#!/bin/bash

set -euo pipefail

AVAGO_DATA_DIR=${AVAGO_DATA_DIR:-$HOME/.avalanchego}

# Set default plugin dir if not set
if [ -z "${AVAGO_PLUGIN_DIR:-}" ]; then
    export AVAGO_PLUGIN_DIR="/plugins/"
fi

# Write BLS key if provided
if [ -n "${BLS_KEY_BASE64:-}" ]; then
    mkdir -p "$AVAGO_DATA_DIR/staking"
    echo "$BLS_KEY_BASE64" | base64 -d > "$AVAGO_DATA_DIR/staking/signer.key"
fi



# If PLUGIN_ID is provided, ensure plugin dir exists by copying subnet-evm
if [ -n "${PLUGIN_ID:-}" ]; then
    SRC_PLUGIN_FILE="/plugins-template/subnet-evm"
    DEST_PLUGIN_FILE="${AVAGO_PLUGIN_DIR%/}/${PLUGIN_ID}"
    if [ -f "$SRC_PLUGIN_FILE" ]; then
        if [ ! -e "$DEST_PLUGIN_FILE" ]; then
            echo "Preparing plugin: copying $SRC_PLUGIN_FILE -> $DEST_PLUGIN_FILE"
            mv "$SRC_PLUGIN_FILE" "$DEST_PLUGIN_FILE"
        else
            echo "Plugin destination already exists: $DEST_PLUGIN_FILE (skipping copy)"
        fi
    else
        echo "Warning: source plugin not found at $SRC_PLUGIN_FILE"
    fi
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

# Launch avalanchego with dynamic flags
/usr/local/bin/avalanchego $EXTRA_FLAGS
