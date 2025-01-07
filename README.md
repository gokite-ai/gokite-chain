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
  -e AVALANCHEGO_TRACK_SUBNETS=XgNrCeD6fXTT5Z1ty8TcFzfGtateSi7yfupjaPUeoojQp6xDA \
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
  -e AVALANCHEGO_TRACK_SUBNETS=XgNrCeD6fXTT5Z1ty8TcFzfGtateSi7yfupjaPUeoojQp6xDA \
  -e AVALANCHEGO_HTTP_ALLOWED_HOSTS="*" \
  -e AVALANCHEGO_HTTP_HOST=0.0.0.0 \
  -e AVALANCHEGO_PUBLIC_IP_RESOLUTION_SERVICE=ifconfigme \
  -e AVALANCHEGO_PARTIAL_SYNC_PRIMARY_NETWORK=true \
  ghcr.io/zettablock/gokite-chain:latest-archive
```

## API Endpoints

Once bootstrapped, the following API endpoints will be available:

- **HTTP RPC**: `http://localhost:9650/ext/bc/w7DLJh6sr9An1UA2aJUmL2VYBBHtKk156PbLEAdTkKU71nQ4d/rpc`
- **WebSocket**: `ws://localhost:9650/ext/bc/w7DLJh6sr9An1UA2aJUmL2VYBBHtKk156PbLEAdTkKU71nQ4d/ws`

## Health Check

Monitor node health status:
```sh
curl http://localhost:9650/ext/health
```
The node is ready when the response shows `"healthy": true`.

## Data and Keys

The data directory is located at `$(pwd)/data`.
If you want to use a different directory, you can change the `-v "$(pwd)/data:/data"` option in the deployment command.

The keys are randomly generated and stored in the directory under the `data/staking` directory.
If you are running the node for validator, you may want to generate the keys manually and replace the existing keys.

## Run the Node Manually

All the configurations and commands to build the docker image are in the this repository.

If you want to run the node manually without using docker, feel free to check github actions to see how to build and run the node.
