// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin/token/ERC20/extensions/ERC20Burnable.sol";
import "uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";


/// @title SkidCoin
/// @custom:url https://github.com/nxet/skidcoinz-factory
/// @notice If the name wasn't clear enough, this token was developed and deployed to the blockchain exclusively for testing purposes.
contract SkidCoin is ERC20Burnable {

  //
  // config
  //

  /// @notice Total amount of tokens to mint, in decimals
  uint256 public immutable initialMint;

  /// @dev deployer address, used to protect {initialize}
  address internal immutable _deployer;

  /// @notice Liquidity pool token interface
  IUniswapV2Pair public pair;

  /// @notice True if the contract was properly initialized and the LP seeded, meaning all admin functions are locked and no more tokens can be minted. See also {initialize}
  bool public initialized;

  //
  // decimals
  //

  /// @dev Allows to configure decimals at deploy rather than hardcoding
  uint8 internal immutable _decimals;

  function decimals() public view override returns(uint8) {
    return _decimals;
  }


  //
  // main
  //

  /// @dev Store basic configuration
  /// @param decimals_ uint256 token decimals, see {decimals}
  /// @param name_ string name of the token, i.e. 'Le SkidCoin'
  /// @param symbol_ string symbol of the token, i.e. 'HIT' for ticker '$HIT'
  /// @param initialMint_ uint256 token decimals to mint, see {initialMint}
  constructor(
    uint8 decimals_,
    string memory name_,
    string memory symbol_,
    uint256 initialMint_
  )
    ERC20(name_, symbol_)
  {
    // store contract config
    _decimals = decimals_;
    initialMint = initialMint_;
    _deployer = msg.sender;
  }

  /// @notice Mint `initialMint` tokens and use them to seed the WETH liquidity pool, sending all LP tokens to burn address
  /// @param routerAddress_ address address of the deployed UniswapV2Router02 contract to use as router to initialize the liquidity pool
  function initialize(address routerAddress_) public payable {
    // check contract is uninitialized, update flag
    require(initialized == false, "Already initialized");
    initialized = true;
    // check caller is authorized
    require(msg.sender == _deployer, "Unauthorized");
    // check user sent some ETH
    require(msg.value > 0, "Must provide ETH to seed LP");
    // initialize router and factory contracts
    // NOTE: not using Router02 because `brownie pm` has trouble installing, and I don't want any manual steps required to set up future development environments
    //    not that much of a problem anyway since we need a very basic interface
    IUniswapV2Router01 router_ = IUniswapV2Router01(routerAddress_);
    IUniswapV2Factory factory_ = IUniswapV2Factory(router_.factory());
    // create pair and initialize LP token interface
    pair = IUniswapV2Pair(
      factory_.createPair(address(this), router_.WETH()) // returns pair address
    );
    // mint initialMint tokens to ourself, and allow router to spend them
    _mint(address(this), initialMint);
    this.approve(routerAddress_, initialMint);
    // add liquidity to pool
    // returns (uint amountTokenFinal, uint amountWETHFinal, uint liquidity)
    router_.addLiquidityETH{value: msg.value}(
      address(this), // token address
      initialMint, // seed with initialMint tokens
      initialMint, // and minimum initialMint tokens
      msg.value, // and minimum msg.value WETH
      address(0), // LP tokens recipient - this is what burns/locks liquidity
      block.timestamp + 15 minutes // deadline
    );
    // remove allowance, just in case
    this.approve(routerAddress_, 0);
  }

}
