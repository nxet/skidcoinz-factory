// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../GenericSkidCoinV1.sol";


/// @title Le SkidCoin
contract SkidCoin1 is GenericSkidCoinV1 {

  /// @dev for transparency and readability, the full config is hardcoded here
  constructor()
    GenericSkidCoinV1(
      // decimals_, name_, symbol_
      9, 'Le SkidCoin', 'HIT',
      // initialMint_
      10**6 * 10**9, // 1,000,000 * decimals
      // toDeployer_
      1 // of 255, or ~0.39%
    )
  {
    // nothing to do here
  }

}
