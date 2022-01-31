// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin/token/ERC20/extensions/ERC20Burnable.sol";


contract SkidCoin is ERC20Burnable {

  uint8 internal immutable _decimals;

  function decimals() public view override returns(uint8) {
    return _decimals;
  }

  /// @param decimals_ uint256 token decimals, see {decimals}
  /// @param name_ string name of the token, i.e. 'Le SkidCoin'
  /// @param symbol_ string symbol of the token, i.e. 'HIT' for ticker '$HIT'
  /// @param initialSupply_ uint256 tokens to mint (without decimals)
  constructor(
    uint8 decimals_,
    string memory name_,
    string memory symbol_,
    uint256 initialSupply_
  )
    ERC20(name_, symbol_) {
      // store decimals
      _decimals = decimals_;
      // mint initialSupply_ to deployer
      _mint(
        msg.sender,
        initialSupply_ * 10**decimals_
      );
  }

}
