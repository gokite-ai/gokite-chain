

# ==============================================================================
# AVALANCHEGO STAGE
# Imports the AvalancheGo binary
# ==============================================================================
ARG AVALANCHEGO_VERSION
ARG SUBNETEVM_VERSION

FROM ghcr.io/gokite-ai/avalanchego:v${AVALANCHEGO_VERSION} AS avalanchego

# ==============================================================================
# SUBNET-EVM STAGE
# Imports the Subnet-EVM plugin from the merged AvalancheGo release image
# ==============================================================================
FROM ghcr.io/gokite-ai/subnet-evm:v${SUBNETEVM_VERSION} AS subnetevm

# ==============================================================================
# FINAL STAGE
# Combines binaries and sets up the runtime environment
# ==============================================================================
FROM debian:bookworm-slim

COPY --from=avalanchego /avalanchego/build/avalanchego /usr/local/bin/avalanchego
RUN mkdir -p /plugins/ /plugins-template/
COPY --from=subnetevm /avalanchego/build/plugins/srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy /plugins-template/subnet-evm

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
