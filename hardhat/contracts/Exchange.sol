// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {

    address cryptoDevTokenAddress;
    // mapping (address => uint256) ethUserLiquidity;
    // mapping (address => uint256) cdTokenUserLiquidity;

    /// @param _CryptoDevToken address of the deployed CryptoDevToken contract
    constructor(address _CryptoDevToken) ERC20("CryptoDev LP Token", "CDLP") {
        require(_CryptoDevToken != address(0), "Token address passed cannot be null address");

        cryptoDevTokenAddress = _CryptoDevToken;
    }

    function getReserve() view public returns (uint256) {
        // Want to determine the remaining balance of Crypto Dev tokens 
        // (*NOT* LP tokens, which this contract mints)
        return ERC20(cryptoDevTokenAddress).balanceOf(address(this));
    }

    function addLiquidity(uint _cdtProvided) public payable returns (uint) {
        // uint256 _cdtProvided = tokens.length; // tokens provided
        ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);

        uint256 _cdtAvailable = cryptoDevToken.balanceOf(msg.sender);
        require(_cdtProvided >= _cdtAvailable, "Cannot provide more CDEV tokens than you have");

        uint256 _cdtReserve = getReserve(); // number of tokens in reserve

        uint256 _ethProvided = msg.value;
        uint256 _ethReserve = address(this).balance - msg.value;
        
        uint256 _lpToProvide = 0;

        require(msg.value > 0, "Must pass some ETH to provide liquidity.");
        require(_cdtProvided > 0, "Must pass some tokens to provide liquidity.");


        if(_cdtReserve > 0){
            /* If reserve is zero, this is the first time something is adding
             * tokens and Eth. So we don't have to maintain a ratio.
             *
             * But if there is reserve, they have to meet the ratio
             * Ratio is (cryptoDevTokenAmount user can add/cryptoDevTokenReserve in the contract) 
             *   = (Eth Sent by the user/Eth Reserve in the contract)
             *
             *  (cryptoDevTokenAmount user can add/Eth Sent by the user) 
             *   = (cryptoDevTokenReserve in the contract/Eth Reserve in the contract)
             *
             * This ratio decides how much Crypto Dev tokens user can supply given a 
             * certain amount of Eth, so final equation:
             *
             *  cryptoDevTokenAmount user can add
             *   = Eth Sent by the user * (cryptoDevTokenReserve in the contract
             *          /Eth Reserve in the contract)
             */
            uint256 _cdtAllowed = (_ethProvided/_ethReserve) * _cdtReserve;
            require(_cdtProvided >= _cdtAllowed, "Not enough CryptoDev tokens provided");
            _cdtProvided = _cdtAllowed; // If they provided more than they're allowed, decrease it

            /*
             * The ratio is
             * (LP tokens to be sent to the user(liquidity) / totalSupply of LP tokens in contract)
             *   = (eth sent by the user) / (eth reserve in the contract)
             *
             * LP tokens to be sent to the user(liquidity) = 
             *   (eth sent by the user * total supply of LP tokens in contract) / (eth reserve in contract)
             */
            // _lpToProvide = (_ethProvided / _ethReserve) * _cdtReserve;
            _lpToProvide = (_ethProvided / _ethReserve) * totalSupply();
        }
        else if (_cdtReserve == 0) {
            // When no liquidity, provide the same number of LP tokens as Eth provided
            _lpToProvide = _ethProvided;
        }
        else {
            require(false, "Fatal error. Should never get here.");
        }

        // Accept their liquidity.
        require(cryptoDevToken.transferFrom(
            msg.sender, address(this), _cdtProvided), "Transfer of CDEV failed.");
        
        // Mint LP tokens
        _mint(msg.sender, _lpToProvide);

        // Track how much liquidity they provided
        // ethUserLiquidity[msg.sender] += _ethProvided;
        // cdTokenUserLiquidity[msg.sender] += _cdtProvided;

        return _lpToProvide;
    }

    function removeLiquidity(uint256 _lpTokens) public returns (uint256, uint256) {
        // Amount of eth to send back is based on ratio:
        // (Eth sent back to the user/ Current Eth reserve)
        //   = (amount of LP tokens that user wants to withdraw)/ Total supply of LP tokens)
        //
        // Eth sent back to the user = (Current Eth reserve) 
        //      * (amount of LP tokens that user wants to withdraw)/ Total supply of LP tokens)
        require(_lpTokens > 0, "Need to remove more than 0");
        require(transferFrom(msg.sender, address(this), _lpTokens),
            "Could not transfer LP tokens from user back to DEX");
        ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);

        uint256 _ethReturned = address(this).balance * (_lpTokens/totalSupply());
        uint256 _cdtReturned = getReserve() * (_lpTokens/totalSupply());
        _burn(msg.sender, _lpTokens); // Burn their tokens

        require(cryptoDevToken.transfer(msg.sender, _cdtReturned), "Failed to transfer CDEV tokens back");
        require(payable(msg.sender).send(_ethReturned), "Failed to transfer ETH back");

        return(_ethReturned, _cdtReturned);
    }

    function getAmountOfTokens(
        uint256 _inTokens, uint256 _inReserve, uint256 _outReserve
    ) public pure returns (uint256 _outTokens){
        require(_inReserve > 0 && _outReserve > 0, "Reserves must both be greater than 0.");
        _inTokens = (_inTokens * 99)/100; // take 1%
        _outTokens = (_outReserve * _inTokens)/(_inReserve + _inTokens);
    }

    function ethToCryptoDevToken(uint256 _minTokens) public payable {
        uint256 cdtReserve = getReserve();
        uint256 ethReserve = address(this).balance - msg.value;
        uint256 outCdt = getAmountOfTokens(msg.value, ethReserve, cdtReserve);
        require(outCdt >= _minTokens, "Insufficient output amount of tokens");

        require(
            ERC20(cryptoDevTokenAddress).transfer(msg.sender, outCdt), 
            "Failed to transfer CDEV tokens to user"
        );
    }

    function cryptoDevTokenToEth(uint256 _inTokens, uint256 _minEth) public {
        ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);

        uint256 cdtAvailable = cryptoDevToken.balanceOf(msg.sender);
        require(cdtAvailable >= _inTokens, "You don't have enough tokens");

        uint256 cdtReserve = getReserve();
        uint256 ethReserve = address(this).balance;
        uint256 outEth = getAmountOfTokens(_inTokens, cdtReserve, ethReserve);
        require(outEth >= _minEth, "Insufficient output ETH");

        require(
            cryptoDevToken.transferFrom(msg.sender, address(this), _inTokens),
            "Failed to transfer tokens from user"
        );

        (bool sent, ) = payable(msg.sender).call{value: outEth}("");
        require(sent, "Failed to send ETH");
    }
}

// Deployed to Rinkeby at 0x81B34C7318b4D679a1D42cb9f81Ce3961eB58c5E
// Deployed to local Ganache at 0xd4538fB74a895e1F6D758161EdC7fbdE013dD98f