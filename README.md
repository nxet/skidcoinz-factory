# skidcoinz-factory

Having some fun with the ERC20 standard.
LFG 🚀🚀🚀

---

### dev - getting started

> NB: The test suite requires the development network to provide a deployed UniswapV2Router contract, in the example below it forks Harmony Mainnet since it's the default used in tests.  
> See `$ brownie networks --help` and `./tests/conftest.py` to configure different networks

```sh
# create Python virtual environment and install Brownie
mkvirtualenv skidcoinz
pip install eth-brownie
# clone repo and enter directory
git clone https://github.com/nxet/skidcoinz-factory
cd skidcoinz-factory
# [optional, downloaded on first compile] install dependencies
brownie pm install OpenZeppelin/openzeppelin-contracts@4.3.2
brownie pm install Uniswap/v2-core@1.0.1
brownie pm install Uniswap/v2-periphery@1.0.0-beta.0
# [optional, ymmv based on which router you're going to use]
# set up Harmony Mainnet Fork development network
brownie networks add Development harmony-mainnet-fork cmd='ganache-cli' name='Harmony Mainnet Fork' host=http://127.0.0.1 port=8545 fork=https://a.api.s0.t.hmny.io/ mnemonic=brownie
# run tests to check everything installed fine
brownie test -v -i -C -G
```

---

##### Disclaimer
If the name wasn't clear enough, the tokens/contract abstractions contained in this repository were developed and deployed to the blockchain exclusively for testing purposes.  

##### License
This project is licensed under the [MIT License](LICENSE).

##### Support this project
To support future development please consider donating to:  
**0x8Fb5d411F03167B7c850FB850d345b3f36c752BD**  
*[see on blockscan.com](https://blockscan.com/address/0x8Fb5d411F03167B7c850FB850d345b3f36c752BD) ($ETH, $MATIC, $FTM, $BNB, etc..)*  
*[see on explorer.harmony.one](https://explorer.harmony.one/address/0x8Fb5d411F03167B7c850FB850d345b3f36c752BD) ($ONE)*
