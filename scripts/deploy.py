from brownie import accounts
from brownie import SkidCoin1
from brownie import SkidCoin2

# deployed UniswapV2Router02 contracts
#   Harmony Mainnet Shard #0
ROUTERS = {
 'harmony-viperswap': '0xf012702a5f0e54015362cBCA26a26fc90AA832a3',
 'harmony-sushiswap': '0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506',
}

# available contracts
CONTRACTS = {
    'SkidCoin1': SkidCoin1,
    'SkidCoin2': SkidCoin2,
}


def main(contractName, routerName, initialETH, deployerId):
    '''
    run with:
        `brownie run deploy main ContractName routerName initETHwei deployerId`
    like:
        `brownie run deploy main SkidCoin2 harmony-sushiswap 1000000000000000000 myDeployerAccount`

    `routerName` can be one of those declared in the script, or a 0x1234 address
    for more info about `deployerId`, see `brownie accounts --help`
    '''
    initialETH = int(initialETH)
    Contract = CONTRACTS[contractName]
    try:
        routerAddress = ROUTERS[routerName]
    except KeyError:
        routerAddress = routerName
    deployer = accounts.load(deployerId)
    # assert that deployer has enough funds to deploy and seed LP
    #   TODO unable to estimate gas on undeployed contract methods
    #   aggressively checking for a whole ETH for deploy (depending on gas price, far less should be required)
    assert deployer.balance() > (1e18 + initialETH), \
        'Deployer doesn\'t have enough funds'
    # deploy contract
    contract = Contract.deploy({'from': deployer})
    contract.initialize(
        routerAddress,
        {'from': deployer, 'value': initialETH}
    )
