from brownie import accounts
from brownie import SkidCoin


# config
DECIMALS = 9
NAME = 'Le SkidCoin'
SYMBOL = 'HIT'
INITIAL_MINT = 1e8


def main(deployerId):
    '''
    for more info about `deployerId`, see `brownie accounts --help`
    '''
    deployer = accounts.load(deployerId)
    SkidCoin.deploy(
        DECIMALS,
        NAME,
        SYMBOL,
        INITIAL_MINT,
        {'from': deployer}
    )
