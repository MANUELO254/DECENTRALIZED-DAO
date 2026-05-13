//SPDX=License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {MyGovernor} from "../src/MyGovernor.sol";   
import {TimeLock} from "../src/TimeLock.sol";
import {GovToken} from "../src/GovToken.sol";
import {Box} from "../src/Box.sol";


contract MyGovernorTest is Test{

    MyGovernor governor;
    Box box;
    TimeLock timeLock;
    GovToken govToken;

    address public USER = makeAddr("USER");
    address public constant INITIAL_SUPPLY = 100 ether;

    uint256 public constant MIN_DELAY = 3600; // 1 hour
    uint256 public constant VOTING_DELAY = 1; // 1 week
    uint256 public constant VOTING_PERIOD = 50400; // 1 week

    address [] proposers;
    address [] executors;
    uint256 [] values;
    bytes [] calldatas;
    address [] targets;

    function setUp() public {
        govToken = new GovToken();
        govToken.mint(USER, INITIAL_SUPPLY);

        vm.startBroadcast(USER);
        govToken.delegate(USER);
        timeLock = new TimeLock(MIN_DELAY, proposers, executors);
        governor = new MyGovernor(govToken, timeLock);

        bytes32 proposerRole = timeLock.PROPOSER_ROLE();
        bytes32 executorRole = timeLock.EXECUTOR_ROLE();
        bytes32 adminRole = timeLock.TIMELOCK_ADMIN_ROLE();

        timeLock.grantRole(proposerRole, address(governor));
        timeLock.grantRole(executorRole, address(0));
        timeLock.revokeRole(adminRole, USER);
        vm.stopBroadcast();

        box = new Box();
        box.transferOwnership(address(timeLock));
    }

    function testCanUpdateBoxWithoutGovernance() public{
        vm.expectRevert();
        box.store(42);
    }

    function testGovernanceUpdatesBox() public {
        uint256 valueToStore = 42;
        string memory description = "Proposal #1: Store 42 in the Box";
        bytes memory callData = abi.encodeWithSignature("store(uint256)", valueToStore);
        
        values.push(0);
        calldatas.push(callData);
        targets.push(address(box));

        //Propose to the DAO
        uint256 propossalId = governor.propose(targets, values, calldatas, description);

        //view state of the proposal
        console.log("Proposal State after proposing:", uint256(governor.state(propossalId)));   

        vm.warp(block.timestamp + VOTING_DELAY + 1); // Move forward in time to start voting    
        vm.roll(block.number + VOTING_DELAY + 1); // Move forward in blocks to start voting 

        //Vote on the proposal
        string memory reason = "I like this proposal";

        uint8 voteWay = 1; // 0 = Against, 1 = For, 2 = Abstain
        vm.prank(USER);
        governor.castVote(propossalId, voteWay, reason);

        vm.warp(block.timestamp + VOTING_PERIOD + 1); // Move forward in time to end voting    
        vm.roll(block.number + VOTING_PERIOD + 1); // Move forward in blocks to end voting

        //Queue the proposal
        bytes32 descriptionHash = keccak256(bytes(description));
        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + MIN_DELAY + 1); // Move forward in time to execute the proposal    
        vm.roll(block.number + 1); // Move forward in blocks to execute the proposal

        //Execute the proposal
        governor.execute(targets, values, calldatas, descriptionHash);

        //Check if the value was updated in the Box
        console.log("Value in Box after execution:", box.getNumber());
        assert(box.getNumber() == valueToStore); 


    }

}