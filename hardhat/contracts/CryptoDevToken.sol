// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {
    // Price of one token
    uint256 public constant tokenPrice = 0.001 ether;

    // Each NFT gives user 10 tokens. Default smallest value of ERC20 tokens
    // is 10^(-18). One full token is (10^18)
    uint256 public constant tokensPerNFT = 10 * 10**18;

    // Max total supply = 10,000 tokens
    uint256 public constant maxTotalSupply = 10000 * 10**18;

    // NFT contract instance
    ICryptoDevs CryptoDevsNFT;

    // Which tokens have been claimed
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    // Mints `amount` tokens
    function mint(uint256 amount) public payable {
        uint256 _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "Ether sent is incorrect");

        // total tokens + amount <= 10000, otherwise revert
        uint256 amountWithDecimals = amount * 10**18;
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply,
            "Exceeds the max total supply available."
        );

        _mint(msg.sender, amountWithDecimals);
    }

    // Mints tokens based on the number of NFTs held by sender
    function claim() public {
        address sender = msg.sender;

        // Get number of NFTs held by sender
        uint256 balance = CryptoDevsNFT.balanceOf(sender);

        require(balance > 0, "You dont own any Crypto Dev NFTs");

        // tracks number of unclaimed tokenIds
        uint256 amount = 0;

        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);

            // If not claimed, increase amount
            if (!tokenIdsClaimed[tokenId]) {
                amount++;
                tokenIdsClaimed[tokenId] = true;
            }
        }

        // Revert if they've already claimed everything
        require(amount > 0, "You have already claimed all the tokens");

        _mint(msg.sender, amount * tokensPerNFT);
    }

    // Function to receive Ether must be empty
    receive() external payable {}

    // Fallback when msg.data is not empty
    fallback() external payable {}

}

// Deployed to Rinkeby at 0x5eAd3E65F6E81cE6C7Fbc59Ac6Fd6bbF34AF0219
// Deployed to local Ganache at 0x58959C298065591c02d978ef148E8E86D93736C5
