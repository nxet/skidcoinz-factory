from brownie import accounts
from brownie import SkidCoin


# routers
# NB: these routers are tested on Harmony Mainnet only so far
ROUTER_ViperSwap = '0xf012702a5f0e54015362cBCA26a26fc90AA832a3'
ROUTER_SushiSwap = '0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506'

# config
DECIMALS = 9
NAME = 'Le SkidCoin'
SYMBOL = 'HIT'
INITIAL_MINT = 1e8 * 10**DECIMALS
INITIAL_ETH = 1e18
TO_DEPLOYER = 10 # of 255, or ~3.92%
ROUTER_ADDRESS = ROUTER_SushiSwap


def main(deployerId):
    '''
    for more info about `deployerId`, see `brownie accounts --help`
    '''
    deployer = accounts.load(deployerId)
    contract = SkidCoin.deploy(
        DECIMALS,
        NAME,
        SYMBOL,
        INITIAL_MINT,
        TO_DEPLOYER,
        {'from': deployer}
    )
    contract.initialize(
        ROUTER_ADDRESS,
        {
            'from': deployer,
            'value': INITIAL_ETH,
        }
    )
