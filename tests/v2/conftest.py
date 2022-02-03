from v1.conftest import Config as ConfigV1


class Config(ConfigV1):
    _maxOwnable = 5


def deploy_fixture(Contract, deployer):
    contract = Contract.deploy(
        Config.decimals,
        Config.name,
        Config.symbol,
        Config.initialMint,
        Config._toDeployer,
        Config._maxOwnable,
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
