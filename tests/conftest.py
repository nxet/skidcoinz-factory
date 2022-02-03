import pytest
import brownie


#
# utils
#

@pytest.fixture(scope='module')
def deployer(accounts):
    return accounts[-1]

@pytest.fixture(scope='module')
def UniswapV2Pair(pm):
    def fn(address):
        uniPair = pm('Uniswap/v2-core@1.0.1').UniswapV2Pair
        return uniPair.at(address)
    return fn


#
# v1
#

from v1.conftest import Config as _ConfigV1
from v1.conftest import deploy_fixture as deploy_fixture_v1

@pytest.fixture(scope='module')
def ConfigV1():
    return _ConfigV1

@pytest.fixture(scope='module')
def ContractFixtureV1(GenericSkidCoinV1, deployer):
    return deploy_fixture_v1(GenericSkidCoinV1, deployer)


#
# v2
#

from v2.conftest import Config as _ConfigV2
from v2.conftest import deploy_fixture as deploy_fixture_v2

@pytest.fixture(scope='module')
def ConfigV2():
    return _ConfigV2

@pytest.fixture(scope='module')
def ContractFixtureV2(GenericSkidCoinV2, deployer):
    return deploy_fixture_v2(GenericSkidCoinV2, deployer)


#
# apply fn_isolation to all future tests
#

@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass
