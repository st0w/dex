// ---*< React/Next Imports >*-----------------------------------------

// ---*< Third-party Imports >*----------------------------------------

// ---*< Local Imports >*----------------------------------------------
import web3 from "./web3";
import CryptoDevToken from "../../hardhat/contracts/artifacts/CryptoDevToken.json";
import Exchange from "../../hardhat/contracts/artifacts/Exchange.json";

// ---*< Declarations >*-----------------------------------------------
// Rinkeby
// DEX_CONTRACT_ADDRESS="0x81B34C7318b4D679a1D42cb9f81Ce3961eB58c5E"
// CRYPTODEVTOKEN_CONTRACT_ADDRESS="0x5eAd3E65F6E81cE6C7Fbc59Ac6Fd6bbF34AF0219"

// Local Ganache
const DEX_CONTRACT_ADDRESS="0xd4538fB74a895e1F6D758161EdC7fbdE013dD98f";
const CRYPTODEVTOKEN_CONTRACT_ADDRESS="0x58959C298065591c02d978ef148E8E86D93736C5";

const DEX_ABI = Exchange.abi;
const CRYPTODEVTOKEN_ABI = CryptoDevToken.abi;

// ---*< Code >*-------------------------------------------------------
const cryptoDevToken = new web3.eth.Contract(
    CRYPTODEVTOKEN_ABI,
    CRYPTODEVTOKEN_CONTRACT_ADDRESS
);

const exchange = new web3.eth.Contract(
    DEX_ABI,
    DEX_CONTRACT_ADDRESS
);

const getCdtBalance = async (_address) => {
    return await cryptoDevToken.methods.balanceOf(_address).call();
};

const getLpBalance = async (_address) => {
    return await exchange.methods.balanceOf(_address).call();
};

// ---*< Exports >*----------------------------------------------------
export {cryptoDevToken, exchange, getCdtBalance, getLpBalance};
