pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import  "./utils/OwnerExtension.sol";

/*
Main contract module which is responsible for everything
that is related to Wallet functionalities
*/
contract SharedWallet is OwnerExtension{
    
    /**
    Variable that collects all the parties that will 
    interact with each other so in the end being added
    to this variable then can carry out transactions 
    with other entitled user among the limited network
    */
    mapping(address => uint) public allowance;
    
    /**
    Method allows to add new users to the hash-map table,
    in this case to "allowance" mapper
    */
    function addAllowance(address _who, uint _amount) public {
        allowance[_who] = _amount;
    }
    
    /*
    Modifier that encapsulates requirements logic
    */
    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] > _amount, "You are not allowed");
        _;
    }
    
    
    /*
    Method that serves for withdrawing money and checking out 
    if an owner who is calling this method is an initial caller
    who started the transaction
    */
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed {
        _to.transfer(_amount);
    }
    
    fallback() external payable {}
}
