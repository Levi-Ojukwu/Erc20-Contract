// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract SaveERC20AndEther {

    mapping(address => uint256) public etherBalances;
    mapping(address => mapping(address => uint256)) public erc20Balances;
    // user => token => balance

    event Deposit(address indexed user, uint256 amount, string assetType, address token);
    event Withdraw(address indexed user, uint256 amount, string assetType, address token);

   /**
    * 
    * Ether functions 
    */

    function depositEther() external payable {
        require(msg.value > 0, "Zero value");

        etherBalances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value, "Ether", address(0));
    }

    function withdrawEther(uint256 amount) external {
        require(etherBalances[msg.sender] >= amount, "Insufficient balance");

        etherBalances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdraw(msg.sender, amount, "Ether", address(0));
    }

   /**
    * 
    * ERC20 functions 
    */

    function depositERC20(address token, uint256 amount) external {
        require(amount > 0, "Zero amount");

        IERC20(token).transferFrom(msg.sender, address(this), amount);

        erc20Balances[msg.sender][token] += amount;

        emit Deposit(msg.sender, amount, "ERC20", token);
    }

    function withdrawERC20(address token, uint256 amount) external {
        require(erc20Balances[msg.sender][token] >= amount, "Insufficient balance");

        erc20Balances[msg.sender][token] -= amount;

        IERC20(token).transfer(msg.sender, amount);

        emit Withdraw(msg.sender, amount, "ERC20", token);
    }
}
