// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Reentrance {
    using SafeMath for uint256;
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] = balances[msg.sender] + msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(
        address _to,
        uint _amount,
        address erc20
    ) public payable {
        require(balances[msg.sender] > _amount);
        require(address(this).balance > _amount);
        _to.call{value: _amount}("");
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        if (IERC20(erc20).balanceOf(address(this)) > 0) {
            IERC20(erc20).transfer(
                erc20,
                IERC20(erc20).balanceOf(address(this))
            );
        }
        console.log(
            "[RE withdraw]balance[%s]:%s",
            msg.sender,
            balances[msg.sender]
        );
    }

    receive() external payable {}
}
