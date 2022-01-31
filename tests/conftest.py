import pytest
import brownie


@pytest.fixture(scope='module')
def deployer(accounts):
    return accounts[-1]


@pytest.fixture(scope='module')
def Config():
    class cfg:
        decimals = 18
        name = 'Le SkidCoin'
        symbol = 'HIT'
        initialSupply = 1e6
    return cfg


@pytest.fixture(scope='module')
def ContractFixture(SkidCoin, Config, deployer):
    contract = SkidCoin.deploy(
        Config.decimals,
        Config.name,
        Config.symbol,
        Config.initialSupply,
        {'from': deployer}
    )
    return contract


#
# apply fn_isolation to all future tests
#

@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass
