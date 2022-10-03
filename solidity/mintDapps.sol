// SPDX-License-Identifier: UNLISCENSED
pragma solidity ^0.8.4;

interface ERC20 {
    
    function balanceOf(address account) external view returns (uint256);

    function decimals() external view returns (uint8);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
 
}

contract TokenFaucet {
    
    ERC20 token;
    
    address owner;
    
    constructor (address _tokenAddress, address _ownerAddress) {
        token = ERC20(_tokenAddress);
        owner = _ownerAddress;
    }
    
    modifier onlyOwner{
        require(msg.sender == owner,"FaucetError: Caller not owner");
        _;
    }

    function mintToken(uint256 _amount) payable external {
        require(token.balanceOf(address(this)) > _amount, "FaucetError: ");
        require(msg.value == 10**token.decimals() / 1000 * _amount, "FaucetError: ");
        
        token.transfer(msg.sender, _amount * 10**token.decimals());
    }

    function setTokenAddress(address _addToken) external onlyOwner {
        token = ERC20(_addToken);
    }
     
    function withdrawTokens(address _receiver, uint256 _amount) external onlyOwner {
        require(token.balanceOf(address(this)) >= _amount,"FaucetError: Insufficient funds");
        token.transfer(_receiver,_amount);
    }
}