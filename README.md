## p2p-pectra-bulker
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
$ forge script script/Deploy.s.sol:Deploy --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast --chain $CHAIN_ID --json --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvvvv
```
