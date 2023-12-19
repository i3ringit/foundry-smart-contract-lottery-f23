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
import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/**
 * @title A sample Raffle Contract
 * @author Marcos del Cristo
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2
 */
contract Raffle {
    // errors
    error Raffle__NotEnoughEthSent();
    error Raffle__TransferFailed();
    error Raffle_RaffleNotOpen();

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

    // Type declarations
    enum RaffleState {
        OPEN,
        CALCULATING
    }

    // State variables
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    /**
     * @dev This is the amount of ETH required to enter the raffle
     */
    uint256 private immutable i_entranceFee;
    /**
     * @dev Duration of the lottery in seconds
     */
    uint256 private immutable i_interval;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    uint256 private s_lastTimeStamp;

    /**
     * @dev This is an array of all the participants in the raffle
     */
    address payable[] private s_players;
    address private s_recentWinner;
    RaffleState private s_raffleState;

    // Events
    event EnteredRaffle(address indexed player);

    // Modifiers

    // Functions
    /**
     *
     * @param entranceFee The amount of ETH required to enter the raffle
     */
    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinatorV2,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;

        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH to enter raffle");
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        if (s_raffleState != RaffleState.OPEN) {
            revert();
        }
        s_players.push(payable(msg.sender));
        // 1. Makes migration easier
        // 2. Makes it easier to read
        emit EnteredRaffle(msg.sender);
    }

    // 1. Get a random number
    // 2. Use the random number to pick a player
    // 3. Be automatically called
    function pickWinner() public {
        // Check to see if enough time has passed
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert Raffle_RaffleNotOpen();
        }
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, // Gas Lane
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        // s_players = 10
        // rng = 12
        // 12 % 10 = 2 <- winner
        // 1578430926775645 % 10 = 5
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        s_recentWinner = winner;
        (bool success, ) = winner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle__TransferFailed();
        }
    }

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
