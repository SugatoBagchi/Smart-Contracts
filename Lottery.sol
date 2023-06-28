// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Lottery {

    address payable[] public players;
    address payable public admin;

    constructor() {
        admin = payable(msg.sender);
    }

    receive() external payable {
        require(msg.sender != admin, "Admins cannot participate");
        require(msg.value == 1 ether, "Must be exactly 1 ether");

        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function random() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }



    function pickWinner() public {
        require( admin == msg.sender, "You are not the Owner." );
        require ( players.length >= 3, "Not enough players participating in the lottery." );

        address payable winner;
        winner = players[random() % players.length];

        winner.transfer(getBalance());

        players = new address payable[](0);
    }

}