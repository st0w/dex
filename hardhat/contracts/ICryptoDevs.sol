// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface ICryptoDevs {
    // Get the tokenId for a user's token at index
    function tokenOfOwnerByIndex(address owner, uint256 idx) external view returns (uint256 tokenId);

    function balanceOf(address owner) external view returns (uint256 balance);
}
