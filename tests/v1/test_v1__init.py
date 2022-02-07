import pytest
import brownie
from math import floor


def calc_init_mints(initialMint, _toDeployer):
    toDeployer = floor(_toDeployer * initialMint / 255)
    toLP = initialMint - toDeployer
    return toDeployer, toLP


def test_v1__init(ContractFixtureV1, ConfigV1, deployer):
    _C = ContractFixtureV1
    assert _C.decimals() == ConfigV1.decimals
    assert _C.name() == ConfigV1.name
    assert _C.symbol() == ConfigV1.symbol
    assert _C.initialMint() == ConfigV1.initialMint
    assert _C._toDeployer() == ConfigV1._toDeployer


def test_v1_mints(ContractFixtureV1, ConfigV1, deployer):
    _C = ContractFixtureV1
    toDeployer, toLP = calc_init_mints(ConfigV1.initialMint, ConfigV1._toDeployer)
    # check initialize() minted and transfered to deployer
    assert _C.totalSupply() == ConfigV1.initialMint
    assert _C.balanceOf(deployer) == toDeployer
    assert _C.toDeployer() == toDeployer


def test_v1_liquidity(ContractFixtureV1, UniswapV2Pair, ConfigV1, deployer):
    _C = ContractFixtureV1
    _P = UniswapV2Pair(_C.pair())
    toDeployer, toLP = calc_init_mints(ConfigV1.initialMint, ConfigV1._toDeployer)
    # check initialize() minted and deployed to LP
    assert _C.totalSupply() == ConfigV1.initialMint
    assert _C.balanceOf(_P) == toLP
    # check that correct amount of LP tokens were burned
    assert _P.balanceOf(brownie.ZERO_ADDRESS) == _P.totalSupply()
