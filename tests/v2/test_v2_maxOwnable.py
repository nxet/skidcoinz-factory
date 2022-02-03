import pytest
import brownie


def test_v2_maxOwnable(ContractFixtureV2, accounts):
    _C = ContractFixtureV2
    _P = _C.pair() # used as bank to test transfers
    acct0, acct1 = accounts[:2]
    maxOwnable = _C.maxOwnable()
    aboveMO = maxOwnable + 1

    # transfer up to maxOwnable to acct0
    _C.transfer(acct0, maxOwnable, {'from': _P})
    # fail transfer above maxOwnable to acct1
    with brownie.reverts('Recipient balance would exceed maxOwnable'):
        _C.transfer(acct1, aboveMO, {'from': _P})
    # transfer some to acct1, then fail transfering enough to go past limit
    _C.transfer(acct1, 1, {'from': _P})
    with brownie.reverts('Recipient balance would exceed maxOwnable'):
        _C.transfer(acct1, aboveMO, {'from': _P})

    # transfer without limits to contract
    # not really necessary since {initialize} worked (received most supply)
    #   unless deployed with crazy params like maxOwnable=99% and toDeployer=75%
    _C.transfer(_C, aboveMO, {'from': _P})
    # transfer without limits to LP - not necessary just like contract
    _C.transfer(_P, aboveMO, {'from': _C})

    # burn within limits
    _C.burn(1, {'from': acct0})
    # burn entire balance
    _C.burn(_C.balanceOf(acct0), {'from': acct0})
    # burn again `aboveMO` to make sure we're past the limit for 0x0
    _C.burn(aboveMO, {'from': _P})
