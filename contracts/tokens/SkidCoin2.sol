// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../GenericSkidCoinV2.sol";


/// @title Le SkidCoin v2
contract SkidCoin2 is GenericSkidCoinV2 {

  /// @dev for transparency and readability, the full config is hardcoded here
  constructor()
    GenericSkidCoinV2(
      // decimals_, name_, symbol_
      9, 'Le SkidCoin', 'HIT',
      // initialMint_
      10**6 * 10**9, // 1,000,000 tokens * decimals
      // toDeployer_
      1, // of 255, or ~0.39% of supply, ~3900 tokens
      // maxOwnable_
      4 // of 255, or ~1.56% of supply, ~15600 tokens
    )
  {
    // nothing to do here
  }

}
