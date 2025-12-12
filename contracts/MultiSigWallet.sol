// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    address[] public owners;
    uint256 public required;

    struct Tx {
        address to;
        uint256 value;
        bool executed;
        uint256 approvals;
    }

    Tx[] public transactions;
    mapping(uint256 => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        bool ok = false;
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == msg.sender) ok = true;
        }
        require(ok, "Not an owner");
        _;
    }

    constructor(address[] memory _owners, uint256 _required) {
        owners = _owners;
        required = _required;
    }

    function submit(address to, uint256 value) external onlyOwner {
        transactions.push(Tx(to, value, false, 0));
    }

    function approveTx(uint256 index) external onlyOwner {
        require(!approved[index][msg.sender], "Already approved");
        Tx storage txData = transactions[index];
        txData.approvals++;
        approved[index][msg.sender] = true;
    }

    function executeTx(uint256 index) external onlyOwner {
        Tx storage txData = transactions[index];
        require(!txData.executed, "Already executed");
        require(txData.approvals >= required, "Not enough approvals");

        txData.executed = true;
        payable(txData.to).transfer(txData.value);
    }

    receive() external payable {}
}
