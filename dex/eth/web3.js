// ---*< React/Next Imports >*-----------------------------------------

// ---*< Third-party Imports >*----------------------------------------
import Web3 from "web3";

// ---*< Local Imports >*----------------------------------------------

// ---*< Declarations >*-----------------------------------------------
let _provider;

// ---*< Code >*-------------------------------------------------------
// Browser-side and web3 already available e.g. MetaMask
if (typeof window !== "undefined" && typeof window.ethereum !== 'undefined'){
    _provider = window.ethereum;
} else {
    // Either running server-side, or browser without MetaMask
    // Connect to local provider (but can switch to Rinkeby via Infura or whatever else
    _provider = new Web3.providers.HttpProvider('http://127.0.0.1:7545');
}

const web3 = new Web3(_provider);

// ---*< Exports >*----------------------------------------------------
export default web3;