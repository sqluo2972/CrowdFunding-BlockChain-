// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.16;

contract CampaignFactory{
    address[] public deployedCampaign;

    function createCampaign(uint minimum) public{
        address newCampaign = address(new Campaign(minimum,msg.sender));
        deployedCampaign.push(newCampaign);
    }

    function getDeployedCampaign() public view returns(address[] memory){
        return deployedCampaign;
    }
}

contract Campaign{
    struct Request{
        string description;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }

    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approver;
    uint public approversCount;

    modifier restricted(){
        require(msg.sender==manager);
        _;
    }

    constructor(uint minimum,address creator){
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable{
        require(msg.value > minimumContribution);
        approver[msg.sender] = true;
        approversCount++;
    }

    function creatRequest(string memory description,uint value,address payable recipient)
        public restricted{
            Request storage newRequest = requests.push();  // return reference
            newRequest.description = description;
            newRequest.value= value;
            newRequest.recipient= recipient;
            newRequest.complete= false;
            newRequest.approvalCount = 0;
        }

    function approveRequest(uint index) public {
        Request storage request = requests[index];
        require(approver[msg.sender]);
        require(!request.approvals[msg.sender]); // only can vote one time
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public restricted{
        Request storage request = requests[index];
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);
        request.recipient.transfer(request.value);
        request.complete = true;
    }

    function getSummary() public view returns(uint,uint,uint,uint,address) {
        return(
            minimumContribution,
            address(this).balance,
            requests.length,
            approversCount,
            manager
          );
    }

    function getRequestsCount() public view returns(uint){
        return requests.length;
    }
}
