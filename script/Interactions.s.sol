// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        (, , address vrfCoordinatorV2, , , ) = helperConfig
            .activeNetworkConfig();
        return createSubscription(vrfCoordinatorV2);
    }

    function createSubscription(
        address vrfCoordinatorV2
    ) public returns (uint64) {
        console.log("Creating sub on ChainId: ", block.chainid);
        vm.startBroadcast();
        uint64 subId = VRFCoordinatorV2Mock(vrfCoordinatorV2)
            .createSubscription();
        vm.stopBroadcast();
        console.log("Your sub Id is: ", subId);
        console.log("Please update sub Id in HelperConfig.s.sol");
    }

    function run() external returns (uint64) {
        return createSubscriptionUsingConfig();
    }

    contract FundSubscription is Script {
        uint96 public constant FUND_AMOUNT = 3 ether;

        function fundSubscriptionUsingConfig() public {
            HelperConfig helperConfig = new HelperConfig();
            (, , address vrfCoordinatorV2, , uint64 subId, ) = helperConfig
            .activeNetworkConfig();
        }

        function run() external {
            FundSubscriptionUsingConfig();
        }
    }
}
