## p2p-pectra-bulk
Contract for bulk pectra operations: consolidation, partial withdrawal

## Usage

## Running tests

```shell
$ curl -L https://foundry.paradigm.xyz | bash
$ source /Users/$USER/.bashrc
$ foundryup
$ forge test
```

### Build

```shell
$ forge build
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Deploy.s.sol:Deploy --rpc-url <rpc_url> --broadcast --chain <chain_id> --json --verify --etherscan-api-key=<etherscan_api_key> -vvvvv  
```