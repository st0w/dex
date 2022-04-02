// ---*< React/Next Imports >*-----------------------------------------

// ---*< Third-party Imports >*----------------------------------------
import {Button} from "semantic-ui-react";
import Web3Modal from "web3modal";

// ---*< Local Imports >*----------------------------------------------
import web3 from "../eth/web3";

// ---*< Declarations >*-----------------------------------------------
// let Web3Modal;
// if (typeof window !== "undefined"){
//     Web3Modal = window.Web3Modal.default;
// }
// const WalletConnectProvider = window.WalletConnectProvider.default;
// const Fortmatic = window.Fortmatic;
// const evmChains = window.evmChains;
let web3modal;
let provider;
let selectedAccount;

// ---*< Code >*-------------------------------------------------------


const WalletButton = ({getter, setter}) => {
    if (getter) {
        return "";
    }

    const onConnect = async (e) => {
        e.preventDefault();

        const providerOptions = {};
        web3modal = new Web3Modal({
            providerOptions
            // disableInjectedProvider: false
        });

        try {
            provider = await web3modal.connect();
            setter(true);
        } catch(e) {
            console.log("Could not get a wallet connection", e);
            return;
        }

    };

    return (
        <Button primary onClick={onConnect}>Connect wallet</Button>
    );
};

// ---*< Exports >*----------------------------------------------------
export default WalletButton;
export {web3modal, provider};