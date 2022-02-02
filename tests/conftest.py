import pytest
import brownie

# NB: these routers are tested on Harmony Mainnet only so far
ROUTER_ViperSwap = '0xf012702a5f0e54015362cBCA26a26fc90AA832a3'
ROUTER_SushiSwap = '0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506'


@pytest.fixture(scope='module')
def deployer(accounts):
    return accounts[-1]


@pytest.fixture(scope='module')
def Config():
    class cfg:
        decimals = 18
        name = 'Le SkidCoin'
        symbol = 'HIT'
        initialMint = 1e6
        initialETH = 1e18
        _toDeployer = 1 # of 255
        routerAddress = ROUTER_SushiSwap
    return cfg


@pytest.fixture(scope='module')
def ContractFixture(SkidCoin, Config, deployer):
    contract = SkidCoin.deploy(
        Config.decimals,
        Config.name,
        Config.symbol,
        Config.initialMint,
        Config._toDeployer,
        {'from': deployer,}
    )
    contract.initialize(
        Config.routerAddress,
        {
            'from': deployer,
            'value': Config.initialETH
        }
    )
    return contract


@pytest.fixture(scope='module')
def UniswapV2Pair(pm):
    def fn(address):
        uniPair = pm('Uniswap/v2-core@1.0.1').UniswapV2Pair
        return uniPair.at(address)
    return fn


#
# apply fn_isolation to all future tests
#

@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass
