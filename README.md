## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
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
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```


### Motivation 
1. Uses the same philosophy as Ether in that tokens are sent with send(dest,value,data)
2. Both contract and regular addresses can control and reject which token they send by registering a tokensToSend hook. (Rejection is done by reverting in the hook function)
3. Both contract and regular addresses can control and reject which token they receive by registering a tokensReceived hook. (Rejection is done by reverting in the hook function)
4. THe tokensReceived hook allows to send tokens to a contract and notify it in a single transaction, unlike ERC-20 which requires a double call (approve/transferFrom) to achieve this.
5. The holder can "authorize" and "revoke" operators which can send tokens on their behalf. These operators are intended to be verified contracts such as an exchange, a cheque processor or an automatic charging system.
6. Every token transaction contains data and operatorData bytes fields to be used freely to pass data from the holder and the operator, respectively.
7. It is backward compatible with wallets that do not contain the tokensReceived hook function by deploying a proxy contract implementing the tokensReceived hook for the wallet.