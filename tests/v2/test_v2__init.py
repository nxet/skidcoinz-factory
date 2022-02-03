import pytest
import brownie
from math import floor


def calc_supply_ratio(initialMint, ratio):
    return floor(ratio * initialMint / 255)

def calc_eth_price(tokens, weis, tokenDecimals):
    return floor(weis * (10**tokenDecimals) / tokens)


def test_v2__init(ContractFixtureV2, ConfigV2):
    _C = ContractFixtureV2
    assert _C.initialized() == True
    assert _C.decimals() == ConfigV2.decimals
    assert _C.name() == ConfigV2.name
    assert _C.symbol() == ConfigV2.symbol
    # toDeployer and toLP
    toDeployer = calc_supply_ratio(ConfigV2.initialMint, ConfigV2._toDeployer)
    toLP = ConfigV2.initialMint - toDeployer
    assert _C._toDeployer() == ConfigV2._toDeployer
    assert _C.toDeployer() == toDeployer
    assert _C.toLP() == toLP
    # maxOwnable
    assert _C._maxOwnable() == ConfigV2._maxOwnable
    assert _C.maxOwnable() == calc_supply_ratio(ConfigV2.initialMint, ConfigV2._maxOwnable)
    # init params
    assert _C.initialMint() == ConfigV2.initialMint
    assert _C.initialETH() == ConfigV2.initialETH
    assert _C.initialPrice() == calc_eth_price(toLP, ConfigV2.initialETH, ConfigV2.decimals)


def test_v2_init_mints(ContractFixtureV2, UniswapV2Pair, ConfigV2, deployer):
    _C = ContractFixtureV2
    _P = UniswapV2Pair(_C.pair())
    toDeployer = calc_supply_ratio(ConfigV2.initialMint, ConfigV2._toDeployer)
    toLP = ConfigV2.initialMint - toDeployer
    # check initialize() minted all tokens
    assert _C.totalSupply() == ConfigV2.initialMint
    #   and sent both to deployer
    assert _C.toDeployer() == toDeployer
    assert _C.balanceOf(deployer) == toDeployer
    #   and to LP
    assert _C.toLP() == toLP
    assert _C.balanceOf(_P) == toLP
    # check that 100% of LP tokens were burned
    assert _P.balanceOf(brownie.ZERO_ADDRESS) == _P.totalSupply()
