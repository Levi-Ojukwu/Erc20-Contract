// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract SaveERC20AndEther {

    // Storage

    // Ether savings
    mapping(address => uint256) public etherBalances;

    // ERC20 savings
    mapping(address => mapping(address => uint256)) public erc20Balances;

    // Events

    event EtherDeposited(address indexed user, uint256 amount);
    event EtherWithdrawn(address indexed user, uint256 amount);

    event ERC20Deposited(address indexed user, address indexed token, uint256 amount);
    event ERC20Withdrawn(address indexed user, address indexed token, uint256 amount);

    // Ether Functions

    function depositEther() external payable {
        require(msg.value > 0, "Zero value");

        etherBalances[msg.sender] += msg.value;

        emit EtherDeposited(msg.sender, msg.value);
    }

    function withdrawEther(uint256 amount) external {
        require(etherBalances[msg.sender] >= amount, "Insufficient balance");

        etherBalances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit EtherWithdrawn(msg.sender, amount);
    }

    //  ERC20 Functions
    function depositERC20(address token, uint256 amount) external {
        require(amount > 0, "Zero amount");

        // Pull tokens from user
        bool success = IERC20(token).transferFrom(msg.sender, address(this), amount);
        require(success, "Transfer failed");

        erc20Balances[msg.sender][token] += amount;

        emit ERC20Deposited(msg.sender, token, amount);
    }

    function withdrawERC20(address token, uint256 amount) external {
        require(erc20Balances[msg.sender][token] >= amount, "Insufficient balance");

        erc20Balances[msg.sender][token] -= amount;

        bool success = IERC20(token).transfer(msg.sender, amount);
        require(success, "Transfer failed");

        emit ERC20Withdrawn(msg.sender, token, amount);
    }

// View Functions
    function getContractEtherBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getUserEtherBalance(address user) external view returns (uint256) {
        return etherBalances[user];
    }

    function getUserERC20Balance(address user, address token) external view returns (uint256) {
        return erc20Balances[user][token];
    }
}
