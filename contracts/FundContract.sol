// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract FundContract {
    struct FundCampaign {
        address owner; //types the campaing object have
        string title;
        string description;
        uint256 target; //targetamount
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators; //array of address donators
        uint256[] donations; //array of numbers for donations
    }

    mapping(uint256 => FundCampaign) public fundCampaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        FundCampaign storage campaign = fundCampaigns[numberOfCampaigns];
        console.log("campaign", campaign.deadline);
        console.log("numberOfCampaigns", numberOfCampaigns);
        require(
            campaign.deadline < block.timestamp, //if deadline is in past it will throw error
            "The deadline should be a date in the future."
        );
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;
        return numberOfCampaigns - 1;
    }

    function getCampaigns() public view returns (FundCampaign[] memory) {
        FundCampaign[] memory allCampaigns = new FundCampaign[](
            numberOfCampaigns
        );
        console.log("numberOfCampaigns", numberOfCampaigns);
        for (uint i = 0; i < numberOfCampaigns; i++) {
            console.log("i : ", i);
            FundCampaign storage item = fundCampaigns[i];
            allCampaigns[i] = item;
        }
        return allCampaigns;
    }

    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        FundCampaign storage campaign = fundCampaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        return (fundCampaigns[_id].donators, fundCampaigns[_id].donations);
    }
}
