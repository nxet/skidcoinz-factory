// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";


/// @title Generic SkidCoin v2
/// @custom:url https://github.com/nxet/skidcoinz-factory
/// @notice If the name wasn't clear enough, this token was developed and deployed to the blockchain exclusively for testing purposes.
contract GenericSkidCoinV2 is ERC20Burnable {

  //
  // storage: initialMint
  //

  /// @notice Total amount of tokens to mint, in decimals
  uint256 public immutable initialMint;

  /// @notice Amount of ETH provided at deploy (in wei), used to seed the liquidity pool
  /// @dev Can't be immutable since it's set after {constructor}, irrelevant since this is purely cosmetic
  uint256 public initialETH;

  /// @notice Price at deploy (initialETH / initialMint), in wei per token
  /// @dev Can't be immutable since it's set after {constructor}, irrelevant since this is purely cosmetic
  uint256 public initialPrice;

  /// @dev Deployer address, used to protect {initialize}
  /// If _toDeployer > 0, this is also used to send the initial mint.
  address internal immutable _deployer;

  /// @notice Ratio of tokens minted to be given to deployer
  /// Expressing 0-100% with a uint8 (0…255 range) allows for a resolution of about 0.4%, i.e. (1 ≅ 0.39%) or (127 ≅ 49.80%) or (254 ≅ 99.60%)
  /// NB: this must be lower or equal to `_maxOwnable`, {constructor} will revert otherwise
  uint8 public immutable _toDeployer;

  /// @notice Tokens transfered to deployer during {initialize}, in decimals
  /// @dev Filled in during {constructor} based on {initialMint}
  uint256 public immutable toDeployer;

  /// @notice Tokens transfered to liquidity pool during {initialize}, in decimals
  /// @dev Filled in during {constructor} based on {initialMint}
  uint256 public immutable toLP;

  //
  // storage: maxOwnable
  //

  /// @notice Maximum amount of tokens ownable per account, relative to total supply (`initialMint`).
  /// @dev Just like {_toDeployer}, uses uint8 to express 0-100% in a (0…255) range, i.e. (1 ≅ 0.39%) or (127 ≅ 49.80%) or (254 ≅ 99.60%)
  /// NB: this setting heavily impairs liquidity pools different than the one created at initialization, see {_beforeTokenTransfer}.
  uint8 public immutable _maxOwnable;

  /// @notice Max amount of tokens ownable by a single account, in decimals
  /// @dev Filled in during {constructor} based on {initialMint}
  uint256 public immutable maxOwnable;

  //
  // storage: misc
  //

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

  /// @dev Store basic configuration, calc `toDeployer` and `maxOwnable` ratios
  /// @param decimals_ uint256 token decimals, see {decimals}
  /// @param name_ string name of the token, i.e. 'Le SkidCoin'
  /// @param symbol_ string symbol of the token, i.e. 'HIT' for ticker '$HIT'
  /// @param initialMint_ uint256 token decimals to mint, see {initialMint}
  /// @param toDeployer_ uint8 see {_toDeployer}
  /// @param maxOwnable_ uint8 see {_maxOwnable}
  constructor(
    uint8 decimals_,
    string memory name_,
    string memory symbol_,
    uint256 initialMint_,
    uint8 toDeployer_,
    uint8 maxOwnable_
  )
    ERC20(name_, symbol_)
  {
    // check configuration is ok
    require(
      toDeployer_ <= maxOwnable_,
      "Deployer would receive more than maxOwnable"
    );
    // store base config
    _deployer = msg.sender;
    _decimals = decimals_;
    initialMint = initialMint_;
    // store toDeployer ratio and calc token decimals
    _toDeployer = toDeployer_;
    toDeployer = initialMint * toDeployer_ / 255;
    // calc remaining amount of tokens to be minted and sent to LP
    toLP = initialMint_ - toDeployer;
    // store maxOwnable ratio and calc token decimals
    _maxOwnable = maxOwnable_;
    maxOwnable = initialMint * maxOwnable_ / 255;
  }

  /// @notice Mint `initialMint` tokens and use them to seed the WETH liquidity pool, sending all LP tokens to burn address
  /// @dev
  ///     - check if call is authorized
  ///     - mint {initialMint} to contract (and deployer, if {toDeployer} > 0)
  ///     - initialize UniswapV2 router and factory, create WETH pair
  ///     - allow router to spend contract's tokens
  ///     - provide {toLP} tokens to liquidity pool, lock liquidity sending the LP tokens to burn address
  ///     - remove allowance, store initialization parameters
  ///     - lock contract
  /// @param routerAddress_ address address of the deployed UniswapV2Router02 contract to use as router to initialize the liquidity pool
  function initialize(address routerAddress_) public payable {
    // check contract is uninitialized
    require(initialized == false, "Already initialized");
    // check caller is authorized
    require(msg.sender == _deployer, "Unauthorized");
    // check user sent some ETH
    require(msg.value > 0, "Must provide ETH to seed LP");

    // initialize router and factory
    // NOTE: not using Router02 because `brownie pm` has trouble installing, and I don't want any manual steps required to set up future development environments
    //    not that much of a problem anyway since we need a very basic interface
    IUniswapV2Router01 router_ = IUniswapV2Router01(routerAddress_);
    IUniswapV2Factory factory_ = IUniswapV2Factory(router_.factory());
    // create pair and initialize LP token interface
    pair = IUniswapV2Pair(
      factory_.createPair(address(this), router_.WETH()) // returns pair address
    );

    // check if part of the inital mint should be sent to deployer
    if (_toDeployer > 0) {
      // mint to deployer, amount already calc in {constructor}
      _mint(_deployer, toDeployer);
    }

    // mint the rest of supply to contract, again amount calc in {constructor}
    _mint(address(this), toLP);
    // allow router to spend tokens stored in contract
    this.approve(routerAddress_, toLP);
    // add liquidity to pool
    // returns (uint amountTokenFinal, uint amountWETHFinal, uint liquidity)
    router_.addLiquidityETH{value: msg.value}(
      address(this), // token address
      toLP, // seed with toLP tokens
      toLP, // and minimum toLP tokens
      msg.value, // and minimum msg.value WETH
      address(0), // LP tokens recipient - this is what burns/locks liquidity
      block.timestamp + 15 minutes // deadline
    );
    // remove allowance, just in case
    this.approve(routerAddress_, 0);

    // store initial ETH and price per token (both in wei)
    initialETH = msg.value;
    initialPrice = msg.value * (10 ** decimals()) / toLP;

    // update init flag (locking contract)
    initialized = true;

  }

  /// @dev Check recipient's balance is below `maxOwnable`, then super.
  /// No limits only for transfers to the contract, burn address or official LP, which means:
  ///   - liquidity pools other than the official will also be capped
  ///   - users can deposit without limits to official LP, but withdraws will revert with 'UniswapV2: TRANSFER_FAILED' if the amount of tokens owned *after* removing their liquidity goes above `maxOwnable`.
  ///   - current implementation does NOT allow to also limit the amount of LP tokens owned by a single user
  function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal override(ERC20) {
    // check if maxOwnable must be enforced
    if (
      // maxOwnable is enabled
      _maxOwnable > 0
      // and not the burn address receiving
      && recipient != address(0)
      // and not the contract receiving - because {initialMint}
      && recipient != address(this)
      // and not the official LP receiving
      && recipient != address(pair)
    ) {
      // require recipient wont exceed maxOwnable
      require(
        (balanceOf(recipient) + amount) <= maxOwnable,
        "Recipient balance would exceed maxOwnable"
      );
    }
    super._beforeTokenTransfer(sender, recipient, amount);
  }


}
