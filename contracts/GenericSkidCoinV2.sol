// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin/token/ERC20/extensions/ERC20Burnable.sol";
import "uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";


/// @title Generic SkidCoin v2
/// @custom:url https://github.com/nxet/skidcoinz-factory
/// @notice If the name wasn't clear enough, this token was developed and deployed to the blockchain exclusively for testing purposes.
contract GenericSkidCoinV2 is ERC20Burnable {

  //
  // config
  //

  /// @notice Total amount of tokens to mint, in decimals
  uint256 public immutable initialMint;

  /// @dev Deployer address, used to protect {initialize}
  /// If _toDeployer > 0, this is also used to send the initial mint.
  address internal immutable _deployer;

  /// @notice Ratio of tokens minted to be given to deployer
  /// Expressing 0-100% with a uint8 (0…255 range) allows for a resolution of about 0.4%, i.e. (1 ≅ 0.39%) or (127 ≅ 49.80%) or (254 ≅ 99.60%)
  uint8 public immutable _toDeployer;

  /// @notice Tokens transfered to deployer during {initialize}, in decimals
  uint256 public toDeployer;

  /// @notice Liquidity pool token interface
  /// @dev optional, see NOTE in {initialize}
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
  /// @param toDeployer_ uint8 see {toDeployer}
  constructor(
    uint8 decimals_,
    string memory name_,
    string memory symbol_,
    uint256 initialMint_,
    uint8 toDeployer_
  )
    ERC20(name_, symbol_)
  {
    // store contract config
    _decimals = decimals_;
    initialMint = initialMint_;
    _toDeployer = toDeployer_;
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

    // calc and store tokens due to deployer, mint them
    toDeployer = initialMint * _toDeployer / 255;
    _mint(_deployer, toDeployer);
    // calc remaining amount of tokens to be minted sent to LP, mint them
    uint256 toLP_ = initialMint - toDeployer;
    _mint(address(this), toLP_);

    // initialize router
    // NOTE: not using Router02 because `brownie pm` has trouble installing, and I don't want any manual steps required to set up future development environments
    //    not that much of a problem anyway since we need a very basic interface
    IUniswapV2Router01 router_ = IUniswapV2Router01(routerAddress_);

    // [optional]
    // The following section can be removed, since {router_-addLiquidityETH} is enough to create and seed the LP.
    // These extra steps are performed exclusively to store a reference to the `pair` created.
    // Omitting this (and relative storage declarations) saves about 150k gas for {constructor} and another 5k for {initialize}
    // initialize factory
    IUniswapV2Factory factory_ = IUniswapV2Factory(router_.factory());
    // create pair and initialize LP token interface
    pair = IUniswapV2Pair(
      factory_.createPair(address(this), router_.WETH()) // returns pair address
    );
    // [/optional]

    // allow router to spend tokens stored in contract
    this.approve(routerAddress_, toLP_);
    // add liquidity to pool
    // returns (uint amountTokenFinal, uint amountWETHFinal, uint liquidity)
    router_.addLiquidityETH{value: msg.value}(
      address(this), // token address
      toLP_, // seed with toLP_ tokens
      toLP_, // and minimum toLP_ tokens
      msg.value, // and minimum msg.value WETH
      address(0), // LP tokens recipient - this is what burns/locks liquidity
      block.timestamp + 15 minutes // deadline
    );
    // remove allowance, just in case
    this.approve(routerAddress_, 0);

  }

}
