# Kite Chain

This repository contains configurations and setup for running Kite Chain nodes.

## System Requirements

### Minimum Hardware Specifications

- CPU: 8 AWS vCPU or equivalent
- RAM: 16GB
- Storage: 1TB SSD


### Network Requirements

- Open inbound ports:
  - TCP/9650: HTTP API
  - TCP/9651: P2P Staking

## Deployment Options

### Standard RPC Node

Run a standard RPC node using `latest` tag in the gokite-chain's [Github Container Registry](https://github.com/Zettablock/gokite-chain/pkgs/container/gokite-chain) with:

```sh
docker run -d \
  --name gokite-chain-rpc-node \
  --restart unless-stopped \
  -v "$(pwd)/data:/data" \
  -u "${CURRENT_UID}:${CURRENT_GID}" \
  -p 9650:9650 \
  -p 9651:9651 \
  -e AVALANCHEGO_CHAIN_CONFIG_DIR=/config \
  -e AVALANCHEGO_NETWORK_ID=fuji \
  -e AVALANCHEGO_DATA_DIR=/data \
  -e AVALANCHEGO_PLUGIN_DIR=/plugins/ \
  -e AVALANCHEGO_HTTP_PORT=9650 \
  -e AVALANCHEGO_STAKING_PORT=9651 \
  -e AVALANCHEGO_TRACK_SUBNETS=2ayt7g4JZeyL7mZNmxm4SpvxY6JHcFkv5KSLFLfV7eQiu1MEck \
  -e AVALANCHEGO_HTTP_ALLOWED_HOSTS="*" \
  -e AVALANCHEGO_HTTP_HOST=0.0.0.0 \
  -e AVALANCHEGO_PUBLIC_IP_RESOLUTION_SERVICE=ifconfigme \
  -e AVALANCHEGO_PARTIAL_SYNC_PRIMARY_NETWORK=true \
  ghcr.io/zettablock/gokite-chain:latest
```

### Archive Node

For historical data access and analytics, deploy an archive node using `latest-archive` tag in the gokite-chain's [Github Container Registry](https://github.com/Zettablock/gokite-chain/pkgs/container/gokite-chain) with:

```sh
docker run -d \
  --name gokite-chain-archive-node \
  --restart unless-stopped \
  -v "$(pwd)/data:/data" \
  -u "${CURRENT_UID}:${CURRENT_GID}" \
  -p 9650:9650 \
  -p 9651:9651 \
  -e AVALANCHEGO_CHAIN_CONFIG_DIR=/config \
  -e AVALANCHEGO_NETWORK_ID=fuji \
  -e AVALANCHEGO_DATA_DIR=/data \
  -e AVALANCHEGO_PLUGIN_DIR=/plugins/ \
  -e AVALANCHEGO_HTTP_PORT=9650 \
  -e AVALANCHEGO_STAKING_PORT=9651 \
  -e AVALANCHEGO_TRACK_SUBNETS=2ayt7g4JZeyL7mZNmxm4SpvxY6JHcFkv5KSLFLfV7eQiu1MEck \
  -e AVALANCHEGO_HTTP_ALLOWED_HOSTS="*" \
  -e AVALANCHEGO_HTTP_HOST=0.0.0.0 \
  -e AVALANCHEGO_PUBLIC_IP_RESOLUTION_SERVICE=ifconfigme \
  -e AVALANCHEGO_PARTIAL_SYNC_PRIMARY_NETWORK=true \
  ghcr.io/zettablock/gokite-chain:latest-archive
```

## API Endpoints

Once bootstrapped, the following API endpoints will be available:

- **HTTP RPC**: `http://localhost:9650/ext/bc/VNMhjeX6p7xc24K9BCAijEDoX9xpUVDnkvJFNUuCXm71XU6QU/rpc`
- **WebSocket**: `ws://localhost:9650/ext/bc/VNMhjeX6p7xc24K9BCAijEDoX9xpUVDnkvJFNUuCXm71XU6QU/ws`

## Health Check

Monitor node health status:
```sh
curl -X POST http://localhost:9650/ext/health
```
The node is ready when the response shows `"healthy": true`.
