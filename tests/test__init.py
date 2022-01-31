import pytest
import brownie


def test__init(ContractFixture, Config, deployer):
    assert ContractFixture.decimals() == Config.decimals
    assert ContractFixture.name() == Config.name
    assert ContractFixture.symbol() == Config.symbol
    initialSupply = Config.initialSupply * 10 ** Config.decimals
    assert ContractFixture.totalSupply() == initialSupply
    assert ContractFixture.balanceOf(deployer) == initialSupply
