// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2

// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


// File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.2

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}


// File @openzeppelin/contracts/utils/Context.sol@v4.4.2

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.2

// OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)


/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}


// File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.4.2

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Burnable.sol)



/**
 * @dev Extension of {ERC20} that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
abstract contract ERC20Burnable is Context, ERC20 {
    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual {
        uint256 currentAllowance = allowance(account, _msgSender());
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        unchecked {
            _approve(account, _msgSender(), currentAllowance - amount);
        }
        _burn(account, amount);
    }
}


// File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1


interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


// File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.1


interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}


// File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.0.0-beta.0


interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


// File contracts/GenericSkidCoinV2.sol


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


// File contracts/tokens/SkidCoin2.sol


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
