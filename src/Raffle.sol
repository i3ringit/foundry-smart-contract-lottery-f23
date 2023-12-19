// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT

// version
pragma solidity ^0.8.18;

// imports

/**
 * @title A sample Raffle Contract
 * @author Marcos del Cristo
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2
 */
contract Raffle {
    // errors
    error Raffle__NotEnoughEthSent();

    // interfaces, libraries, contracts
    // Type declarations
    // example of a type declaration:
    // struct Person {
    //     string name;
    //     uint256 age;
    // }

    // example of a state variable:
    // Person[] public people;

    // example of an event:
    // event PersonCreated(string name, uint256 age);

    // example of a modifier:
    // modifier onlyOwner() {
    //     require(msg.sender == owner);
    //     _;
    // }

    // example of a function:
    // function createPerson(string memory name, uint256 age) public onlyOwner {
    //     people.push(Person(name, age));
    //     emit PersonCreated(name, age);
    // }
    uint256 private immutable i_entranceFee;

    // State variables
    // Events
    // Modifiers
    // Functions

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH to enter raffle");
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
    }

    function pickWinner() public {}

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
