// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
    string _baseTokenURI;

    // price of one NFT
    uint256 public _price = 0.01 ether;

    // pauses the contract in case of an emergency
    bool public _paused;

    // max number of tokens
    uint256 public maxTokenIds = 20;

    // total number minted
    uint256 public tokenIds;

    // Whitelist contract instance
    IWhitelist whitelist;

    bool public presaleStarted;

    // timestamp for when presale ends
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused.");
        _;
    }

    /*
     * ERC721 constructor requires name and symbol
     * Our constructor requires baseURI for collection, and address of a Whitelist contract
     */
    constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD"){
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        presaleStarted = true;

        // Set presale ending time as 5 minutes after current time
        presaleEnded = block.timestamp + 5 minutes;
    }

    // Allow a user to mint one NFT per transaction during presale
    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale is not running");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        require(tokenIds < maxTokenIds, "Exceeded maximum Crypto Devs supply");
        require(msg.value >= _price, "Ether sent is not correct");

        tokenIds++;

        // use _safeMint to ensure if minting to a contract, it knows how to deal with ERC721 tokens
        _safeMint(msg.sender, tokenIds);
    }

    // Allow a user to mint one NFT per transaction after presale
    function mint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp >= presaleEnded, "Presale has not ended yet");
        require(tokenIds < maxTokenIds, "Exceeded maximum Crypto Devs supply");
        require(msg.value >= _price, "Ether sent is not correct");

        tokenIds++;
        _safeMint(msg.sender, tokenIds);
    }

    // override ERC721 implementation, which by default returns an empty string
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    // Send all the ether in the contract to the contract owner
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Function to receive Ether msg.data must be empty
    receive() external payable {}

    // Fallback is called when msg.data is not empty
    fallback() external payable {}
}

// First deployment, weird... dont use this... Deployed to 0x5FbDB2315678afecb367f032d93F642f64180aa3 on Rinkeby using Hardhat

// Deployed to 0xC1B820aA856859459483BAc6f6bB8124248780e1 on Rinkeby using Hardhat
// Latest Rinkeby deployment: 0xE6efb02906e4C13636235f2Ff83706859E85dc32

