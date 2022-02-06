# skidcoinz-factory

Having some fun with the ERC20 standard.
LFG 🚀🚀🚀

### GenericSkidCoinV1
The bare-minimum, to test autodeploy of the WETH liquidity pool.  
Might work fine if you have a lot of liquidity to bootstrap the pool, **avoid** otherwise.  
> The first time this contract was deployed (on Harmony, with 1.00 $ONE initial liquidity), it took 45 minutes to see the pool completely destroyed, thanks to someone buying 83% of the supply (for 20 $ONE).  
> On the bright side I made some of the gas back and learned my lesson. It was weird to see this sink so fast though, since the only thing the whale achieved was losing most of their money.

### GenericSkidCoinV2
After the fail with V1 it became clear that some kind of limit had to be put in place. And that people will gladly throw cash at random coins, most likely without the understanding of why their move is killing it.  
This version includes a `maxOwnable` configuration parameter, which allows to cap the amount of tokens ownable by a single account.  
And fixes that very specific problem. There would be a lot more checks to make sure people "behave", but I think it's worth giving a shot to this simpler contract and see how it performs. Next iteration might implement some mechanism to force users to provide LP before being able to buy more tokens.

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
