import pytest
import brownie


def test__init(ContractFixture, Config, deployer):
    assert ContractFixture.decimals() == Config.decimals
    assert ContractFixture.name() == Config.name
    assert ContractFixture.symbol() == Config.symbol
    assert ContractFixture.initialMint() == Config.initialMint


def test_liquidity(ContractFixture, UniswapV2Pair, Config, deployer):
    _C = ContractFixture
    _P = UniswapV2Pair(_C.pair())
    # check initialize() minted and deployed all tokens to LP
    assert _C.totalSupply() == Config.initialMint
    assert _C.balanceOf(_P) == Config.initialMint
    # check that correct amount of LP tokens were burned
    assert _P.balanceOf(brownie.ZERO_ADDRESS) == _P.totalSupply()
