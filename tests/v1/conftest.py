
# NB: these routers are tested on Harmony Mainnet only so far
ROUTER_ViperSwap = '0xf012702a5f0e54015362cBCA26a26fc90AA832a3'
ROUTER_SushiSwap = '0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506'


class Config:
    decimals = 9
    name = 'Le SkidCoin'
    symbol = 'HIT'
    initialMint = 1e6 * 10**decimals
    initialETH = 1e18
    _toDeployer = 1
    routerAddress = ROUTER_SushiSwap


def deploy_fixture(Contract, deployer):
    contract = Contract.deploy(
        Config.decimals,
        Config.name,
        Config.symbol,
        Config.initialMint,
        Config._toDeployer,
        {'from': deployer}
    )
    contract.initialize(
        Config.routerAddress,
        {
            'from': deployer,
            'value': Config.initialETH
        }
    )
    return contract
