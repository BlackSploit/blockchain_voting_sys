// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Bambu {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 voteCollected;
        string image;
        address[] voters;
        uint256[] votes;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberofCampaigns = 0;

    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256){ // _ => its a paramter to only this specific fn, returns id
        Campaign storage campaign = campaigns[numberofCampaigns];


        //is everything okay, code wont preceed if this condition is not satisfies
        require(campaign.deadline < block.timestamp, "The deadline should be a date in future");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target= _target;
        campaign.deadline = _deadline;
        campaign.voteCollected = 0;
        campaign.image = _image;

        numberofCampaigns++;


        return numberofCampaigns-1;
    }


    function voteToCampaign(uint256 _id) public payable{ 
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.voters.push(msg.sender);
        campaign.votes.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if(sent){
            campaign.voteCollected = campaign.voteCollected + amount;
        }
    }

    function getVoters(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].voters, campaigns[_id].votes);
    }

    function getCampaigns() public view returns (Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberofCampaigns);     

        for(uint i=0; i<numberofCampaigns; i++){
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }
        return allCampaigns;
    }


}