// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.34;

contract TokenContract {
    address public owner;

    struct Receivers {
        string name;
        uint256 tokens;
    }

    mapping(address => Receivers) public users;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
        users[owner].tokens = 100;
    }

    function double(uint _value) public pure returns (uint) {
        return _value * 2;
    }

    function register(string memory _name) public {
        users[msg.sender].name = _name;
    }

    function giveToken(address _receiver, uint256 _amount) public onlyOwner {
        require(users[owner].tokens >= _amount);
        users[owner].tokens -= _amount;
        users[_receiver].tokens += _amount;
    }

    function buyTokens(uint256 _amount) public payable {
        require(_amount > 0, "Cantidad invalida");

        require(
            users[owner].tokens >= _amount,
            "El propietario no tiene suficientes tokens"
        );

        require(msg.value >= _amount * 5 ether, "Ether insuficiente");

        require(
            msg.value == _amount * 5 ether,
            "Debes enviar el importe exacto"
        );

        users[owner].tokens -= _amount;
        users[msg.sender].tokens += _amount;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance / 1 ether;
    }
}
