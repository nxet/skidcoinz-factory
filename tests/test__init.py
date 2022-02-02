import pytest
import brownie
from math import floor


def calc_init_mints(initialMint, _toDeployer):
    toDeployer = floor(_toDeployer * initialMint / 255)
    toLP = initialMint - toDeployer
    return toDeployer, toLP


def test__init(ContractFixture, Config, deployer):
    _C = ContractFixture
    assert _C.decimals() == Config.decimals
    assert _C.name() == Config.name
    assert _C.symbol() == Config.symbol
    assert _C.initialMint() == Config.initialMint
    assert _C._toDeployer() == Config._toDeployer


def test_mints(ContractFixture, Config, deployer):
    _C = ContractFixture
    toDeployer, toLP = calc_init_mints(Config.initialMint, Config._toDeployer)
    # check initialize() minted and transfered to deployer
    assert _C.totalSupply() == Config.initialMint
    assert _C.balanceOf(deployer) == toDeployer
    assert _C.toDeployer() == toDeployer


def test_liquidity(ContractFixture, UniswapV2Pair, Config, deployer):
    _C = ContractFixture
    _P = UniswapV2Pair(_C.pair())
    toDeployer, toLP = calc_init_mints(Config.initialMint, Config._toDeployer)
    # check initialize() minted and deployed to LP
    assert _C.totalSupply() == Config.initialMint
    assert _C.balanceOf(_P) == toLP
    # check that correct amount of LP tokens were burned
    assert _P.balanceOf(brownie.ZERO_ADDRESS) == _P.totalSupply()
